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

package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCMessageInterceptor;
	
	public class CCWaitForMessage extends CCAction implements ICCMessageInterceptor
	{
		public static const TAG:String = "@CCWaitForMessage";
		
		private var _messageName:String;
		private var _messageListener:Function;
		private var _timeoutListener:Function;
		private var _timedOut:Boolean = true;
		
		public function CCWaitForMessage(
			messageName:String,
			timeout:Number=Number.MAX_VALUE,
			cycles:Number=1,
			messageListener:Function=null,
			timeoutListener:Function=null)
		{
			super(timeout, cycles, null, [TAG]);
			_messageName = messageName;
			_messageListener = messageListener;
			_timeoutListener = timeoutListener;
		}
		
		public function interceptMessage(msg:CCMessage):void
		{
			var oldContext:CCAction = engine.context;
			engine.context = this;
			
			if ((_messageName == null) || (_messageName == msg.name))
			{
				_timedOut = false;
				if (_messageListener != null) _messageListener(msg);
				//this.stop();
				this.jumpTo((this.cycle + 1));
			}
			
			engine.context = oldContext;
		}
		
		protected override function onLastFrame():void
		{
			if ((_timeoutListener != null) && _timedOut) _timeoutListener();
		}
		
	}
}