package cyclopsframework.actions.messaging
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.utils.logging.CCLog;
	import cyclopsframework.utils.proxies.CCSharedObjectProxy;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	public class CCRemoteObject extends CCAction
	{
		public static const TAG:String = "@CCRemoteObject";
				
		private var _so:CCSharedObjectProxy;
		public function get proxy():CCSharedObjectProxy { return _so; }
		
		private var _nc:NetConnection;
		
		private var _hostAddress:String;
		private var _objectId:String;
		private var _statusListener:Function;
		
		private var _messageListeners:Object = {};
		
		public function get connected():Boolean { return (_nc != null) ? _nc.connected : false; }
		
		public function CCRemoteObject(hostAddress:String, objectId:String, statusListener:Function)
		{
			super(0, Number.MAX_VALUE, null, [TAG]);
			_hostAddress = hostAddress;
			_objectId = objectId;
			_statusListener = statusListener;
		}
				
		protected override function onEnter():void
		{
			_nc = new NetConnection();
			_nc.objectEncoding = ObjectEncoding.AMF3;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onConnect);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_nc.client = this;
			_nc.connect(_hostAddress);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			CCLog.println("Error while attempting to connect to: " + _hostAddress, CCLog.CHANNEL_ERRORS);
			_statusListener(false);
			stop();
		}
		
		private function onConnect(event:Event):void
		{
			engine.context = this;
			
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, onConnect);
			_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			if (connected)
			{
				CCLog.println("Connected to: " + _hostAddress, CCLog.CHANNEL_INFO);
				var so:SharedObject = SharedObject.getRemote(_objectId, _nc.uri, true);
				engine.waitForEvent(so, SyncEvent.SYNC, Number.MAX_VALUE, Number.MAX_VALUE, onSharedObjectUpdate);
				so.client = _messageListeners;
				so.connect(_nc);
				_so = new CCSharedObjectProxy(so);
				_statusListener(connected);
			}
			else
			{
				CCLog.println("Couldn't connect to: " + _hostAddress);
				_statusListener(connected);
				stop();
			}
			
			engine.context = null;
		}
		
		private function onSharedObjectUpdate(e:SyncEvent):void
		{
			for each (var item:Object in e.changeList)
			{
				engine.send(_objectId, item.name, [_so[item.name]]);
			}
		}
		
		public function addMessageListener(name:String, listener:Function):void
		{
			_messageListeners[name] = listener;
		}
		
		public function removeMessageListener(name:String):void
		{
			delete _messageListeners[name];
		}
				
	}
}