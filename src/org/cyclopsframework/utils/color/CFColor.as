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

package org.cyclopsframework.utils.color
{
	import flash.geom.ColorTransform;
	
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFColor
	{
		public static const BLACK:CFColor = new CFColor(0,0,0);
		public static const BLUE:CFColor = new CFColor(0,0,1);
		public static const GREEN:CFColor = new CFColor(0,1,0);
		public static const CYAN:CFColor = new CFColor(0,1,1);
		public static const RED:CFColor = new CFColor(1,0,0);
		public static const PURPLE:CFColor = new CFColor(1,0,1);
		public static const BROWN:CFColor = new CFColor(.7,.3,0);
		public static const GRAY:CFColor = new CFColor(.62,.62,.62);
		public static const YELLOW:CFColor = new CFColor(1,1,.38);
		public static const WHITE:CFColor = new CFColor(1,1,1);
		
		public static const EIGHT_COLORS:Vector.<CFColor> = Vector.<CFColor>([
			BLUE,
			GREEN,
			CYAN,
			RED,
			PURPLE,
			BROWN,
			GRAY,
			YELLOW
		]);
		
		public static const SIXTEEN_COLORS:Vector.<CFColor> = Vector.<CFColor>([
			boost(random()), boost(random()), boost(random()), boost(random()),
			boost(random()), boost(random()), boost(random()), boost(random()),
			boost(random()), boost(random()), boost(random()), boost(random()),
			boost(random()), boost(random()), boost(random()), boost(random())
		]);
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var a:Number;
						
		public function CFColor(r:Number, g:Number, b:Number, a:Number=1)
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		public function toColorTransform():ColorTransform
		{
			return new ColorTransform(r, g, b, a);
		}
		
		public function toUint():uint
		{
			return uint(r * 16711680 + g * 65280 + b * 255);
		}
		
		public static function fromUint(c:uint):CFColor
		{
			var a:uint = (c >>> 24);
			var r:uint = (c >>> 16) & 0x000000FF;
			var g:uint = (c >>> 8) & 0x000000FF;
			var b:uint = c & 0x000000FF;
			
			return new CFColor(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
		}
		
		public static function fromColorTransform(ct:ColorTransform):CFColor
		{
			return new CFColor(ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, ct.alphaMultiplier);
		}
		
		public static function random(randomizeAlpha:Boolean=false):CFColor
		{
			return new CFColor(CFMath.random(), CFMath.random(), CFMath.random(), !randomizeAlpha ? 1.0 : CFMath.random());
		}
				
		public static function lerp(target:CFColor, c1:CFColor, c2:CFColor, t:Number):CFColor
		{
			target.r = CFMath.lerp(c1.r, c2.r, t);
			target.g = CFMath.lerp(c1.g, c2.g, t);
			target.b = CFMath.lerp(c1.b, c2.b, t);
			target.a = CFMath.lerp(c1.a, c2.a, t);
			return target;
		}
		
		public static function add(target:CFColor, c1:CFColor, c2:CFColor):CFColor
		{
			target.r = c1.r * c1.a + c2.r * c2.a;
			target.g = c1.g * c1.a + c2.g * c2.a;
			target.b = c1.b * c1.a + c2.b * c2.a;
			return target;
		}
		
		public static function subtract(target:CFColor, c1:CFColor, c2:CFColor):CFColor
		{
			target.r = c1.r * c1.a - c2.r * c2.a;
			target.g = c1.g * c1.a - c2.g * c2.a;
			target.b = c1.b * c1.a - c2.b * c2.a;
			return target;
		}
		
		public static function multiply(target:CFColor, c1:CFColor, c2:CFColor):CFColor
		{
			target.r = c1.r * c1.a * c2.r * c2.a;
			target.g = c1.g * c1.a * c2.g * c2.a;
			target.b = c1.b * c1.a * c2.b * c2.a;
			return target;
		}
		
		public static function boost(c:CFColor):CFColor
		{
			var maxc:Number = Math.max(c.r, c.g, c.b);
			var d:Number = (1.0 / Math.min(maxc, 1.0));
			
			return new CFColor(c.r * d, c.g * d, c.b * d)
		}
				
	}
}