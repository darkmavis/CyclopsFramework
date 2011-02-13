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

package org.cyclopsframework.utils.collections
{
	public dynamic class CFRange extends Array
	{
		private var _from:Number = 0;
		private var _fromReady:Boolean = false;
		
		private var _to:Number = 0;
		private var _toReady:Boolean = false;
		
		private var _step:Number = 1;
				
		public function CFRange(source:Array=null)
		{
			super();
			
			for each (var o:Object in source)
			{
				push(o);
			}
		}
		
		public static function create(source:Array=null):CFRange
		{
			return new CFRange(source);
		}
		
		public function from(n:Number):CFRange
		{
			_from = n;
			_fromReady = true;
			populate();
			return this;
		}
		
		public function xfrom(n:Number):CFRange
		{
			_from = n + _step;
			_fromReady = true;
			populate();
			return this;
		}
		
		public function to(n:Number):CFRange
		{
			_to = n;
			_toReady = true;
			populate();
			return this;
		}
		
		public function xto(n:Number):CFRange
		{
			_to = n - _step;
			_toReady = true;
			populate();
			return this;
		}
				
		public function step(n:Number):CFRange
		{
			_step = n;
			return this;
		}
		
		public function pushnums(...nums):CFRange
		{
			for each (var num:Number in nums)
			{
				push(num);
			}
			return this;
		}
		
		private function populate():CFRange
		{
			if ((_fromReady && _toReady) && (_step != 0))
			{
				var cursor:Number = _from;	
				var diff:Number = _to - _from;
				
				if (diff == 0)
				{
					push(cursor);
				}
				else
				{
					while (true)
					{
						push(cursor);
						if (((diff > 0) && (cursor >= _to)) || ((diff < 0) && (cursor <= _to))) break;
						cursor += _step;
					}
				}
			}
			
			return this;
		}
		
		
	}
}