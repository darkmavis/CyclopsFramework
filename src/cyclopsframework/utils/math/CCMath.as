package cyclopsframework.utils.math
{
	import cyclopsframework.core.easing.CCBias;
	
	import flash.geom.Point;

	public class CCMath
	{
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