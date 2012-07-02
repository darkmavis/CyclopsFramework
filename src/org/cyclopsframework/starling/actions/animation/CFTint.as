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
	import org.cyclopsframework.utils.color.CFColor;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	public class CFTint extends CFAction
	{
		public static const TAG:String = "@CFTint";
		
		private var _target:Quad = null;
		private var _tc:CFColor = new CFColor(1,1,1,1);
		private var _c1:CFColor;
		private var _c2:CFColor;
		
		public function CFTint(
			target:Quad,
			c1:CFColor,
			c2:CFColor,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CFUtils.validate(target, "CFTint target");
			
			_target = target;
			_c1 = c1;
			_c2 = c2;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.color = CFColor.lerp(_tc, _c1, _c2, t).toUint();
			}
		}
	}
}