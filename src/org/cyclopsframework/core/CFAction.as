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
	import flash.events.IEventDispatcher;
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.actions.flow.CFSleep;
	import org.cyclopsframework.actions.flow.CFWaitForEvent;
	import org.cyclopsframework.actions.flow.CFWaitForMessage;
	import org.cyclopsframework.actions.flow.CFWaitUntil;
	import org.cyclopsframework.actions.interpolation.CFInterpolate;
	import org.cyclopsframework.core.easing.CFBias;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFGuid;

	public class CFAction implements ICFPausable, ICFTaggable, ICFHasEngine
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
		
		private var _entered:Boolean = false;
		private var _firstFrameEntered:Boolean = false;
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		private var _accDelta:Number = 0;
		
		private var _minDelta:Number = Number.MIN_VALUE;
		public function get minDelta():Number { return _minDelta; }
		public function set minDelta(value:Number):void { _minDelta = value; }
		
		private var _maxDelta:Number = 1;
		public function get maxDelta():Number { return _maxDelta; }
		public function set maxDelta(value:Number):void { _maxDelta = value; }
		
		private var _dataPipe:Array = [];
		public function get dataPipe():Array { return _dataPipe; }
		
		private var _tags:CFStringHashSet = new CFStringHashSet();
		public function get tags():CFStringHashSet { return _tags; }
		
		private var _paused:Boolean = false;
		public function get paused():Boolean { return _paused; }
		public function set paused(value:Boolean):void { _paused = value; }
		
		private var _children:Array = [];
		public function get children():Array { return _children; }
		
		private var _active:Boolean = true;
		public function get isActive():Boolean { return _active; }
		
		private var _engine:CFEngine;
		public function get engine():CFEngine { return _engine; }
		public function set engine(value:CFEngine):void { _engine = value; _sugar = new CFSugar(this); }
		
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
		
		private var _uniqueTag:String;
		
		/** Use this to track "subactions" within an originating action, but not the originating action itself. **/
		protected function get uniqueTag():String
		{
			if (_uniqueTag == null)
			{
				_uniqueTag = CFGuid.create();
			}
			return _uniqueTag;
		}
				
		public function CFAction(period:Number=0, cycles:Number=1, bias:Function=null, tags:Array=null)
		{
			_cycles = cycles;
			_period = period;
			_bias = (bias == null) ? CFBias.linear : bias;
			if (tags == null)
			{
				addTags([CFAction.TAGS_UNDEFINED]);
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
		
		public function add(...actions):CFAction
		{
			var currTags:Array = [];
			var currAction:CFAction;
			
			for each (var o:Object in actions)
			{
				if (o is CFAction)
				{
					currAction = o as CFAction;
					currAction.engine = engine;
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_children.push(o);
				}
				else if (o is Function)
				{
					currAction = new CFFunction(0, 1, null, null, o as Function);
					currAction.engine = engine;
					if (currTags.length > 0)
					{
						currAction.addTags(currTags);
						currTags = [];
					}
					_children.push(currAction);
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
				
		public function addTag(tag:String):CFAction
		{
			_tags.addItem(tag);
			return this;
		}
		
		public function addTags(tags:Array):CFAction
		{
			if (tags != null)
			{
				_tags.addItems(tags);			
			}
			return this;
		}
		
		public function setMaxDelta(value:Number):CFAction
		{
			maxDelta = value;
			return this;
		}
		
		public function setMinDelta(value:Number):CFAction
		{
			minDelta = value;
			return this;
		}
		
		public function stop(callLastFrame:Boolean=true, callExit:Boolean=true):void
		{
			if (_active && _entered)
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
		
		public function simulateFrame(t:Number):void
		{
			onFrame(t);
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
				
				if (!_firstFrameEntered)
				{
					if (!_entered)
					{
						_entered = true;
						onEnter();
					}
					_firstFrameEntered = true;
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
				
				if (_position > _cycles) _position = _cycles;
				
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