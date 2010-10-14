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
	
	public class CCFunction extends CCAction
	{
		public static const TAG:String = "@CCFunction";
		
		private var _f:Function;
		private var _thisObject:Object;
		private var _data:Array;
		
		public function CCFunction(
			period:Number,
			cycles:Number,
			thisObject:Object,
			data:Array,
			f:Function)
		{
			super(period, cycles, null, [TAG]);
			_thisObject = thisObject;
			_data = data;
			_f = f;
		}
		
		public static function initLoop(f:Function):CCFunction
		{
			return new CCFunction(0, Number.MAX_VALUE, null, null, f);	
		}
		
		protected override function onFirstFrame():void
		{
			_f.apply(_thisObject, _data);
		}
		
	}
}