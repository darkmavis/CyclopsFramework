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

package org.cyclopsframework.actions.flow
{
	import org.cyclopsframework.core.CFAction;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class CFWaitForEvent extends CFAction
	{
		public static const TAG:String = "@CFWaitForEvent";
		
		private var _target:IEventDispatcher;
		private var _eventType:String;
		private var _handler:Function;
		
		public function CFWaitForEvent(
			target:IEventDispatcher,
			eventType:String,
			timeout:Number=Number.MAX_VALUE,
			cycles:Number=1,
			handler:Function=null)
		{
			super(timeout, cycles, null, [TAG]);
			_target = target;
			_eventType = eventType;
			_handler = handler;
		}
		
		protected override function onEnter():void
		{
			_target.addEventListener(_eventType, onEvent);
		}
		
		private function onEvent(e:Event):void
		{
			if (paused) return;
			
			if (_handler != null)
			{
				_handler(e);
			}
			jumpTo(this.cycle + 1);
		}
		
		protected override function onExit():void
		{
			_target.removeEventListener(_eventType, onEvent);
		}
	}
}