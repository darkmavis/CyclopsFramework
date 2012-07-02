/**
 * Cyclops Framework
 * 
 * Copyright 2010, 2011, 2012 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyclopsframework.core
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.utils.collections.CFDataStore;
	import org.cyclopsframework.utils.collections.CFRegistry;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.proxies.CFMessageProxy;
	
	/**
	 * <p>CFEngine is the heart of the Cyclops Framework, and it's all that you need to get started.
	 * An engine controls sequencing, timing, tagging, messaging, and proxies.</p>
	 * 
	 * <p>Feel free to create as many CFEngines as required throughout your project.</p>
	 * 
	 */
	public class CFEngine
	{
		/**
		 * All tagged objects contain this tag. 
		 */		
		public static const TAG_ALL:String = "*";
		
		/**
		 * The registry stores the relationships between tags and tagged objects. 
		 */		
		private var _registry:CFRegistry = new CFRegistry();
		
		/**
		 * This contains all actions to be processed at the beginning of a frame. 
		 */		
		private var _actions:Array = [];
		
		/**
		 * This contains all actions to be added on a given frame after general processing is complete. 
		 */		
		private var _additions:Array = [];
		
		/**
		 * This contains all actions to be removed on a given frame after general processing is complete. 
		 */		
		private var _removals:Array = [];
		
		/**
		 * This contains stop requests (by tag) for tagged objects.
		 * Any object with a requested tag will be stopped.
		 * If multiple objects contain the same tag, they will all be stopped.
		 */		
		private var _stopsRequested:Array = [];
		
		/**
		 * This contains all messages to be sent after general processing is complete.
		 */		
		private var _messages:Array = [];
		
		/**
		 * <p>This contains pause requests (by tag) for tagged objects.
		 * Any object with a requested tag will be paused.
		 * If multiple objects contain the same tag, they will all be paused.</p>
		 * <p>Please note that pause requests are processed after resume requests.
		 * Items that have just been resumed are still eligible to be paused.</p>
		 */
		private var _pausesRequested:CFStringHashSet = new CFStringHashSet();
		
		/**
		 * <p>This contains resume requests (by tag) for currently paused tagged objects.
		 * Any object with a requested tag will be resumed if already paused.
		 * If multiple objects contain the same tag, they will all be resumed.</p>
		 * <p>Please note that pause requests are processed after resume requests.
		 * Items that have just been resumed are still eligible to be paused.</p>
		 */
		private var _resumesRequested:CFStringHashSet = new CFStringHashSet();
		
		/**
		 * <p>This contains block requests (by tag) for tagged objects.
		 * Block requests prevent a tagged object from being added at anytime during the current frame
		 * if it contains a specified tag.</p>
		 * <p>This prevent sometimes unforseen concurrency issues such as that where
		 * a message delivery might cause a tagged object to be added after removals are complete.</p>
		 */		
		private var _blocksRequested:CFStringHashSet = new CFStringHashSet();
		
		/**
		 * This contains tags that should be automatically added to a tagged object during the addition of that object.
		 * These tags are added in addition to the tags that the tagged object already has. 
		 */		
		private var _autotags:CFStringHashSet = new CFStringHashSet();
		
		/**
		 * This contains functions that should be called before any other processing is done for a given frame.
		 * These functions are only called once and must be added again to be called on another frame.
		 * Unless this functionality is absolutely required, functions should instead be added as actions.
		 */
		private var _delayedFunctions:Array = [];
		
		/**
		 * This provides access to the current action.
		 * It's very useful when used from within anonymous functions.
		 */		
		private var _context:CFAction;
		
		/**
		 * This gets the current action.
		 * It's very useful when used from within anonymous functions.
		 */
		public function get context():CFAction { return _context; }
		
		/**
		 * @private
		 * This sets current action.
		 * This is for internal framework use only.
		 */
		public function set context(value:CFAction):void { _context = value; }
		
		/**
		 * In very rare situations that absolutely require it, data can be stored for the current frame.
		 * This data will not persist past the end of the current frame.
		 * Use this only if you must, and then with caution.
		 */		
		private var _frameData:Object = {};
		
		/**
		 * <p>Gets the object that stores frame date.
		 * In very rare situations that absolutely require it, data can be stored for the current frame.
		 * This data will not persist past the end of the current frame.</p>
		 * <p>Use this only if you must, and then use with caution.
		 * If abused, code could get ugly.</p>2
		 */
		public function get frameData():Object { return _frameData; }
		
		/**
		 * This is the delta time between this frame and the last. 
		 */		
		private var _delta:Number = 1 / 60;
		
		/**
		 * This gets the delta time between this frame and the last.
		 */		
		public function get delta():Number { return _delta; }
		
		/**
		 * This gets the current frames per second.
		 * This value applies to the current frame only and is not smoothed.
		 */		
		public function get fps():Number { return 1 / _delta; }
		
		/**
		 * This object contains many methods that are common to both CFEngine and CFAction.
		 * These methods wrap common actions and can be considered syntactic sugar.
		 */		
		private var _sugar:CFSugar;
		
		/**
		 * Gets the object which contains many methods that are common to both CFEngine and CFAction.
		 * These methods wrap common actions and can be considered syntactic sugar.
		 */		
		public function get sugar():CFSugar { return _sugar; }
		
		/**
		 * <p>This is the constructor for CFEngine.  
		 * Feel free to create as many CFEngines as required throughout your project.</p>
		 * 
		 * <p>CFEngine is the heart of the Cyclops Framework, and it's all that you need to get started.
		 * An engine controls sequencing, timing, tagging, messaging, and proxies.</p>
		 */
		public function CFEngine()
		{
			beginTag(TAG_ALL);
			_sugar = new CFSugar(this);
		}
		
		// Sequencing Tags
		
		/**
		 * <p>Use this to add an autotag.</p>
		 * 
		 * <p>Autotags are tags that will be automatically applied to any tagged object when it is added.
		 * This is in addition to the tags that the tagged object already has.
		 * Autotags will remain in affect until removed via the endTag() method.</p>
		 * 
		 * @param tag
		 * This is the autotag to be put into effect.
		 * 
		 */		
		public function beginTag(tag:String):void
		{
			_autotags.addItem(tag);
		}
		
		/**
		 * <p>Use this remove an autotag.</p>
		 * 
		 * <p>Autotags are tags that will be automatically applied to any tagged object when it is added.
		 * This is in addition to the tags that the tagged object already has.
		 * Autotags will remain in affect until removed via this method.</p>
		 * 
		 * @param tag
		 * This is the autotag to be removed.
		 * 
		 */
		public function endTag(tag:String):void
		{
			_autotags.removeItem(tag);
		}
		
		/**
		 * <p>This applies all active autotags to a tagged object.</p>
		 * 
		 * <p>Autotags are tags that will be automatically applied to any tagged object when it is added.
		 * This is in addition to the tags that the tagged object already has.
		 * Autotags will remain in affect until removed via the endTag() method.</p>
		 * 
		 * @param o
		 * This is the target object that active autotags will be applied to.
		 * 
		 */		
		private function applyAutotags(o:ICFTaggable):void
		{
			for each (var tag:String in _autotags.items)
			{
				o.tags.addItem(tag);
			}
		}
		
		// Sequencing + TaggedObject Additions/Registration
		
		/**
		 * <p>This adds actions, functions, and tagged objects to the engine for use on the next frame.
		 * It can also be used to tag objects at the same time.
		 * It is possibly the most commonly used method in the entire framework.</p>
		 * 
		 * <p><b>Valid Parameters</b><br>
		 * <l>
		 * <li>Array</li>
		 * <li>CFAction</li>
		 * <li>Function</li>
		 * <li>ICFTaggable</li>
		 * <li>String</li>
		 * </l>
		 * </p>
		 * 
		 * <p><b>Array</b><br>
		 * An array can contain any of the valid parameters and operates the same way that the method's arguments do,
		 * except that any previously listed (and active) tags will be applied to all objects within the array.
		 * Arrays can be nested.</p>
		 * 
		 * <p><b>CFAction</b><br>
		 * Multiple actions can be added, but they will not be sequenced.
		 * Instead, they will all start on the same frame.
		 * If tags precede an action, they will be added to the action,
		 * and then removed so as not to be applied to the next concurrent action.</p>
		 * 
		 * <p><b>Function</b><br>
		 * Functions are automatically converted to actions by wrapping them in a <code>CFFunction</code> object.
		 * <code>CFFunction</code> subclasses <code>CFAction</code>.
		 * They behave the same as actions.</p>
		 * 
		 * <p><b>ICFTaggable</b><br>
		 * These are taggable objects and multiple taggable objects can be added.
		 * <code>CFAction</code> implements <code>ICFTaggable</code>, but is special cased here.
		 * Taggable objects that are not actions are added to the registry the same way that actions are,
		 * but aren't automatically processed every frame like actions are.
		 * If tags precede a taggable object, they will be added to it,
		 * but then removed so as not to be applied to the next taggable object.</p>
		 * 
		 * <p><b>String</b><br>
		 * These are tags to be applied to either the next taggable object or all the taggable objects in an array
		 * if an array is the next non-string argument.
		 * Once these tags have been applied to a taggable object or array, they will be discarded,
		 * and will not apply to any following arguments.
		 * In order to apply tags to the remaining arguments, they must be restated.
		 * Multiple tags can be listed before they are applied to an object.
		 * Please note that there are other ways within the API to add tags.</p>
		 * 
		 * <p><b>Additonal Info</b><br>
		 * Because <code>add</code> returns a <code>CFAction</code> object which
		 * contains a method of the same name and identical external behaviour,
		 * it's often very effective to chain additions for sequencing purposes.
		 * Despite the chaining reference, it's important to remember that sequences are actually trees.
		 * The <code>add</code> method supports very complex sequencing arrangements,
		 * but in actual practice, these are rare.  In fact, sequences are usually so easy to follow,
		 * they can be a great tool to communicate program flow with your artist or producer.</p>
		 * 
		 * @param taggedObjects
		 * The following types are valid: Array, CFAction, Function, ICFTaggable, and String 
		 * 
		 * @return
		 * The returned action can be used to build a sequence tree of actions.
		 * 
		 * @example Example
		 * <listing>
		 * 
		 * // Single anonymous function
		 * 
		 * engine.add(function():void { trace("Hello World!"); });
		 * 
		 * // Multiple types
		 * 
		 * const numSeconds:Number = 10;
		 * 
		 * engine
		 *     .add(new CFSleep(numSeconds)) // CFAction
		 *     .add(function():void { trace("We just waited for " + numSeconds + " seconds."); });
		 * 
		 * // With tags
		 * 
		 * engine
		 *     // Adds "foo" tag to CFSleep action.  Note that "foo" is passed on to children.
		 *     .add("foo", new CFSleep(5))
		 *     // Adds "cat" and "dog" to this action.
		 *     .add("cat", "dog", new CFSleep(5))
		 *     // Adds "tag1" and "tag2" to CustomAction1 instance and "tag3" to the CustomAction2 instance.
		 *     // The CustomAction2 instance will not be tagged with "tag1" or "tag2".
		 *     .add("tag1", "tag2", new CustomAction1(), "tag3", new CustomAction2())
		 *     // "tag4" is applied to all items in the array.
		 *     // "tag5" is applied to the CFFunction that wraps the anonymous function.
		 *     // Note that this last group of actions is added to the CustomAction2 instance.
		 *     // This is because the CustomAction2 instance was the last action created.
		 *     .add("tag4", [new CA3(), new CA4(), "tag5", function():void { trace("hi!"); }]);
		 * 
		 * </listing>
		 * 
		 */
		public function add(...taggedObjects):CFAction
		{
			var currTags:Array = [];
			var currAction:CFAction = null;
			
			for each (var o:Object in taggedObjects)
			{
				if (o is CFAction)
				{
					currAction = o as CFAction;
					currAction.engine = this;
					applyAutotags(currAction);
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_additions.push(o);
				}
				else if (o is ICFTaggable)
				{
					var taggedObject:ICFTaggable = o as ICFTaggable;
					if (taggedObject is ICFHasEngine)
					{
						(taggedObject as ICFHasEngine).engine = this;
					}
					applyAutotags(taggedObject);
					if (currTags.length > 0)
					{
						taggedObject.tags.addItems(currTags);
						currTags = [];
					}
					_additions.push(taggedObject);
				}
				else if (o is Function)
				{
					currAction = new CFFunction(0, 1, null, null, o as Function);
					currAction.engine = this;
					applyAutotags(currAction);
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_additions.push(currAction);
				}
				else if (o is Array)
				{
					var contextualTags:Array = [].concat(currTags);
					currTags = [];
					for each (var ao:Object in (o as Array))
					{
						if (ao is String)
						{
							currTags.push(ao); // was o
						}
						else if (ao is Array)
						{
							currAction = add(currTags, contextualTags, ao);
						}
						else
						{
							currAction = add(currTags, contextualTags, ao);
							currTags = [];
						}
					}
				}
				else if (o is String)
				{
					currTags.push(o);
				}
			}
			
			return currAction;
		}
		
		/**
		 * <p>Use this to schedule a non-action-wrapped function to be called on the next frame.
		 * The function will be scheduled to run before any actions are processed.</p>
		 * 
		 * @param f
		 * This is the function to be called on the next frame.
		 * 
		 */		
		public function runNextFrame(f:Function):void
		{
			_delayedFunctions.push(f);
		}
		
		// Control Flow
		
		/**
		 * <p>Use this to pause any tagged objects containing the specified tag that either currently exist
		 * or will exist within the system by the end of this frame. Pauses are processed after resumes.</p>
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 */		
		public function pause(tag:String):void
		{
			_pausesRequested.addItem(tag);
		}
		
		/**
		 * <p>Use this to resume any paused tagged objects containing the specified tag that either currently exist
		 * or will exist within the system by the end of this frame. Pauses are processed after resumes.</p>
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 */		
		public function resume(tag:String):void
		{
			_resumesRequested.addItem(tag);
		}
		
		/**
		 * <p>In the rare case that a tagged object is added while stopping an action, this will prevent
		 * the object from being added if it contains the tag to be blocked.
		 * The specified tag will only blocked for the current frame.
		 * It should be considered bad practice to allow this to occur in the first place,
		 * but this method is provided just in case it is required.</p>
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 */		
		public function block(tag:String):void
		{
			_blocksRequested.addItem(tag);
		}
		
		/**
		 * <p>Use this to remove any tagged objects containing the specified tag that either currently exist
		 * or will exist within the system by the end of this frame.  Actions will be stopped before removal.</p>
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 * @param stopChildren
		 * By default, child actions will be removed too.  Set this to false to enabled child actions to start
		 * after their parent has been removed.  This only applies to actions.
		 * 
		 */
		public function remove(tag:String, stopChildren:Boolean=true):void
		{
			_stopsRequested.push(new CFStopActionRequest(tag, stopChildren));
		}
		
		/**
		 * <p>Use this to remove a tagged object by reference instead of by tag.</p>
		 * 
		 * @param taggedObject
		 * This is the tagged object to be removed.
		 * 
		 */		
		public function removeObject(taggedObject:ICFTaggable):void
		{
			if (taggedObject is CFAction)
			{
				(taggedObject as CFAction).stop();
			}
			else
			{
				_removals.push(taggedObject);
			}
		}
		
		// Registration & Housekeeping
		
		/**
		 * <p>For internal use only, this adds tagged objects to the registry.</p>
		 * 
		 * @param taggedObject
		 * This is the tagged object to add to the registry.
		 * 
		 */		
		private function register(taggedObject:ICFTaggable):void
		{
			for each (var tag:String in taggedObject.tags.items)
			{
				_registry.addObject(tag, taggedObject);
			}
		}
		
		/**
		 * <p>For internal use only, this removes tagged objects from the registry.</p>
		 * 
		 * @param taggedObject
		 * This is the tagged object to remove from the registry.
		 * 
		 */		
		private function unregister(taggedObject:ICFTaggable):void
		{
			for each (var tag:String in taggedObject.tags.items)
			{
				_registry.removeObject(tag, taggedObject);
			}
			
			if(taggedObject is ICFDisposable)
			{
				(taggedObject as ICFDisposable).dispose();
			}
		}
			
		// Querying
		
		/**
		 * <p>Use this to count the number of objects returned by a query containing the specified tags or other criteria.
		 * In order to be selected, each object returned must contain every tag specified in the query
		 * and all functions must return true for an object as well.</p>
		 * 
		 * @param args
		 * Arguments may be tags, tagged objects containing a constant string TAG member which will be
		 * used as a tag, and functions of type: function(o:ICFTaggable):Boolean
		 * 
		 * @return 
		 * This return the number of tagged objects returned as a result of the query. 
		 * 
		 */		
		public function count(...args):int
		{
			if (args.length == 0) return 0;
			return (query.apply(null, args) as Object).numItems;
		}
		
		/**
		 * <p>Use this to select objects containing the specified tags or other criteria.
		 * In order to be selected, each object returned must contain every tag specified in the query
		 * and all functions must return true for an object as well.</p>
		 * 
		 * @param args
		 * Arguments may be tags, tagged objects containing a constant string TAG member which will be
		 * used as a tag, and functions of type: function(o:ICFTaggable):Boolean
		 * 
		 * @return 
		 * This returns a selection of objects returned as a result of the query.
		 * 
		 */		
		public function query(...args):CFDataStore
		{
			if ((args.length == 1) && (args[0] is String))
			{
				return _registry.getObjects(args[0] as String);
			}
			else
			{
				var tagz:Vector.<String> = new Vector.<String>();
				var filterz:Vector.<Function> = new Vector.<Function>();
				
				for each (var arg:Object in args)
				{
					if (arg is Number)
					{
						tagz.push(arg.toString());
					}
					else if (arg != null)
					{
						if (arg is String)
						{
							tagz.push(arg as String);
						}
						else if (arg.hasOwnProperty("TAG") && (arg["TAG"] is String))
						{
							tagz.push(arg["TAG"]);
						}
						else if (arg is Function)
						{
							filterz.push(arg as Function);
						}
						else
						{
							throw(new TypeError("Query argument type not recognized. Valid types are:" +
								"strings, numbers, functions and classes with a public static const TAG:String member"));
						}
					}
				}
				
				if (tagz.length == 0)
				{
					tagz.push(CFEngine.TAG_ALL);
				}
				
				var results:CFDataStore = query(tagz.shift());
				
				for each (var tag:String in tagz)
				{
					results = results.filter(function(o:ICFTaggable):Boolean { return o.tags.has(tag); });
				}
				
				for each (var f:Function in filterz)
				{
					results = results.filter(f);
				}
				
				return results;
			}
		}
		
		/**
		 * <p>Use this to immediately call methods or set properties of every tagged object selected by the query.
		 * This method calls query() internally.  See query() for more information.</p>
		 * 
		 * @param args
		 * Arguments may be tags, tagged objects containing a constant string TAG member which will be
		 * used as a tag, and functions of type: function(o:ICFTaggable):Boolean
		 * 
		 * @return 
		 * An instance of CFDataStoreProxy is returned, but this method is intended to be used as a one-liner.
		 * 
		 */		
		public function proxy(...args):Object // CFDataStoreProxy
		{
			return query.apply(null, args).proxy;
		}
		
		/**
		 * <p>Use this to return the status of every tagged object containing the specified tag.
		 * By default, the status of every tagged object is returned.
		 * This method is very helpful for debugging, especially when used via an embedded console.</p> 
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 * @return 
		 * A status string is returned.
		 * 
		 */
		public function status(tag:String=CFEngine.TAG_ALL):String
		{
			var actions:Array = [];
			var nonActions:Array = [];
			
			query(tag).forEach(function(o:ICFTaggable):void
			{
				if (o is CFAction)
				{	
					actions.push(o);
				}
				else
				{
					nonActions.push(o);
				}
			});
			
			actions = actions.sortOn(["cycles", "period", "position"], Array.DESCENDING);
			
			var result:String = "Actions: (" + actions.length + ")\n";
			
			var comparitor:Function = function(a:String, b:String):int
			{
				a = a.replace("@","").toLowerCase();
				b = b.replace("@","").toLowerCase();
				return (a >= b) ? 1 : (a < b) ? -1 : 0;
			}
			
			for each (var action:CFAction in actions)
			{
				var actionTags:Array = action.tags.toArray();
				
				actionTags.sort(comparitor);
				
				result += ("pos: " + String((int(action.position * 100) == 0) ? "  0" : int(action.position * 100).toPrecision(3))
					.replace(".", "")
					+ "%\t\tcycle: " + action.cycle + "/" + ((action.cycles == Number.MAX_VALUE)
						? String.fromCharCode(8734) : ("" + action.cycles)) 
					+ "\t\t" + actionTags.join(", ")) + "\n";
			}
			
			result += "\nNon-actions: (" + nonActions.length + ")\n";
			
			for each (var nonAction:ICFTaggable in nonActions)
			{
				var nonActionTags:Array = nonAction.tags.toArray();
				
				nonActionTags.sort(comparitor);
				
				result += getQualifiedClassName(nonAction).split("::").slice(-1)[0] + ": " + nonActionTags.join(", ") + "\n";
			}
			
			return result + "\n";
		}
				
		// Messaging
		
		/**
		 * <p>Use this method to send messages using proxy syntax instead of using send or sendMessage.
		 * Using this method is matter of choice and convenience and not a necessity.</p> 
		 * 
		 * @param tag
		 * Use this tag to filter the tagged objects.
		 * 
		 * @param sender
		 * This is an optional argument that will provide the receiver with a sender if need be.
		 * 
		 * @param receiverType
		 * This is an optional argument that will limit receivers to a specified class type.
		 * 
		 * @return 
		 * An instance of CFMessageProxy is returned, but this method is intended to be used as a one-liner.
		 * 
		 */		
		public function sendByProxy(tag:String=TAG_ALL, sender:Object=null, receiverType:Class=null):CFMessageProxy
		{
			return new CFMessageProxy(this, tag, sender, receiverType);
		}
		
		/**
		 * <p>Use this to send a prepackaged message.</p>
		 * 
		 * @param msg
		 * This is the message to be sent.
		 * All required information regarding sender, receiver, and payload is contained within the message.
		 * 
		 */		
		public function sendMessage(msg:CFMessage):void
		{
			_messages.push(msg);
		}
		
		/**
		 * <p>Use this to send a message to a group of tagged objects.  This may be the most common messaging method.
		 * The only required arguments are receiverTag and name.</p>
		 * 
		 * @param receiverTag
		 * All receivers must contain this tag in order to receive the message.
		 * 
		 * @param name
		 * This is either the name of the method to apply or property to set.
		 * 
		 * @param data
		 * This optional argument is either a list of arguments to apply to a method
		 * or a chain of properties to traverse followed by the value to be set.
		 * 
		 * @param sender
		 * This is an optional argument that will provide the receiver with a sender if need be.
		 * 
		 * @param receiverType
		 * This is an optional argument that will limit receivers to a specified class type.
		 * 
		 */		
		public function send(receiverTag:String, name:String, data:Array=null, sender:Object=null, receiverType:Class=null):void
		{
			sendMessage(new CFMessage(receiverTag, name, data, sender, receiverType));
		}
		
		/**
		 * <p>For internal use only, this handles message delivery.</p>
		 * 
		 * @param msg
		 * This is the prepackaged message to deliver.
		 * 
		 * @param receiver
		 * This is the potential receiver.  Criteria must be met in order for the message to be delivered.
		 * 
		 */		
		private function deliverMessage(msg:CFMessage, receiver:Object):void
		{
			if(msg.receiverType != null)
			{
				if(!(receiver is msg.receiverType))
				{
					return;
				}
			}
			
			if (receiver is ICFMessageInterceptor)
			{
				(receiver as ICFMessageInterceptor).interceptMessage(msg);
			}
			
			if (msg.canceled)
			{
				return;
			}
			
			var currName:String = msg.name;
			var currReceiver:Object = receiver;
			
			while (currReceiver.hasOwnProperty(currName))
			{
				if (currReceiver[currName] is Function)
				{
					(currReceiver[currName] as Function).apply(currReceiver, msg.data);
					break;
				}
				else if (msg.data.length > 1)
				{
					currReceiver = currReceiver[currName];
					currName = msg.data.shift();
				}
				else
				{
					currReceiver[msg.name] = msg.data[0];
					break;
				}
			}
		}
		
		// Updates
		
		/**
		 * <p>For internal use only and called by update(), this processes delayed functions.
		 * See: runNextFrame()</p>
		 * 
		 */		
		private function processDelayedFunctions():void
		{
			while (_delayedFunctions.length > 0)
			{
				_delayedFunctions.shift().apply();
			}
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes actions that were
		 * added in a previous frame.
		 * See: add()</p>
		 * 
		 * @param delta
		 * This is the time elapsed since the last frame, measured in seconds.
		 * 
		 */		
		private function processActions(delta:Number):void
		{
			var actionCount:int = _actions.length;
						
			for (var i:int = 0; i < actionCount; ++i)
			{
				var action:CFAction = _actions.shift();
				_actions.push(action);
				
				if (!action.paused)
				{
					_context = action;
					action.update(delta);
				}
			}
			
			_context = null;
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes messages for delivery.
		 * See: send()</p>
		 * 
		 */		
		private function processMessages():void
		{
			while (_messages.length > 0)
			{
				var msg:CFMessage = _messages.shift();
				
				if(_registry.has(msg.receiverTag))
				{
					query(msg.receiverTag).forEach(function(o:ICFTaggable):void
					{
						deliverMessage(msg, o);
					});
				}
			}
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes stop requests.
		 * See: remove()</p>
		 * 
		 */		
		private function processStopRequests():void
		{
			while (_stopsRequested.length > 0)
			{
				var request:CFStopActionRequest = _stopsRequested.shift();
				if (_registry.has(request.actionTag))
				{
					//for each (var action:CFAction in _registry.getObjects(request.actionTag))
					_registry.getObjects(request.actionTag).forEach(function(item:ICFTaggable):void
					{
						if(item != null)
						{
							if (item is CFAction)
							{
								if (request.stopChildren)
								{
									(item as CFAction).removeChildren();
								}
								(item as CFAction).stop();
							}
							else
							{
								_removals.push(item);
							}
						}
					});
				}
			}
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes removals.
		 * See: remove()</p>
		 * 
		 */		
		private function processRemovals():void
		{
			// CFActions are excluded from the _removals list.
			for each (var taggedObject:ICFTaggable in _removals)
			{
				unregister(taggedObject);
			}
			
			// process CFActions here.
			
			var actionCount:int = _actions.length;
			
			for (var i:int = 0; i < actionCount; ++i)
			{
				var action:CFAction = _actions.shift();
				
				if(!(action.isActive))
				{
					unregister(action);
					
					var tagkeys:Array = action.tags.toArray();
					
					for (var j:int = 0; j < tagkeys.length; ++j)
					{
						if ((tagkeys[j] as String).slice(0, 1) == "@")
						{
							action.tags.removeItem(tagkeys[j]);
						}
					}
					
					if(_blocksRequested.length > 0)
					{
						for each (var child:CFAction in action.children)
						{	
							var childBlocked:Boolean = false;
							
							for each (var blockedTag:String in _blocksRequested.items)
							{
								if (child.tags.has(blockedTag))
								{
									childBlocked = true;
									break;
								}
							}
							
							if(!childBlocked)
							{
								child.addTags(action.tags.toArray());
								add(child);
								//add(action.tags.toArray(), child);
								for each (var cco:Object in action.dataPipe)
								{
									child.dataPipe.push(cco);
								}
							}
						}
					}
					else if (action.children.length > 0)
					{
						for each (child in action.children)
						{
							child.addTags(action.tags.toArray());
							add(child);
							//add(action.tags.toArray(), child);
							for each (cco in action.dataPipe)
							{
								child.dataPipe.push(cco);
							}
						}
					}
				}
				else
				{
					_actions.push(action);
				}
			}
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes additions.
		 * See: add()</p>
		 * 
		 */		
		private function processAdditions():void
		{
			while (_additions.length > 0)
			{
				var obj:ICFTaggable = _additions.shift();
				
				if(_blocksRequested.length > 0)
				{
					var skipTag:Boolean = false;
					
					for each (var tag:String in obj.tags.items)
					{
						if(_blocksRequested.has(tag))
						{
							skipTag = true;
							break;
						}
					}
					
					if(skipTag)
					{
						continue;
					}
				}
				
				if(obj is CFAction)
				{
					_actions.push(obj as CFAction);
				}
				
				if(obj is ICFHasEngine)
				{
					(obj as ICFHasEngine).engine = this;
				}
								
				register(obj);
				
				if (obj is IEventDispatcher)
				{
					(obj as IEventDispatcher).dispatchEvent(new Event(CFEvent.OBJECT_REGISTERED));
				}
				
			}
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes resume requests.
		 * See: resume()</p>
		 */		
		private function processResumeRequests():void
		{
			for each (var tag:String in _resumesRequested.items)
			{
				if (_registry.has(tag))
				{
					//for each (var obj:ICFTaggable in _registry.getObjects(tag))
					_registry.getObjects(tag).forEach(function(obj:Object):void
					{
						if((obj != null) && (obj is ICFPausable))
						{
							(obj as ICFPausable).paused = false;
						}
					});
				}
			}
			
			_resumesRequested.clear();
		}
		
		/**
		 * <p>For internal use only and called by update(), this processes pause requests.
		 * See: pause()</p>
		 * 
		 */		
		private function processPauseRequests():void
		{
			for each (var tag:String in _pausesRequested.items)
			{
				if (_registry.has(tag))
				{
					//for each (var obj:ICFTaggable in _registry.getObjects(tag))
					_registry.getObjects(tag).forEach(function(obj:Object):void
					{
						if((obj != null) && (obj is ICFPausable))
						{
							(obj as ICFPausable).paused = true;
						}
					});
				}
			}
			
			_pausesRequested.clear();
		}
		
		/**
		 * <p>For internal use only and called by update(), this clears frame data.
		 * Frame data is an associative array that can be used for a single frame before being cleared.
		 * Frame data should be used very carefully and only as a last resort.
		 * It has a very low threshold for abuse.</p>
		 * 
		 */		
		private function clearFrameData():void
		{
			for (var key:Object in _frameData)
			{
				delete _frameData[key];
			}
		}
		
		/**
		 * <p>This drives the engine and should be called each frame.
		 * Typically this will be called from onEnter(), but feel free to drive it differently.</p>
		 * 
		 * @param delta
		 * This is the time elapsed since the last frame, measured in seconds.
		 * 
		 */		
		public function update(delta:Number):void
		{
			_delta = delta;
						
			processDelayedFunctions();
			
			processActions(delta);
			
			processMessages();
			
			processStopRequests();
			
			processRemovals();
			
			processAdditions();
			
			// pause and resume act on new additions intentionally.
			
			processResumeRequests();
			
			processPauseRequests();
			
			_blocksRequested.clear();
			
			clearFrameData();
		}
		
	}
}