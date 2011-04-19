package org.cyclopsframework.utils.proxies
{
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	
	import org.cyclopsframework.core.ICFDisposable;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.utils.collections.CFRegistry;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	public dynamic class CFSharedObjectProxy extends Proxy
	{
		private var _so:SharedObject;
		public function get $so():SharedObject { return _so; }
		
		public function CFSharedObjectProxy(so:SharedObject)
		{
			super();
			if (so == null) throw new Error("SharedObject provided to CFSharedObjectProxy is null.");
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
			var localName:String = String(name);
			
			if (name is QName)
			{
				localName = (name as QName).localName;
			}
			
			if (parameters.length == 0)
			{
				_so.send.apply(null, [localName]);
			}
			else if (parameters.length == 1)
			{
				_so.send.apply(null, [localName].concat(parameters));
			}
			else
			{
				_so.send.apply(null, [localName].concat(parameters));
			}
			
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_so.setProperty(name, value);
			_so.setDirty(name);
		}
		
	}
}