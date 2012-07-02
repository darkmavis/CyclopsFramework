/**
 * This code was borrowed from the AS3 Utilities project by skyboy.
 * As legally required, here is the copyright notice from that project.
 * Note: The following code may not exactly match the original.
 * 
 * AS3 Utilities by skyboy. April 10th 2010.
 * Visit http://github.com/skyboy for documentation, updates
 * and more free code.
 *
 *
 * Copyright (c) 2010, skyboy
 *    All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software with
 * restriction, with limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions and limitations:
 *
 * ^ Attribution will be given to:
 *  	skyboy, http://www.kongregate.com/accounts/skyboy;
 *  	http://github.com/skyboy; http://skybov.deviantart.com
 *
 * ^ Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer in all copies or
 * substantial portions of the Software.
 *
 * ^ Redistributions of modified source code must be marked as such, with
 * the modifications marked and ducumented and the modifer's name clearly
 * listed as having modified the source code.
 *
 * ^ Redistributions of source code may not add to, subtract from, or in
 * any other way modify the above copyright notice, this list of conditions,
 * or the following disclaimer for any reason.
 *
 * ^ Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * THE SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * OR COPYRIGHT HOLDERS OR CONTRIBUTORS  BE LIABLE FOR ANY CLAIM, DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * OR OTHER LIABILITY,(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER AN ACTION OF IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING FROM, OUT OF, IN CONNECTION OR
 * IN ANY OTHER WAY OUT OF THE USE OF OR OTHER DEALINGS WITH THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package org.cyclopsframework.utils.math
{
	import flash.utils.getTimer;

	public class CFRandom
	{
		//private static const r:CFRandom = new CFRandom((new Date().time & 0xFFFFFFFF) ^ getTimer());
		
		/**
		 * randomNumber
		 * @return Number: A number that is less than or equal to zero and less than one
		 */
		//public static function randomNumber():Number {
		//	return r.extractNumber();
		//}
		
		private const MT:Vector.<uint> = new Vector.<uint>(624, true);
		private var index:int, _seed:int;
		private const yA1:uint = 2636928640, yA2:uint = 4022730752;
		private const a:uint = 2147483648, b:uint = 2147483647, c:uint = 2567483615, d:uint = 624, e:uint = 397;
		private static const I_MAX:uint = int.MAX_VALUE;
		private static const U_MAX:uint = uint.MAX_VALUE;
		private static const iDIV:Number = I_MAX + Number.MIN_VALUE + 1;
		private static const uDIV:Number = U_MAX + Number.MIN_VALUE;
		
		/**
		 * Get the seed currently in use
		 */
		public function get seed():int
		{
			return _seed;
		}
		
		/**
		 * Set the seed currently in use (resets state)
		 */
		public function set seed(a:int):void
		{
			if (a != _seed) {
				_seed = a;
				var i:int, b:int = a;
				index = i;
				MT[i] = a;
				while (++i < 624) {
					b = (MT[i] = (1812433253 * Number(b ^ (b >>> 30)) + i) & 0xFFFFFFFF);
				}
			}
		}
		
		/**
		 * @param	int: seed	The seed number to use, using the same seed will get you the same results each time
		 */
		public function CFRandom(seed:int):void
		{
			_seed = seed - 1;
			this.seed = seed;
		}
		
		/**
		 * Returns a number that is greater than or equal to zero and less than one
		 * @return Number: A number that is greater than or equal to zero and less than one
		 */
		public function extractNumber():Number
		{
			var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
			index = (i + 1) % 624;
			var u:uint = (y & a) | (MT[index] & b);
			MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
			y ^= y >>> 11;
			y ^= (y << 7) & yA1;
			y ^= (y << 15) & yA2;
			y ^= y >>> 18;
			return y / uDIV;
		}
		
		/**
		 * Returns a number that is greater than negative one and less than one
		 * @return Number: A number that is greater than negative one and less than one
		 */
		public function extractNumber2():Number
		{
			var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
			index = (i + 1) % 624;
			var u:uint = (y & a) | (MT[index] & b);
			MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
			y ^= y >>> 11;
			y ^= (y << 7) & yA1;
			y ^= (y << 15) & yA2;
			return (y ^ (y >>> 18)) / iDIV;
		}
		
		/**
		 * Returns a number that is greater than negative 0.5 and less than 0.5
		 * @return Number: A number that is greater than negative 0.5 and less than 0.5
		 */
		public function extractNumber3():Number
		{
			var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
			index = (i + 1) % 624;
			var u:uint = (y & a) | (MT[index] & b);
			MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
			y ^= y >>> 11;
			y ^= (y << 7) & yA1;
			y ^= (y << 15) & yA2;
			return int(y ^ (y >>> 18)) / uDIV;
		}
		
		/**
		 * Returns an unsigned integer between 0 and uint.MAX_VALUE
		 * @return uint: An unsigned integer between 0 and uint.MAX_VALUE
		 */
		public function extractUint():uint
		{
			var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
			index = (i + 1) % 624;
			var u:uint = (y & a) | (MT[index] & b);
			MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
			y ^= y >>> 11;
			y ^= (y << 7) & yA1;
			y ^= (y << 15) & yA2;
			return (y ^ (y >>> 18));
		}
		
		/**
		 * Returns an unsigned integer between min and max
		 * @return uint: An unsigned integer between min and max
		 */
		public function extractBoundedUint(min:uint, max:uint):uint
		{
			var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
			index = (i + 1) % 624;
			var u:uint = (y & a) | (MT[index] & b);
			MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
			y ^= y >>> 11;
			y ^= (y << 7) & yA1;
			y ^= (y << 15) & yA2;
			y ^= y >>> 18;
			if (max < min) {
				return (y % (min + 1 - max)) + max;
			}
			return (y % (max + 1 - min)) + min;
		}
		
		/**
		 * extractExperimentalUint
		 * @return int: An unsigned integer between 0 and uint.MAX_VALUE
		 * /
		 public function extractExperimentalUint():uint {
		 var i:int = index, MT:Vector.<uint> = this.MT, y:uint = MT[i];
		 index = (i + 1) % 624;
		 var u:uint = (y & a) | (MT[index] & b);
		 MT[i] = (MT[(i + e) % d] ^ (u >>> 1)) ^ (c & (-(u & 1)));
		 y ^= y >>> 11;
		 y ^= (y << 7) & yA1;
		 y ^= (y << 15) & yA2;
		 return (y ^ (y >>> 18));
		 }//*/
		private function generateNumbers():void
		{
			var i:int, y:int, MT:Vector.<uint> = this.MT;
			while (i < 624) {
				y = (MT[i] & a) | (MT[(i+1) % d] & b);
				MT[i] = (MT[(i + e) % d] ^ (y >>> 1)) ^ (c & (-(y & 1)));
				++i;
			}
		}
		
	}
}