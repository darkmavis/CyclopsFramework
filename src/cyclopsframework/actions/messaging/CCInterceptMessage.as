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

package cyclopsframework.actions.messaging
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCMessageInterceptor;
	
	public class CCInterceptMessage extends CCAction implements ICCMessageInterceptor
	{
		public static const TAG:String = "@CCInterceptMessage";
		
		private var _messageListener:Function;
		
		public function CCInterceptMessage(
			timeout:Number,
			cycles:Number,
			messageListener:Function)
		{
			super(timeout, cycles, null, [TAG]);
			_messageListener = messageListener;
		}
		
		public function interceptMessage(message:CCMessage):void
		{
			_messageListener(message);
		}
	}
}