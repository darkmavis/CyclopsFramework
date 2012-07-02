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

package org.cyclopsframework.starling.actions.animation
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import starling.display.DisplayObject;
	
	public class CFFadeTo extends CFAction
	{
		public static const TAG:String = "@CFFadeTo";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _value1:Number;
		private var _value2:Number;
		
		public function CFFadeTo(
			target:Object,
			value2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CFUtils.validate(target, "CFFadeTo target", null, true);
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_value2 = value2;
		}
		
		protected override function onEnter():void
		{
			if (_dynamicTarget.hasOwnProperty("alpha"))
			{
				_value1 = _dynamicTarget["alpha"];
			}
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.alpha = CFMath.lerp(_value1, _value2, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "alpha", CFMath.lerp(_value1, _value2, t));
			}
		}
		
	}
}