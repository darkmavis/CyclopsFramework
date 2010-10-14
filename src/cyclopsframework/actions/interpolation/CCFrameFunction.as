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

package cyclopsframework.actions.interpolation
{
	import cyclopsframework.core.CCAction;
	
	public class CCFrameFunction extends CCAction
	{
		public static const TAG:String = "@CCFrameFunction";
		
		private var _f:Function;
		
		public function CCFrameFunction(
			period:Number,
			cycles:Number,
			bias:Function,
			f:Function)
		{
			super(period, cycles, bias, [TAG]);
			_f = f;
		}
		
		protected override function onFrame(t:Number):void
		{
			_f(t);
		}
	}
}