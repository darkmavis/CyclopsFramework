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
	import org.cyclopsframework.utils.misc.CFUtils;
	import org.cyclopsframework.utils.proxies.CFDataStoreProxy;
	
	public class CFDataStore
	{
		private var _data:CFHashSet = new CFHashSet();
		private var _remoteData:CFHashSet = new CFHashSet();
		private var _remoteItems:CFHashSet = new CFHashSet();
		
		public function get numItems():int { return _data.length + _remoteData.length; }
		
		private var _proxy:CFDataStoreProxy;
		public function get proxy():CFDataStoreProxy { return _proxy; }
		
		public function CFDataStore()
		{
			_proxy = new CFDataStoreProxy(this);
		}
		
		public function sync():void
		{
			_remoteData.clear();
			//for (var ritem:CFDataStoreRemoteItem in _remoteItems.items)
			_remoteItems.forEach(function(ritem:CFDataStoreRemoteItem):void
			{
				var item:Object = ritem.value;
				_remoteData.add(item);
			});
		}
		
		public function add(...items):CFDataStore
		{
			for each (var item:Object in items)
			{
				if (item is CFDataStoreRemoteItem)
				{
					_remoteItems.add(item);
				}
				else
				{
					_data.add(item);
				}
			}
			
			return this;
		}
		
		public function addEach(collection:Object, mapFunc:Function=null):CFDataStore
		{
			for each (var item:Object in collection)
			{
				if (item is CFDataStoreRemoteItem)
				{
					_remoteItems.add(item);
				}
				else
				{
					if (mapFunc != null)
					{
						_data.add(mapFunc(item));
					}
					else
					{
						_data.add(item);
					}
				}
			}
			
			return this;
		}
		
		public function remove(item:Object):CFDataStore
		{
			if (item is CFDataStoreRemoteItem)
			{
				_remoteItems.remove(item);
			}
			else
			{
				_data.remove(item);
			}
			
			return this;
		}
		
		public function has(item:Object):Boolean
		{
			return (_data.has(item) || _remoteData.has(item));
		}
		
		public function forEach(f:Function):CFDataStore 
		{
			_data.forEach(f);
			_remoteData.forEach(f);
			return this;
		}
				
		public function filter(f:Function, limit:int=int.MAX_VALUE):CFDataStore
		{
			var results:CFDataStore = new CFDataStore();
			
			forEach(function(item:Object):void
			{
				// find a better solution to this later.
				if (results.numItems >= limit) return;
				
				if (f(item))
				{
					results.add(item);
				}
			});
			
			return results;
		}
		
		public function map(f:Function):CFDataStore
		{
			var results:CFDataStore = new CFDataStore();
			
			forEach(function(item:Object):void
			{
				results.add(f(item));	
			});
			
			return results;
		}
		
		public function sort(comparator:Function):Array
		{
			var results:Array = toArray();
			quicksort(results, 0, results.length - 1, comparator);
			return results;
		}
		
		private function quicksort(source:Array, left:int, right:int, comparator:Function):void
		{
			var i:int = left;
			var j:int = right;
			
			var pivotPoint:Object = source[int((left + right) * .5 + .5)]; //   Math.round((left + right) * .5)];
			
			while (i <= j)
			{
				while (comparator(source[i], pivotPoint) < 0) // (source[i] < pivotPoint)
				{
					++i;
				}
				
				while (comparator(source[i], pivotPoint) > 0) // (source[j] > pivotPoint)
				{
					--j;
				}
				
				if (i <= j)
				{
					var tmp:Object = source[i];
					source[i] = source[j];
					++i;
					source[j] = tmp;
					--j;
				}
			}
			
			if (left < j)
			{
				quicksort(source, left, j, comparator);
			}
			
			if (i < right)
			{
				quicksort(source, i, right, comparator);
			}
			
			return;
		}
		
		public function extract(... rest):Array
		{
			var results:Array = [];
			
			if(rest.length == 1)
			{
				forEach(function(item:Object):void
				{
					results.push(item[rest[0]]);
				});
			}
			else
			{
				forEach(function(item:Object):void
				{
					var tmpItem:Object = {};
					for each (var key:String in rest)
					{
						if (item.hasOwnProperty(key))
						{
							tmpItem[key] = item[key];
						}
					}
					results.push(tmpItem);
				});
			}
			
			return results;
		}
				
		public function find(query:Object, limit:int=int.MAX_VALUE):CFDataStore
		{
			var results:CFDataStore = filter(function(item:Object):Boolean
			{
				for (var key:String in query)
				{
					if (item.hasOwnProperty(key))
					{
						if (item[key] != query[key])
						{
							if (query[key] is CFBoolOp)
							{
								if ((query[key] as CFBoolOp).op(item[key]))
								{
									continue;
								}
							}
							
							return false;
						}
					}
					else if (query[key] is CFBoolOp)
					{
						if ((query[key] as CFBoolOp).op(null))
						{
							continue;
						}
						else
						{
							return false;
						}
					}
					else
					{
						return false;
					}
				}
				
				return true;
				
			}, limit);
			
			return results;
		}
		
		public function findOne(query:Object):Object
		{
			var ds:CFDataStore = find(query, 1);
			var result:Object;
			ds.forEach(function(item:Object):void { result = item; });
			return result;
		}
		
		public function first():Object
		{
			var result:Object;
			
			forEach(function(item:Object):void
			{
				result = item;
			});
			
			return result;
		}
		
		public function random():Object
		{
			return toArray().random;
		}
		
		public function setProperties(kvObject:Object, deep:Boolean=false):CFDataStore
		{
			forEach(function(item:Object):void
			{
				CFUtils.setProperties(item, kvObject, deep);
			});
			return this;
		}
		
		public function toString():String
		{
			var result:String = "CFDataStore dump:\n";
			
			forEach(function(item:Object):void
			{
				var kvs:Array = []; 
				for (var key:String in item)
				{
					kvs.push(key + ":" + item[key]);
				}
				result += "{ " + kvs.join(",\t") + " }\n";
			});
			
			return result + "\n";
		}
		
		public function toArray():CFArray
		{
			var results:CFArray = new CFArray();
			forEach(function(item:Object):void
			{
				results.push(item);
			});
			return results;
		}
		
		public static function fromArray(source:Array):CFDataStore
		{
			var ds:CFDataStore = new CFDataStore();
			
			for each (var item:Object in source)
			{
				ds.add(item);
			}
			
			return ds;
		}
		
	}
}