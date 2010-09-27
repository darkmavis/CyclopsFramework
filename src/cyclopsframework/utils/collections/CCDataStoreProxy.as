package cyclopsframework.utils.collections
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CCDataStoreProxy extends Proxy
	{
		private var _datastore:CCDataStore;
		
		public function CCDataStoreProxy(datastore:CCDataStore)
		{
			super();
			_datastore = datastore;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			var results:Array = [];
			
			_datastore.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(methodName) && (item[methodName] is Function))
				{
					results.push(item[methodName].apply(args));
				}
			});
			
			return results;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			var results:Array = [];
			
			_datastore.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(name) && !(item[name] is Function))
				{
					results.push(item[name]);
				}
			});
			
			return results;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_datastore.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(name) && !(item[name] is Function))
				{
					item[name] = value;
				}
			});
		}


	}
}