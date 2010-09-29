package cyclopsframework.utils.math
{
	import cyclopsframework.core.easing.CCBias;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		
		public static function boxScatter2(p:Object, rect:Rectangle, bias:Function=null):Point
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
		
		public static function radialScatter2(p:Object, radius:Number, bias:Function=null):Point
		{
			if (bias == null)
			{
				return new Point(Math.random() * p.x * radius, Math.random() * p.y * radius);
			}
			else
			{
				return new Point(bias(Math.random()) * p.x * radius, bias(Math.random()) * p.y * radius);
			}
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