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

package cyclopsframework.actions.animation.cc3d
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class CC3DTranslate extends CCAction
	{
		public static const TAG:String = "@CC3DTranslate";
		
		private var _dynamicTarget:Object = null;
		private var _v1:Object;
		private var _v2:Object;
		
		public function CC3DTranslate(
			target:Object,
			v1:Object,
			v2:Object,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CCUtils.validate(target, "CC3DTranslate target", ["x", "y", "z"]);
			
			_dynamicTarget = target;
			_v1 = v1;
			_v2 = v2;
		}
		
		protected override function onFrame(t:Number):void
		{
			CCMath.lerpTarget3(_dynamicTarget, _v1, _v2, t);
		}
	}
}