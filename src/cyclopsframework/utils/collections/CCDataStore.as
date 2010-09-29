package cyclopsframework.utils.collections
{
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.utils.Dictionary;
	
	import mx.utils.object_proxy;
	import cyclopsframework.utils.proxies.CCDataStoreProxy;
	
	public class CCDataStore
	{
		private var _data:CCHashSet = new CCHashSet();
		private var _remoteData:CCHashSet = new CCHashSet();
		private var _remoteItems:CCHashSet = new CCHashSet();
		
		public function get numItems():int { return _data.length + _remoteData.length; }
		
		private var _proxy:CCDataStoreProxy;
		public function get proxy():CCDataStoreProxy { return _proxy; }
		
		public function CCDataStore()
		{
			_proxy = new CCDataStoreProxy(this);
		}
		
		public function sync():void
		{
			_remoteData.clear();
			for each (var ritem:CCDataStoreRemoteItem in _remoteItems.items)
			{
				var item:Object = ritem.value;
				_remoteData.add(item);
			}
		}
				
		public function add(item:Object):CCDataStore
		{
			if (item is CCDataStoreRemoteItem)
			{
				_remoteItems.add(item);
			}
			else
			{
				_data.add(item);
			}
			
			return this;
		}
		
		public function remove(item:Object):CCDataStore
		{
			if (item is CCDataStoreRemoteItem)
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
		
		public function forEach(f:Function):CCDataStore 
		{
			for each (var item:Object in _data.items)
			{
				f(item);
			}
			
			for each (item in _remoteData.items)
			{
				f(item);
			}
			
			return this;
		}
				
		public function filter(f:Function, limit:int=int.MAX_VALUE):CCDataStore
		{
			var results:CCDataStore = new CCDataStore();
			
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
		
		public function map(f:Function):CCDataStore
		{
			var results:CCDataStore = new CCDataStore();
			
			forEach(function(item:Object):void
			{
				results.add(f(item));	
			});
			
			return results;
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
				
		public function find(query:Object, limit:int=int.MAX_VALUE):CCDataStore
		{
			var results:CCDataStore = filter(function(item:Object):Boolean
			{
				for (var key:String in query)
				{
					if (item.hasOwnProperty(key))
					{
						if (item[key] != query[key])
						{
							if (query[key] is CCBoolOp)
							{
								if ((query[key] as CCBoolOp).op(item[key]))
								{
									continue;
								}
							}
							
							return false;
						}
					}
					else if (query[key] is CCBoolOp)
					{
						if ((query[key] as CCBoolOp).op(null))
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
			var ds:CCDataStore = find(query, 1);
			var result:Object;
			ds.forEach(function(item:Object):void { result = item; });
			return result;
		}
		
		public function setProperties(kvObject:Object, deep:Boolean=false):CCDataStore
		{
			forEach(function(item:Object):void
			{
				CCUtils.setProperties(item, kvObject, deep);
			});
			return this;
		}
		
		public function toString():String
		{
			var result:String = "CCDataStore dump:\n";
			
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
		
		public function toArray():Array
		{
			var results:Array = [];
			forEach(function(item:Object):void
			{
				results.push(item);
			});
			return results;
		}
		
		public static function fromArray(source:Array):CCDataStore
		{
			var ds:CCDataStore = new CCDataStore();
			
			for each (var item:Object in source)
			{
				ds.add(item);
			}
			
			return ds;
		}
		
	}
}