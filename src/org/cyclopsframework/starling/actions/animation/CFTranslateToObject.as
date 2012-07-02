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
	
	import flash.geom.Point;
	
	public class CFTranslateToObject extends CFAction
	{
		public static const TAG:String = "@CFTranslateToObject";
		
		private var _target:Object;
		private var _destination:Object;
		private var _p1:Point;
		
		public function CFTranslateToObject(
			target:Object,
			destination:Object,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CFUtils.validate(target, "CFTranslateToObject target", ["x", "y"]);
			CFUtils.validate(destination, "CFTranslateToObject destination", ["x", "y"]);
						
			_target = target;
			_destination = destination;
		}
		
		protected override function onEnter():void
		{
			_p1 = new Point(_target.x, _target.y);
		}
		
		protected override function onFrame(t:Number):void
		{
			CFMath.lerpTarget2(_target, _p1, _destination, t);
		}
	}
}