package cyclopsframework.utils.collections
{
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.CCMessage;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CCMessageProxy extends Proxy
	{
		private var _engine:CCEngine;
		private var _tag:String;
		private var _sender:Object;
		private var _receiverType:Class;
		
		public function CCMessageProxy(engine:CCEngine, tag:String, sender:Object=null, receiverType:Class=null)
		{
			super();
			_engine = engine;
			_tag = tag;
			_sender = sender;
			_receiverType = receiverType;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{	
			_engine.send(_tag, methodName, args, _sender, _receiverType);	
			return null;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return null;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_engine.send(_tag, name, [value], _sender, _receiverType);
		}
	}
}