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
	import org.cyclopsframework.utils.color.CFColor;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class CFTintBy extends CFAction
	{
		public static const TAG:String = "@CFTintBy";
		
		private var _target:DisplayObject = null;
		private var _tc:CFColor = new CFColor(1,1,1,1);
		private var _c1:CFColor;
		private var _c2:CFColor;
		
		public function CFTintBy(
			target:DisplayObject,
			relColor:CFColor,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CFUtils.validate(target, "CFTintBy target");
			
			_target = target;
			_c2 = relColor;
		}
		
		protected override function onEnter():void
		{
			_c1 = CFColor.fromColorTransform(_target.transform.colorTransform);
			CFColor.add(_c2, _c1, _c2);
		}
		
		protected override function onFrame(t:Number):void
		{
			var ct:ColorTransform = CFColor.lerp(_tc, _c1, _c2, t).toColorTransform();
			ct.alphaMultiplier = _target.transform.colorTransform.alphaMultiplier;
			_target.transform.colorTransform = ct;
		}
	}
}