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
	
	public dynamic class CCSharedObjectProxy extends Proxy //implements ICCDisposable, ICCTaggable
	{
		public static const TAG:String = "CCSharedObjectProxy";
		
		private var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
		private var _so:SharedObject;
		
		//private var _snapshots:Object = {};
		
		public function CCSharedObjectProxy(so:SharedObject)
		{
			super();
			if (so == null) throw new Error("SharedObject provided to CCSharedObjectProxy is null.");
			_so = so;
			//_so.addEventListener(SyncEvent.SYNC, onSync);
		}
		
		/*
		private function onSync(e:SyncEvent):void
		{
			
			for each (var clo:Object in e.changeList)
			{
				if (_snapshots.hasOwnProperty(clo.name))
				{
					var a:Array = _snapshots[clo.name] as Array;
					a.unshift(clo.oldValue);
					if (a.length > 3)
					{
						a.pop();
					}
				}
			}
			
		}
		*/
		
		/*
		public function addToInterpolatedProperties(propertyName:String):void
		{
			if (!_snapshots.hasOwnProperty(propertyName))
			{
				_snapshots[propertyName] = [];
			}
		}
		*/
		
		/*
		public function dispose():void
		{
			_so.removeEventListener(SyncEvent.SYNC, onSync);
		}
		*/
		
		/* cool, but possibly not cool. */
		
		/*
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			if (_so.data.hasOwnProperty(name))
			{
				_so.send([name].concat(parameters));
			}
		}
		*/
		
		override flash_proxy function getProperty(name:*):*
		{
			/*
			if (_snapshots.hasOwnProperty(name))
			{
				var result:Number = _so.data[name] as Number;
				var a:Array = _snapshots[name] as Array;
				var len:int = a.length;
				for (var i:int = 0; i < len; ++i)
				{
					result += a[i];
				}
				return null;//((len > 0) ? CCMath.lerp(result + (result / len) *  : result);
			}
			else
			{
			*/
			return _so.data[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return _so.data.hasOwnProperty(name);
		}
				
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_so.setProperty(name, value);
			_so.setDirty(name);
		}
		
	}
}