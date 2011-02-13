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
	import flash.utils.Dictionary;

	public class CFRegistry
	{
		private var _table:Object = {};
		
		public function CFRegistry()
		{
		}
		
		public function addObject(key:String, value:Object):void
		{
			if (!_table.hasOwnProperty(key))
			{
				//_table[key] = new Dictionary();
				_table[key] = new CFDataStore();
			}
			
			//(_table[key] as Dictionary)[value] = value;
			(_table[key] as CFDataStore).add(value);
			
			//trace("adding " + key + ":" + value + " to registry.");
		}
		
		public function removeObject(key:String, value:Object):void
		{
			if (_table.hasOwnProperty(key))
			{
				//delete (_table[key] as Dictionary)[value];
				(_table[key] as CFDataStore).remove(value);
			}
		}
		
		//public function getObjects(key:String):Dictionary
		public function getObjects(key:String):CFDataStore
		{
			if (_table.hasOwnProperty(key))
			{
				//return _table[key];
				return _table[key] as CFDataStore;
			}
			else
			{
				//return new Dictionary();
				return new CFDataStore();
			}
		}
		
		public function removeKey(key:String):void
		{
			delete _table[key];
		}
		
		public function has(key:String):Boolean
		{
			return _table.hasOwnProperty(key);
		}
		
		// optimize this later
		public function count(key:String):int
		{
			var n:int = 0;
			
			if (_table.hasOwnProperty(key))
			{
				/*
				for each (var o:Object in _table[key])
				{
					n++;
				}
				*/
				n = (_table[key] as CFDataStore).numItems;
			}
			
			return n;
		}
		
		public function toString():String
		{
			var result:String = "";
			
			for each (var key:String in _table)
			{
				result += key + "\n";
			}
			
			return result;
		}
				
	}
}