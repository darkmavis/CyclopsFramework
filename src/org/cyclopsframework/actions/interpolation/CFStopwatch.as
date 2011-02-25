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

package org.cyclopsframework.actions.interpolation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.cyclopsframework.actions.interpolation.events.CFStopwatchEvent;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFStopwatch extends CFAction implements IEventDispatcher
	{
		public static const TAG:String = "@CFStopwatch";
		
		private var _lastSeconds:Number = 0;
		private var _seconds:Number = 0;
		public function get seconds():int { return int(_seconds % 60); }
		public function get secondsText():String { return ((seconds < 10) ? "0" : "") + seconds; }
		public function get secondsTotal():int { return int(_seconds); }
		
		private var _lastMinutes:Number = 0;
		private var _minutes:Number = 0;
		public function get minutes():int { return int(_seconds / 60); }
		public function get minutesText():String { return ((minutes < 10) ? "0" : "") + minutes; }
		
		private var _lastHours:Number = 0;
		private var _hours:Number = 0;
		public function get hours():int { return int(_seconds / 3600); }
		public function get hoursText():String { return ((hours < 10) ? "0" : "") + hours; }
		
		private var _lastDays:Number = 0;
		private var _days:Number = 0;
		public function get days():int { return int(_seconds / 86400); }
		public function get daysText():String { return ((days < 10) ? "0" : "") + days; }
		
		public function get minutesSecondsText():String { return minutesText + ":" + secondsText; }
		public function get hoursMinutesSecondsText():String { return hoursText + ":" + minutesText + ":" + secondsText; }
		
		private var _dispatcher:EventDispatcher;
		
		public function CFStopwatch(
			period:Number,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			_seconds = period * bias(position);
			_dispatcher = new EventDispatcher(this);
		}
		
		protected override function onFrame(t:Number):void
		{
			_seconds = period * t;
			
			var s:Number = seconds;
			if (s != _lastSeconds)
			{
				_lastSeconds = s;
				dispatchEvent(new CFStopwatchEvent(CFStopwatchEvent.SECONDS_CHANGED));
				var m:Number = minutes;
				if (m != _lastMinutes)
				{
					_lastMinutes = m;
					dispatchEvent(new CFStopwatchEvent(CFStopwatchEvent.MINUTES_CHANGED));
					var h:Number = hours;
					if (h != _lastHours)
					{
						_lastHours = h;
						dispatchEvent(new CFStopwatchEvent(CFStopwatchEvent.HOURS_CHANGED));
						var d:Number = days;
						if (d != _lastDays)
						{
							_lastDays = d;
							dispatchEvent(new CFStopwatchEvent(CFStopwatchEvent.DAYS_CHANGED));
						}
					}
				}
			}
		}
				
		public static function initWithHMS(hours:Number, minutes:Number, seconds:Number, cycles:Number=1, bias:Function=null):CFStopwatch
		{
			return new CFStopwatch(hours * 3600 + minutes * 60 + seconds, cycles, bias);
		}
		
		public static function initWithDHMS(days:Number, hours:Number, minutes:Number, seconds:Number, cycles:Number=1, bias:Function=null):CFStopwatch
		{
			return new CFStopwatch(days * 86400 + hours * 3600 + minutes * 60 + seconds, cycles, bias);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(e:Event):Boolean
		{
			return _dispatcher.dispatchEvent(e);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
				
	}
}