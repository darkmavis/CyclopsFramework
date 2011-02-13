package org.cyclopsframework.utils.collections
{
	import flash.utils.Dictionary;

	public class CFCache
	{
		private var _cache:Dictionary = new Dictionary();
				
		public function CFCache()
		{
			
		}
		
		public function getValue(key:Object, f:Function):Object
		{
			if (key in _cache)
			{
				return _cache[key];
			}
			else
			{
				return (_cache[key] = f());
			}
		}
		
		public function removeKey(key:Object):void
		{
			delete _cache[key];
		}
		
		public function clear():void
		{
			_cache = new Dictionary();
		}
		
	}
}