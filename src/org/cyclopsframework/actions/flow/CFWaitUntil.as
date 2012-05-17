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
	
	public class CFWaitUntil extends CFAction
	{
		public static const TAG:String = "@CFWaitUntil";
		
		private var _predicate:Function;
		private var _listener:Function;
		
		public function CFWaitUntil(
			predicate:Function,
			timeout:Number=Number.MAX_VALUE,
			listener:Function=null)
		{
			super(timeout, 1, null, [TAG]);
			_predicate = predicate;
			_listener = listener;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_predicate() == true)
			{
				this.stop();
				
				if (_listener != null)
				{
					_listener.apply();
				}
			}
		}
	}
}