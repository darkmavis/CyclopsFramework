/**
 * Cyclops Framework
 * 
 * Copyright 2010 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
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
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.actions.flow.CFSleep;
	import org.cyclopsframework.actions.flow.CFWaitForEvent;
	import org.cyclopsframework.actions.flow.CFWaitForMessage;
	import org.cyclopsframework.utils.collections.CFCache;
	import org.cyclopsframework.utils.collections.CFDataStore;
	import org.cyclopsframework.utils.collections.CFRegistry;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.proxies.CFDataStoreProxy;
	import org.cyclopsframework.utils.proxies.CFMessageProxy;
	
	public class CFEngine
	{
		public static const TAG_ALL:String = "*";
		
		private var _registry:CFRegistry = new CFRegistry();
		
		private var _actions:Vector.<CFAction> = new Vector.<CFAction>();
		private var _additions:Vector.<ICFTaggable> = new Vector.<ICFTaggable>();
		private var _removals:Vector.<ICFTaggable> = new Vector.<ICFTaggable>();
		private var _stopsRequested:Vector.<CFStopActionRequest> = new Vector.<CFStopActionRequest>();
		private var _messages:Vector.<CFMessage> = new Vector.<CFMessage>();
		
		private var _pausesRequested:CFStringHashSet = new CFStringHashSet();
		private var _resumesRequested:CFStringHashSet = new CFStringHashSet();
		private var _blocksRequested:CFStringHashSet = new CFStringHashSet();
		private var _autotags:CFStringHashSet = new CFStringHashSet();
				
		private var _delayedFunctions:Vector.<Function> = new Vector.<Function>();
		
		private var _context:CFAction;
		public function get context():CFAction { return _context; }
		public function set context(value:CFAction):void { _context = value; }
		
		private var _delta:Number = 1 / 60;
		public function get delta():Number { return _delta; }
		public function get fps():Number { return 1 / _delta; }
				
		public function CFEngine()
		{
			beginTag(TAG_ALL);
		}
		
		// Sequencing Tags
		
		public function beginTag(tag:String):void
		{
			_autotags.addItem(tag);
		}
		
		public function endTag(tag:String):void
		{
			_autotags.removeItem(tag);
		}
		
		private function applyAutotags(o:ICFTaggable):void
		{
			for each (var tag:String in _autotags.items)
			{
				o.tags.addItem(tag);
			}
		}
		
		// Sequencing + TaggedObject Additions/Registration
		
		public function add(...taggedObjects):CFAction
		{
			var currTags:Array = [];
			var currAction:CFAction = null;
			
			for each (var o:Object in taggedObjects)
			{
				if (o is CFAction)
				{
					currAction = o as CFAction;
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
							currTags.push(o);
						}
						else if (ao is Array)
						{
							add(currTags, contextualTags, ao);
						}
						else
						{
							add(currTags, contextualTags, ao);
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
		
		private function addSequence(actions:Array, returnHead:Boolean):CFAction
		{
			var head:Object;
			var tail:Object;
			
			for each (var o:Object in actions)
			{
				if (head == null)
				{
					head = tail = add(o);
				}
				else
				{
					tail = tail.add(o);
				}
			}
			
			return ((returnHead ? head : tail) as CFAction);
		}
		
		public function addSequenceReturnHead(actions:Array):CFAction
		{
			return addSequence(actions, true);
		}
		
		public function addSequenceReturnTail(actions:Array):CFAction
		{
			return addSequence(actions, false);
		}
		
		public function addf(f:Function, thisObject:Object=null, data:Array=null):CFAction
		{
			return add(new CFFunction(0, 1, thisObject, data, f));
		}
		
		public function loop(f:Function, period:Number=0, cycles:Number=Number.MAX_VALUE):CFAction
		{
			return add(new CFFunction(period, cycles, null, null, f));
		}
				
		public function nop():CFAction
		{
			return add(new CFAction());
		}
		
		public function sleep(period:Number):CFAction
		{
			return add(new CFSleep(period));
		}
		
		public function waitForEvent(target:IEventDispatcher, eventType:String, timeout:Number=Number.MAX_VALUE, cycles:Number=1, listener:Function=null):CFAction
		{
			return add(new CFWaitForEvent(target, eventType, timeout, cycles, listener));
		}
		
		public function waitForMessage(receiverTag:String, messageName:String, timeout:Number=Number.MAX_VALUE, cycles:Number=1,
			messageListener:Function=null, timeoutListener:Function=null):CFAction
		{
			return add(receiverTag, new CFWaitForMessage(messageName, timeout, cycles, messageListener, timeoutListener));
		}
		
		public function listen(receiverTag:String, messageName:String, messageListener:Function=null):CFAction
		{
			return add(receiverTag, new CFWaitForMessage(messageName, Number.MAX_VALUE, Number.MAX_VALUE, messageListener));
		}
		
		// improve this later.
		public function when(trigger:Function, response:Function=null):CFAction
		{
			return loop(function():void
			{
				if ((trigger != null) && trigger())
				{
					if (response != null) response();
				}
			});
		}
		
		public function runNextFrame(f:Function):void
		{
			_delayedFunctions.push(f);
		}
		
		// Control Flow
		
		public function pause(tag:String):void
		{
			_pausesRequested.addItem(tag);
		}
		
		public function resume(tag:String):void
		{
			_resumesRequested.addItem(tag);
		}
		
		public function block(tag:String):void
		{
			_blocksRequested.addItem(tag);
		}
		
		public function remove(tag:String, stopChildren:Boolean=true):void
		{
			_stopsRequested.push(new CFStopActionRequest(tag, stopChildren));
		}
		
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
		
		private function register(taggedObject:ICFTaggable):void
		{
			for each (var tag:String in taggedObject.tags.items)
			{
				_registry.addObject(tag, taggedObject);
			}
		}
		
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
		
		public function count(...args):int
		{
			if (args.length == 0) return 0;
			return query.apply(null, args).numItems;
		}
				
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
					if (arg != null)
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
							throw(new TypeError("Query argument type not recognized. Valid types are: strings, functions and classes with a public static const TAG:String member"));
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
		
		public function proxy(...args):CFDataStoreProxy
		{
			return query.apply(null, args).proxy;
		}
		
		public function status(tag:String=CFEngine.TAG_ALL):String
		{
			var actions:Array = [];
			
			query(tag).forEach(function(o:ICFTaggable):void
			{
				if (o is CFAction) actions.push(o);
			});
			
			actions = actions.sortOn(["cycles", "period", "position"], Array.DESCENDING);
			
			var result:String = "";
			
			for each (var action:CFAction in actions)
			{
				result += ("pos: " + int(action.position * 100)
					+ "%\t\tcycle: " + action.cycle + "/" + ((action.cycles == Number.MAX_VALUE) ? "MAX" : ("" + action.cycles)) 
					+ "\t\t" + action.tags.toArray().join(", ")) + "\n";
			}
			
			result += "Total actions: " + actions.length + "\n" + "Total objects: " + count(tag);
			
			return result;
		}
				
		// Messaging
		
		public function sendByProxy(tag:String=TAG_ALL, sender:Object=null, receiverType:Class=null):CFMessageProxy
		{
			return new CFMessageProxy(this, tag, sender, receiverType);
		}
		
		public function send(receiverTag:String, name:String, data:Array=null, sender:Object=null, receiverType:Class=null):void
		{
			_messages.push(new CFMessage(receiverTag, name, data, sender, receiverType));
		}
		
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
					currReceiver[msg.name] = msg.data;
					break;
				}
			}
		}
		
		// Updates
		
		private function processDelayedFunctions():void
		{
			while (_delayedFunctions.length > 0)
			{
				_delayedFunctions.shift().apply();
			}
		}
		
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
		}
		
	}
}