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

package cyclopsframework.core
{
	import cyclopsframework.actions.flow.CCFunction;
	import cyclopsframework.actions.flow.CCSleep;
	import cyclopsframework.actions.flow.CCWaitForEvent;
	import cyclopsframework.utils.collections.CCDataStore;
	import cyclopsframework.utils.collections.CCRegistry;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.proxies.CCDataStoreProxy;
	import cyclopsframework.utils.proxies.CCMessageProxy;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
		
	public class CCEngine
	{
		public static const TAG_ALL:String = "*";
		
		private var _registry:CCRegistry = new CCRegistry();
		
		private var _actions:Vector.<CCAction> = new Vector.<CCAction>();
		private var _additions:Vector.<ICCTaggable> = new Vector.<ICCTaggable>();
		private var _removals:Vector.<ICCTaggable> = new Vector.<ICCTaggable>();
		private var _stopsRequested:Vector.<CCStopActionRequest> = new Vector.<CCStopActionRequest>();
		private var _messages:Vector.<CCMessage> = new Vector.<CCMessage>();
		
		private var _pausesRequested:CCStringHashSet = new CCStringHashSet();
		private var _resumesRequested:CCStringHashSet = new CCStringHashSet();
		private var _blocksRequested:CCStringHashSet = new CCStringHashSet();
		private var _autotags:CCStringHashSet = new CCStringHashSet();
				
		private var _delayedFunctions:Vector.<Function> = new Vector.<Function>();
		
		private var _context:CCAction;
		public function get context():CCAction { return _context; }
		
		private var _delta:Number = 1 / 60;
		public function get delta():Number { return _delta; }
		public function get fps():Number { return 1 / _delta; }
		
		public function CCEngine()
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
		
		private function applyAutotags(o:ICCTaggable):void
		{
			for each (var tag:String in _autotags.items)
			{
				o.tags.addItem(tag);
			}
		}
		
		// Sequencing + TaggedObject Additions/Registration
		
		public function add(...taggedObjects):CCAction
		{
			var currTags:Array = [];
			var currAction:CCAction = null;
			
			for each (var o:Object in taggedObjects)
			{
				if (o is CCAction)
				{
					currAction = o as CCAction;
					applyAutotags(currAction);
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_additions.push(o);
				}
				else if (o is ICCTaggable)
				{
					var taggedObject:ICCTaggable = o as ICCTaggable;
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
					currAction = new CCFunction(0, 1, null, null, o as Function);
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
					for each (var ao:Object in (o as Array))
					{
						if (ao is String)
						{
							currTags.push(ao);
						}
						else
						{
							currAction = add(ao);
							applyAutotags(currAction);
							if (currTags.length > 0)
							{
								currAction.addTags(currTags);
								currTags = [];
							}
							_additions.push(currAction);
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
		
		private function addSequence(actions:Array, returnHead:Boolean):CCAction
		{
			var currTags:Array = [];
			var head:CCAction;
			var tail:CCAction;
			
			for each (var o:Object in actions)
			{
				if (o is String)
				{
					currTags.push(o);
				}
				else if (head == null)
				{
					head = tail = add(currTags, o);
					currTags = [];
				}
				else
				{
					tail = tail.add(currTags, o);
					currTags = [];
				}
			}
			
			return (returnHead ? head : tail);
		}
		
		public function addSequenceReturnHead(...actions):CCAction
		{
			return addSequence(actions, true);
		}
		
		public function addSequenceReturnTail(...actions):CCAction
		{
			return addSequence(actions, false);
		}
		
		public function addf(f:Function, thisObject:Object=null, data:Array=null):CCAction
		{
			return add(new CCFunction(0, 1, thisObject, data, f));
		}
		
		public function loop(f:Function, period:Number=0, cycles:Number=Number.MAX_VALUE):CCAction
		{
			return add(new CCFunction(period, cycles, null, null, f));
		}
				
		public function nop():CCAction
		{
			return add(new CCAction());
		}
		
		public function sleep(period:Number):CCAction
		{
			return add(new CCSleep(period));
		}
		
		public function waitForEvent(target:IEventDispatcher, eventType:String, timeout:Number=Number.MAX_VALUE, cycles:Number=1, listener:Function=null):CCAction
		{
			return add(new CCWaitForEvent(target, eventType, timeout, cycles, listener));
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
			_stopsRequested.push(new CCStopActionRequest(tag, stopChildren));
		}
		
		public function removeObject(taggedObject:ICCTaggable):void
		{
			if (taggedObject is CCAction)
			{
				(taggedObject as CCAction).stop();
			}
			else
			{
				_removals.push(taggedObject);
			}
		}
		
		// Registration & Housekeeping
		
		private function register(taggedObject:ICCTaggable):void
		{
			for each (var tag:String in taggedObject.tags.items)
			{
				_registry.addObject(tag, taggedObject);
			}
		}
		
		private function unregister(taggedObject:ICCTaggable):void
		{
			for each (var tag:String in taggedObject.tags.items)
			{
				_registry.removeObject(tag, taggedObject);
			}
			
			if(taggedObject is ICCDisposable)
			{
				(taggedObject as ICCDisposable).dispose();
			}
		}
			
		// Querying
		
		public function count(tag:String=TAG_ALL):int
		{
			return _registry.count(tag);
		}
				
		public function query(tag:String=TAG_ALL):CCDataStore
		{
			return _registry.getObjects(tag);
		}
		
		public function proxy(tag:String=TAG_ALL):CCDataStoreProxy
		{
			return query(tag).proxy;
		}
				
		// Messaging
		
		public function sendByProxy(tag:String=TAG_ALL, sender:Object=null, receiverType:Class=null):CCMessageProxy
		{
			return new CCMessageProxy(this, tag, sender, receiverType);
		}
		
		public function send(receiverTag:String, name:String, data:Array=null, sender:Object=null, receiverType:Class=null):void
		{
			_messages.push(new CCMessage(receiverTag, name, data, sender, receiverType));
		}
		
		private function deliverMessage(msg:CCMessage, receiver:Object):void
		{
			if(msg.receiverType != null)
			{
				if(!(receiver is msg.receiverType))
				{
					return;
				}
			}
			
			if (receiver is ICCMessageInterceptor)
			{
				(receiver as ICCMessageInterceptor).interceptMessage(msg);
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
				var action:CCAction = _actions.shift();
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
				var msg:CCMessage = _messages.shift();
				
				if(_registry.has(msg.receiverTag))
				{
					query(msg.receiverTag).forEach(function(o:ICCTaggable):void
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
				var request:CCStopActionRequest = _stopsRequested.shift();
				if (_registry.has(request.actionTag))
				{
					//for each (var action:CCAction in _registry.getObjects(request.actionTag))
					_registry.getObjects(request.actionTag).forEach(function(action:CCAction):void
					{
						if(action != null) //(action is CCAction)
						{
							if (request.stopChildren)
							{
								action.removeChildren();
							}
							action.stop();
						}
					});
				}
			}
		}
		
		private function processRemovals():void
		{
			// CCActions are excluded from the _removals list.
			for each (var taggedObject:ICCTaggable in _removals)
			{
				unregister(taggedObject);
			}
			
			// process CCActions here.
			
			var actionCount:int = _actions.length;
			
			for (var i:int = 0; i < actionCount; ++i)
			{
				var action:CCAction = _actions.shift();
				
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
						for each (var child:CCAction in action.children)
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
								add(action.tags.toArray(), child);
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
							add(action.tags.toArray(), child);
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
				var obj:ICCTaggable = _additions.shift();
				
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
				
				if(obj is CCAction)
				{
					_actions.push(obj as CCAction);
					// good and bad could come from this coupling.
					(obj as CCAction).engine = this;
				}
				
				register(obj);
			}
		}
		
		private function processResumeRequests():void
		{
			for each (var tag:String in _resumesRequested.items)
			{
				if (_registry.has(tag))
				{
					//for each (var obj:ICCTaggable in _registry.getObjects(tag))
					_registry.getObjects(tag).forEach(function(obj:ICCPausable):void
					{
						if(obj != null) //is ICCPausable)
						{
							obj.paused = false;
							//(obj as ICCPausable).paused = false;
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
					//for each (var obj:ICCTaggable in _registry.getObjects(tag))
					_registry.getObjects(tag).forEach(function(obj:ICCPausable):void
					{
						if(obj != null) // is ICCPausable)
						{
							(obj as ICCPausable).paused = true;
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