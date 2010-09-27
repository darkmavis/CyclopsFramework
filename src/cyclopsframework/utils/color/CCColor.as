package cyclopsframework.utils.color
{
	import cyclopsframework.utils.math.CCMath;
	
	import flash.geom.ColorTransform;
	
	public class CCColor
	{
		public static const BLACK:CCColor = new CCColor(0,0,0);
		public static const BLUE:CCColor = new CCColor(0,0,1);
		public static const GREEN:CCColor = new CCColor(0,1,0);
		public static const CYAN:CCColor = new CCColor(0,1,1);
		public static const RED:CCColor = new CCColor(1,0,0);
		public static const PURPLE:CCColor = new CCColor(1,0,1);
		public static const BROWN:CCColor = new CCColor(.7,.3,0);
		public static const GRAY:CCColor = new CCColor(.62,.62,.62);
		public static const YELLOW:CCColor = new CCColor(1,1,.38);
		public static const WHITE:CCColor = new CCColor(1,1,1);
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var a:Number;
						
		public function CCColor(r:Number, g:Number, b:Number, a:Number=1)
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
		
		public static function fromColorTransform(ct:ColorTransform):CCColor
		{
			return new CCColor(ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, ct.alphaMultiplier);
		}
				
		public static function lerp(target:CCColor, c1:CCColor, c2:CCColor, t:Number):CCColor
		{
			target.r = CCMath.lerp(c1.r, c2.r, t);
			target.g = CCMath.lerp(c1.g, c2.g, t);
			target.b = CCMath.lerp(c1.b, c2.b, t);
			target.a = CCMath.lerp(c1.a, c2.a, t);
			return target;
		}
		
		public static function add(target:CCColor, c1:CCColor, c2:CCColor, t:Number):CCColor
		{
			target.r = c1.r * c1.a + c2.r * c2.a;
			target.g = c1.g * c1.a + c2.g * c2.a;
			target.b = c1.b * c1.a + c2.b * c2.a;
			return target;
		}
		
		public static function subtract(target:CCColor, c1:CCColor, c2:CCColor, t:Number):CCColor
		{
			target.r = c1.r * c1.a - c2.r * c2.a;
			target.g = c1.g * c1.a - c2.g * c2.a;
			target.b = c1.b * c1.a - c2.b * c2.a;
			return target;
		}
		
		public static function multiply(target:CCColor, c1:CCColor, c2:CCColor, t:Number):CCColor
		{
			target.r = c1.r * c1.a * c2.r * c2.a;
			target.g = c1.g * c1.a * c2.g * c2.a;
			target.b = c1.b * c1.a * c2.b * c2.a;
			return target;
		}
				
	}
}