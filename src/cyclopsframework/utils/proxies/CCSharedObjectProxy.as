package cyclopsframework.utils.proxies
{
	import cyclopsframework.core.ICCDisposable;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.utils.collections.CCRegistry;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	
	public dynamic class CCSharedObjectProxy extends Proxy
	{
		private var _so:SharedObject;
		public function get $so():SharedObject { return _so; }
		
		public function CCSharedObjectProxy(so:SharedObject)
		{
			super();
			if (so == null) throw new Error("SharedObject provided to CCSharedObjectProxy is null.");
			_so = so;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return _so.data[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return _so.data.hasOwnProperty(name);
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			if (parameters.length == 0)
			{
				_so.setProperty(name, null);
			}
			else if (parameters.length == 1)
			{
				_so.setProperty(name, parameters[0]);
			}
			else
			{
				_so.setProperty(name, parameters);
			}
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_so.setProperty(name, value);
			_so.setDirty(name);
		}
		
	}
}