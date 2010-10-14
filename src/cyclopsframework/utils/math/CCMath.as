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

package cyclopsframework.utils.math
{
	import cyclopsframework.core.easing.CCBias;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CCMath
	{
		public static const PHI:Number = 1.61803399;
		
		public function CCMath()
		{
			
		}
		
		public static function clamp(n:Number, min:Number, max:Number):Number
		{
			return (n < min) ? min : (n > max) ? max : n;
		}
		
		public static function lerp(a:Number, b:Number, t:Number):Number
		{
			return a + (b - a) * t;
		}
		
		public static function lerpTarget2(target:Object, p1:Object, p2:Object, t:Number):void
		{
			target.x = lerp(p1.x, p2.x, t);
			target.y = lerp(p1.y, p2.y, t);
		}
		
		public static function lerpTarget3(target:Object, v1:Object, v2:Object, t:Number):void
		{
			target.x = lerp(v1.x, v2.x, t);
			target.y = lerp(v1.y, v2.y, t);
			target.z = lerp(v1.z, v2.z, t);
		}
		
		public static function boxScatter2(rect:Rectangle, bias:Function=null):Point
		{
			if (bias == null)
			{
				return new Point(Math.random() * rect.width + rect.x, Math.random() * rect.height + rect.y);
			}
			else
			{
				return new Point(bias(Math.random()) * rect.width + rect.x, bias(Math.random()) * rect.height + rect.y);
			}
		}
		
		public static function radialScatter2(radius:Number, bias:Function=null):Point
		{
			var angle:Number = Math.random() * Math.PI * 2;
			var length:Number;
			
			if (bias != null)
			{
				length = bias(Math.random()) * radius;
			}
			else
			{
				length = Math.random() * radius;
			}
			
			return new Point(Math.sin(angle) * length, Math.cos(angle) * length);
			
		}
				
		public static function wrap(n:Number, div:Number):Number
		{
			if (n >= 0)
			{ 
				return n % div;
			}
			else
			{
				var result:Number = (n % div) + div;
				return (result != div) ? result : 0;
			}
		}
	}
}