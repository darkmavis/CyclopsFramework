package cyclopsframework.utils.proxies
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CCFunctionProxy extends Proxy
	{
		private var _f:Function;
		
		public function CCFunctionProxy(f:Function)
		{
			super();
			_f = f;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{	
			_f(methodName, args);
			return null;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return null;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_f(name, [value]);
		}
	}
}