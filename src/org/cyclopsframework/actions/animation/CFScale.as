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

package org.cyclopsframework.actions.animation
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import flash.display.DisplayObject;
	
	public class CFScale extends CFAction
	{
		public static const TAG:String = "@CFScale";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _width1:Number;
		private var _width2:Number;
		private var _height1:Number;
		private var _height2:Number;
				
		public function CFScale(
			target:Object,
			width1:Number,
			height1:Number,
			width2:Number,
			height2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CFUtils.validate(target, "CFScale target");
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_width1 = width1;
			_height1 = height1;
			_width2 = width2;
			_height2 = height2;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.scaleX = CFMath.lerp(_width1, _width2, t);
				_target.scaleY = CFMath.lerp(_height1, _height2, t);	
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "scaleX", CFMath.lerp(_width1, _width2, t));
				safeset(_dynamicTarget, "scaleY", CFMath.lerp(_height1, _height2, t));	
			}
		}
	}
}