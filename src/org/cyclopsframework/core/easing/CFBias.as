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

package org.cyclopsframework.core.easing
{
	public class CFBias
	{
		public static const LINEAR:Function = linear;
		public static const REVERSE:Function = reverse;
		public static const EASE_IN:Function = easeIn;
		public static const EASE_OUT:Function = easeOut;
		public static const EASE_IN_OUT:Function = easeInOut;
		public static const EASE_SINE_WAVE_IN:Function = easeSineWaveIn;
		public static const EASE_SINE_WAVE_OUT:Function = easeSineWaveOut;
		public static const EASE_SINE_WAVE_IN_OUT:Function = easeSineWaveInOut;
		public static const EASE_EXP_IN:Function = easeExpIn;
		public static const EASE_EXP_OUT:Function = easeExpOut;
		public static const EASE_EXP_IN_OUT:Function = easeExpInOut;
		public static const EASE_ELASTIC_IN:Function = easeElasticIn;
		public static const EASE_ELASTIC_OUT:Function = easeElasticOut;
		public static const FLAT_TOP:Function = flatTop;
		public static const FLAT_MIDDLE:Function = flatMiddle;
		public static const FLAT_BOTTOM:Function = flatBottom;
		public static const NOISE:Function = noise;
		public static const SAWTOOTH_WAVE:Function = sawtoothWave;
		public static const SQUARE_WAVE:Function = squareWave;
		public static const SINE_WAVE:Function = sineWave;
		
		public function CFBias()
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