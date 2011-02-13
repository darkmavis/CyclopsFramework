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
	import org.cyclopsframework.utils.proxies.CFHashSetProxy;
	
	import flash.utils.Dictionary;

	public class CFHashSet
	{
		private var _table:Dictionary = new Dictionary();
		public function get items():Dictionary { return _table; }
		
		private var _numItems:int = 0;
		public function get length():int { return _numItems; }
		
		private var _proxy:CFHashSetProxy;
		public function get proxy():CFHashSetProxy { return _proxy; }
		
		public function CFHashSet()
		{
			_proxy = new CFHashSetProxy(this);
		}
				
		public function add(item:Object):void
		{
			_table[item] = true;
			++_numItems;
		}
		
		public function remove(item:Object):void
		{
			if (has(item))
			{
				delete _table[item];
				--_numItems;
			}
		}
		
		public function has(item:Object):Boolean
		{
			return (_table[item] == true);
		}
		
		public function forEach(f:Function):void 
		{
			for (var item:Object in _table)
			{
				f(item);
			}
		}
				
		public function toArray():Array
		{
			var a:Array = [];
			
			for (var item:Object in _table)
			{
				a.push(item);
			}
			
			return a;
		}
		
		public function clear():void
		{
			_table = new Dictionary();
			_numItems = 0;
		}
	}
}