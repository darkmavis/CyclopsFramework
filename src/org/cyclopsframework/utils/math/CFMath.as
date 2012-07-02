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

package org.cyclopsframework.utils.math
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import org.cyclopsframework.core.easing.CFBias;
	
	public class CFMath
	{
		private static const rgen:CFRandom = new CFRandom((new Date().time & 0xFFFFFFFF) ^ getTimer());
		
		public static const PHI:Number = 1.61803399;
		public static const PI_OVER_180:Number = (180 / Math.PI);
		public static const PI:Number = Math.PI;
		public static const PI2:Number = Math.PI * 2;
		public static const DEGREES_TO_RADIANS:Number = 1.0 / PI_OVER_180;
		
		public static const INSIDE:int = 1;
		public static const OUTSIDE:int = 2;
		public static const TOP:int = 4;
		public static const BOTTOM:int = 8;
		public static const LEFT:int = 16;
		public static const RIGHT:int = 32;
		
		public function CFMath()
		{
			
		}
		
		public static function random():Number
		{
			return rgen.extractNumber();
		}
		
		public static function toRadians(n:Number):Number
		{
			return n * DEGREES_TO_RADIANS;
		}
		
		public static function toDegrees(n:Number):Number
		{
			return n * PI_OVER_180;
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
				return new Point(CFMath.random() * rect.width + rect.x, CFMath.random() * rect.height + rect.y);
			}
			else
			{
				return new Point(bias(CFMath.random()) * rect.width + rect.x, bias(CFMath.random()) * rect.height + rect.y);
			}
		}
		
		public static function radialScatter2(radius:Number, bias:Function=null):Point
		{
			var angle:Number = CFMath.random() * Math.PI * 2;
			var length:Number;
			
			if (bias != null)
			{
				length = bias(CFMath.random()) * radius;
			}
			else
			{
				length = CFMath.random() * radius;
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
		
		public static function normalizeUnclamped01(n:Number, lowerBound:Number, upperBound:Number):Number
		{
			var d:Number = upperBound - lowerBound;
			
			return (n - lowerBound) / d;
		}
		
		public static function normalizeClamped01(n:Number, lowerBound:Number, upperBound:Number):Number
		{
			var d:Number = upperBound - lowerBound;
			
			return clamp((n - lowerBound) / d, 0, 1);
		}
		
		public static function normalizeUnclampedObject2(o:Object, containerRect:Rectangle, nx:Number, ny:Number):void
		{
			o.x = containerRect.width * nx;
			o.y = containerRect.height * ny;
		}
		
		public static function normalizeClampedObject2(o:Object, containerRect:Rectangle, nx:Number, ny:Number):void
		{
			o.x = clamp(containerRect.width * nx, containerRect.left, containerRect.right);
			o.y = clamp(containerRect.height * ny, containerRect.top, containerRect.bottom);
		}
		
		public static function recenter2(o:Object, rect:Rectangle):void
		{
			o.x = rect.x + rect.width / 2;
			o.y = rect.y + rect.height / 2;
		}
		
		public static function snap2(itemRect:Rectangle, containerRect:Rectangle, alignment:int, padding:int=0):Point
		{
			var p:Point = new Point();
			
			var inside:Boolean = (alignment & INSIDE) != 0;
			
			if ((alignment & TOP) != 0)
			{
				p.y = containerRect.top + padding;
				if (!inside) p.y -= itemRect.height + padding * 2;
			}
			else if ((alignment & BOTTOM) != 0)
			{
				p.y = containerRect.bottom + padding;
				if (inside) p.y -= itemRect.height + padding * 2;
			}
			
			if ((alignment & LEFT) != 0)
			{
				p.x = containerRect.left + padding;
				if (!inside) p.x -= itemRect.width + padding * 2;
			}
			else if ((alignment & RIGHT) != 0)
			{
				p.x = containerRect.right + padding;
				if (inside) p.x -= itemRect.width + padding * 2;
			}
			
			return p;
		}
		
		public static function objectWithinRadiusOfTarget2(o:Object, radius:Number, target:Object):Boolean
		{
			var dx:Number = target.x - o.x;
			var dy:Number = target.y - o.y;
			return  (radius * radius) >= (dx * dx + dy * dy);
		}
		
		public static function objectWithinRadiusOfTarget3(o:Object, radius:Number, target:Object):Boolean
		{
			var dx:Number = target.x - o.x;
			var dy:Number = target.y - o.y;
			var dz:Number = target.z - o.z;
			return  (radius * radius) >= (dx * dx + dy * dy + dz * dz);
		}
		
		public static function distance2(o1:Object, o2:Object):Number
		{
			var dx:Number = o1.x - o2.x;
			var dy:Number = o1.y - o2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function distanceSquared2(o1:Object, o2:Object):Number
		{
			var dx:Number = o1.x - o2.x;
			var dy:Number = o1.y - o2.y;
			return (dx * dx + dy * dy);
		}
		
		public static function distanceSquared3(o1:Object, o2:Object):Number
		{
			var dx:Number = o1.x - o2.x;
			var dy:Number = o1.y - o2.y;
			var dz:Number = o1.z - o2.z;
			return (dx * dx + dy * dy + dz * dz);
		}
		
		public static function closest2(target:Object, points:Array):Object
		{
			var weightedList:Array = [];
			for each (var p:Object in points)
			{
				weightedList.push({w:(distanceSquared2(target, {x:p.x, y:p.y})), o:p});
			};
			weightedList = weightedList.sortOn("w", Array.NUMERIC);
			return weightedList[0].o;
		}
		
		public static function distanceToAngleInRadians2(o1:Object, o2:Object):Number
		{
			var dx:Number = o1.x - o2.x;
			var dy:Number = o1.y - o2.y;
			return Math.atan2(dx, dy);
		}
		
		public static function distanceToAngleInDegrees2(o1:Object, o2:Object):Number
		{
			var dx:Number = o1.x - o2.x;
			var dy:Number = o1.y - o2.y;
			return Math.atan2(dx, dy) * PI_OVER_180;
		}
		
		public static function shortestAngleBetweenInRadians(a1:Number, a2:Number):Number
		{
			var d:Number = a2 - a1;
			var a:Number = wrap(d, PI2);
			if (a >= PI)
			{
				a -= PI2;
			}
			return a;
		}
		
		public static function shortestAngleBetweenInDegrees(a1:Number, a2:Number):Number
		{
			var d:Number = a2 - a1;
			var a:Number = wrap(d, 360);
			if (a >= 180)
			{
				a -= 360;
			}
			return a;
		}
		
		public static function lerpRadians(a1:Number, a2:Number, t:Number):Number
		{
			a1 = wrap(a1, PI2);
			if (a1 > PI) a1 -= PI2;
			a2 = wrap(a2, PI2);
			if (a2 > PI) a2 -= PI2;
			return lerp(a1, a2, t);
		}
		
		public static function lerpDegrees(a1:Number, a2:Number, t:Number):Number
		{
			a1 = wrap(a1, 360);
			a2 = wrap(a2, 360);
			
			var d:Number = a1 - a2;
			if (d > 180)
			{
				if (a1 > 180)
				{
					a1 -= 360;
				}
				else
				{
					a2 -= 360;
				}
			}
			else if (d < -180)
			{
				if (a1 > 180)
				{
					a1 -= 360;
				}
				else
				{
					a2 -= 360;
				}
			}
						
			return lerp(a1, a2, t);
			
		}
		
		public static function nextHighestPowerOfTwo(n:uint):uint
		{
			var i:int = 2;
			
			while (i < n)
			{
				i << 1;
			}
			
			return i;
		}
		
	}
}