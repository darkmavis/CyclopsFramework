package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCMessageInterceptor;
	
	public class CCWaitForMessage extends CCAction implements ICCMessageInterceptor
	{
		public static const TAG:String = "@CCWaitForMessage";
		
		private var _messageName:String;
		private var _messageListener:Function;
		private var _timeoutListener:Function;
		private var _timedOut:Boolean = true;
		
		public function CCWaitForMessage(
			messageName:String,
			timeout:Number=Number.MAX_VALUE,
			cycles:Number=1,
			messageListener:Function=null,
			timeoutListener:Function=null)
		{
			super(timeout, cycles, null, [TAG]);
			_messageName = messageName;
			_messageListener = messageListener;
			_timeoutListener = timeoutListener;
		}
		
		public function interceptMessage(msg:CCMessage):void
		{
			if ((_messageName == null) || (_messageName == msg.name))
			{
				_timedOut = false;
				if (_messageListener != null) _messageListener(msg);
				this.stop();
			}
		}
		
		protected override function onLastFrame():void
		{
			if ((_timeoutListener != null) && _timedOut) _timeoutListener();
		}
		
	}
}