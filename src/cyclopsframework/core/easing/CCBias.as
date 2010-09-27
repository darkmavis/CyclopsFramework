package cyclopsframework.core.easing
{
	public class CCBias
	{
		public function CCBias()
		{
			
		}
		
		public static function linear(t:Number):Number
		{
			return t;
		}
		
		public static function reverse(t:Number):Number
		{
			return (1.0 - t);
		}
		
		public static function easeIn(t:Number):Number
		{
			return (t * t * t);
		}
		
		public static function easeOut(t:Number):Number
		{
			return (t - 1.0) * (t - 1.0) * (t - 1.0) + 1.0;
		}
		
		public static function easeInOut(t:Number):Number
		{
			return ((t /= 0.5) < 1.0) ? ((t * t * t) * 0.5) : (((t - 2.0) * (t - 2.0) * (t - 2.0) + 2.0) * 0.5);
		}
		
		public static function easeSineWaveIn(t:Number):Number
		{
			return (1.0 - Math.cos(t * Math.PI / 2.0));
		}
		
		public static function easeSineWaveOut(t:Number):Number
		{
			return Math.sin(t * Math.PI / 2.0);
		}
		
		public static function easeSineWaveInOut(t:Number):Number
		{
			return (1.0 - Math.cos(Math.PI * t)) / 2.0;
		}
		
		public static function easeExpIn(t:Number):Number
		{
			return Math.pow(2, 10.0 * (t - 1.0));
		}
		
		public static function easeExpOut(t:Number):Number
		{
			return Math.pow(2.0, -10.0 * t) + 1.0;
		}
		
		public static function easeExpInOut(t:Number):Number
		{
			return (((t /= 0.5) < 1.0) ? (Math.pow(2.0, 10.0 * (t - 1.0)) / 2.0) : (-Math.pow(2.0, -10.0 * (t - 1.0)) + 2.0) / 2.0);
		}
		
		public static function easeElasticIn(t:Number):Number
		{
			return -(Math.pow(2.0, 10.0 * (t - 1.0)) * Math.sin((t - 0.75) * (Math.PI * 2.0) / 0.3));
		}
		
		public static function easeElasticOut(t:Number):Number
		{
			return t + ((1.0 / (t * t * t)) * Math.sin(t * t * t * Math.PI * 8.0));
		}
		
		public static function flatTop(t:Number):Number
		{
			return 1.0;
		}
		
		public static function flatMiddle(t:Number):Number
		{
			return 0.5;
		}
		
		public static function flatBottom(t:Number):Number
		{
			return 0.0;
		}
		
		public static function noise(t:Number):Number
		{
			return Math.random();
		}
		
		public static function sawtoothWave(t:Number):Number
		{
			// note: t = 0.5 will hit 1.0
			return (t <= 0.5) ? (t * 2.0) : (2.0 - t * 2.0);
		}
		
		public static function squareWave(t:Number):Number
		{
			// note: t = 0.5 will hit 1.0 ... i think it's what you'd expect... details ;-p
			return (t < 0.5) ? 0.0 : 1.0;
		}
		
		public static function sineWave(t:Number):Number
		{
			return 0.5 + Math.sin((t*2.0-0.5) * Math.PI) * 0.5;
		}
	}
}