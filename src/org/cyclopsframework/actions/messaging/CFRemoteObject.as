package org.cyclopsframework.actions.messaging
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.CFMessage;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.proxies.CFSharedObjectProxy;
	
	public class CFRemoteObject extends CFAction
	{
		public static const TAG:String = "@CFRemoteObject";
		
		private var _so:CFSharedObjectProxy;
		public function get proxy():CFSharedObjectProxy { return _so; }
		
		private var _realSO:SharedObject;
		public function get sharedObject():SharedObject { return _realSO; }
		
		private var _nc:NetConnection;
		
		private var _hostAddress:String;
		private var _objectId:String;
		private var _statusListener:Function;
		
		private var _messageListeners:Object = {};
		
		public function get connected():Boolean { return (_nc != null) ? _nc.connected : false; }
		
		public function CFRemoteObject(hostAddress:String, objectId:String, statusListener:Function)
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
			CFLog.println("Error while attempting to connect to: " + _hostAddress, CFLog.CHANNEL_ERRORS);
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
				CFLog.println("Connected to: " + _hostAddress, CFLog.CHANNEL_INFO);
				var so:SharedObject = SharedObject.getRemote(_objectId, _nc.uri, false);
				_realSO = so;
				engine.sugar.waitForEvent(so, SyncEvent.SYNC, Number.MAX_VALUE, Number.MAX_VALUE, onSharedObjectUpdate);
				so.client = _messageListeners;
				//so.addEventListener(NetStatusEvent.NET_STATUS, onSOConnect);
				so.fps = 30;
				so.connect(_nc);
				_so = new CFSharedObjectProxy(so);
				
				engine.add(function():void { _statusListener(connected); });
			}
			else
			{
				CFLog.println("Couldn't connect to: " + _hostAddress, CFLog.CHANNEL_WARNINGS);
				_statusListener(connected);
				stop();
			}
			
			engine.context = null;
		}
		
		private function onSOConnect(e:NetStatusEvent):void
		{
			CFLog.println("SharedObject connected.", CFLog.CHANNEL_INFO);
			_so.$so.removeEventListener(NetStatusEvent.NET_STATUS, onSOConnect);
			_statusListener(connected);
		}
		
		private function onSharedObjectUpdate(e:SyncEvent):void
		{
			for each (var item:Object in e.changeList)
			{
				engine.send(_objectId, item.name, [_so[item.name]]);
			}
		}
		
		public function rpc(...args):void
		{
			_realSO.send.apply(null, args);
		}
		
		public function addMessageListener(name:String, listener:Function):void
		{
			_messageListeners[name] = listener;
		}
		
		public function removeMessageListener(name:String):void
		{
			delete _messageListeners[name];
		}
		
		public function close():void
		{
			_nc.close();
		}
		
		protected override function onExit():void
		{
			close();
		}
		
	}
}