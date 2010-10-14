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
	import cyclopsframework.core.easing.CCBias;
	import cyclopsframework.utils.collections.CCStringHashSet;
	
	import flash.events.IEventDispatcher;

	public class CCAction implements ICCPausable, ICCTaggable
	{
		public static const TAGS_UNDEFINED:String = "@__undefined__";
		
		private var _bias:Function;
		private var _cycle:Number = 0;
		private var _cycles:Number = 1;
				
		private var _period:Number = 0;
		public function get period():Number { return _period; }
		
		private var _position:Number = 0;
		public function get cycle():Number { return _cycle; }
		
		private var _speed:Number = 1;
		public function get cycles():Number { return _cycles; }
		
		public function get position():Number { return ((_position - _cycle) >= 1) ? 1 : (_position - _cycle);}
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void { _speed = value; }
		
		private var _accDelta:Number = 0;
		
		private var _minDelta:Number = Number.MIN_VALUE;
		public function get minDelta():Number { return _minDelta; }
		public function set minDelta(value:Number):void { _minDelta = value; }
		
		private var _maxDelta:Number = 1;
		public function get maxDelta():Number { return _maxDelta; }
		public function set maxDelta(value:Number):void { _maxDelta = value; }
		
		private var _dataPipe:Array = [];
		public function get dataPipe():Array { return _dataPipe; }
		
		private var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
		private var _paused:Boolean = false;
		public function get paused():Boolean { return _paused; }
		public function set paused(value:Boolean):void { _paused = value; }
		
		private var _children:Array = [];
		public function get children():Array { return _children; }
		
		private var _active:Boolean = true;
		public function get isActive():Boolean { return _active; }
		
		private var _engine:CCEngine;
		public function get engine():CCEngine { return _engine; }
		public function set engine(value:CCEngine):void { _engine = value; }
		
		public function CCAction(period:Number=0, cycles:Number=1, bias:Function=null, tags:Array=null)
		{
			_cycles = cycles;
			_period = period;
			_bias = (bias == null) ? CCBias.linear : bias;
			if (tags == null)
			{
				addTags([CCAction.TAGS_UNDEFINED]);
			}
			else
			{
				addTags(tags);
			}
		}
		
		public function removeChildren():void
		{
			_children = [];
		}
		
		public function add(...actions):CCAction
		{
			var currTags:Array = [];
			var currAction:CCAction;
			
			for each (var o:Object in actions)
			{
				if (o is CCAction)
				{
					currAction = o as CCAction;
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_children.push(o);
				}
				else if (o is Function)
				{
					currAction = new CCFunction(0, 1, null, null, o as Function);
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_children.push(currAction);
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
							if (currTags.length > 0)
							{
								currAction.addTags(currTags);
								currTags = [];
							}
							_children.push(currAction);
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
				
		protected function safeset(target:Object, propertyName:String, value:Object):void
		{
			if (target is String)
			{
				engine.query(target as String).forEach(function(o:Object):void
				{
					if (o.hasOwnProperty(propertyName))
					{
						o[propertyName] = value;
					}
				});
			}
			else if (target.hasOwnProperty(propertyName))
			{
				target[propertyName] = value;
			}
		}
		
		public function addTag(tag:String):CCAction
		{
			_tags.addItem(tag);
			return this;
		}
		
		public function addTags(tags:Array):CCAction
		{
			if (tags != null)
			{
				_tags.addItems(tags);			
			}
			return this;
		}
		
		public function setMaxDelta(value:Number):CCAction
		{
			maxDelta = value;
			return this;
		}
		
		public function setMinDelta(value:Number):CCAction
		{
			minDelta = value;
			return this;
		}
		
		public function stop(callLastFrame:Boolean=true, callExit:Boolean=true):void
		{
			if (_active)
			{
				_active = false;
				if (callLastFrame) onLastFrame();
				if (callExit) onExit();
			}
			
			_active = false;
		}
		
		public function jumpTo(pos:Number):void
		{
			_position = pos;
		}
		
		public function update(delta:Number):Boolean
		{
			var remainingDelta:Number = delta + _accDelta;
			
			if (remainingDelta < minDelta)
			{
				_accDelta += delta;
				return _active;
			}
			
			_accDelta = (_accDelta > 0) ? (_accDelta - remainingDelta) : 0;
			
			do
			{
				if (!_active) return false;
				
				if (_position == 0)
				{
					if(_cycle == 0)
					{
						onEnter();
					}
					onFirstFrame();
				}
												
				if (_position >= _cycles)
				{
					stop();
					return _active;
				}
								
				if(_period > 0)
				{
					_position += (remainingDelta * _speed) / _period;
				}
				else
				{
					++_position;
				}
				
				remainingDelta -= _maxDelta;
								
				onFrame(_bias(position));
				
				if ((_position - _cycle) >= 1)
				{
					if (_cycle < (_cycles - 1))
					{
						onLastFrame();
						++_cycle;
						
						if (_cycle >= _cycles)
						{
							stop(false, true);
							return _active;
						}
						
						onFirstFrame();
					}
					else
					{
						stop();
					}
				}
			} while (remainingDelta > 0)
			
			return _active;
		}
		
		protected function onEnter():void { }
		protected function onFirstFrame():void { }
		protected function onFrame(t:Number):void { }
		protected function onLastFrame():void { }
		protected function onExit():void { }
	}
}