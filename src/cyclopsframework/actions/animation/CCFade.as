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

package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.display.DisplayObject;
	
	public class CCFade extends CCAction
	{
		public static const TAG:String = "@CCFade";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _value1:Number;
		private var _value2:Number;
		
		public function CCFade(
			target:Object,
			value1:Number,
			value2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CCUtils.validate(target, "CCFade target");
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_value1 = value1;
			_value2 = value2;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.alpha = CCMath.lerp(_value1, _value2, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "alpha", CCMath.lerp(_value1, _value2, t));
			}
		}
		
	}
}