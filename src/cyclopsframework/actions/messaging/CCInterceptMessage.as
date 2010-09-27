package cyclopsframework.actions.messaging
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCMessageInterceptor;
	
	public class CCInterceptMessage extends CCAction implements ICCMessageInterceptor
	{
		public static const TAG:String = "@CCInterceptMessage";
		
		private var _messageListener:Function;
		
		public function CCInterceptMessage(
			timeout:Number,
			cycles:Number,
			messageListener:Function)
		{
			super(timeout, cycles, null, [TAG]);
			_messageListener = messageListener;
		}
		
		public function interceptMessage(message:CCMessage):void
		{
			_messageListener(message);
		}
	}
}