package cyclopsframework.utils.logging
{
	public class CCLog
	{
		public static const CHANNEL_DEFAULT:String = "default";
		public static const CHANNEL_INFO:String = "info";
		public static const CHANNEL_WARNINGS:String = "warnings";
		public static const CHANNEL_ERRORS:String = "errors";
		
		private static var _logger:ICCLogger;
		public static function set logger(value:ICCLogger):void { _logger = value; }
		
		public function CCLog()
		{
			throw new Error("No need to instantiate CCLog.");
		}
		
		public static function print(text:String, channel:String=CHANNEL_DEFAULT):void
		{
			if (_logger != null)
			{
				_logger.print(text, channel);
			}
			else
			{
				trace(text);
			}
		}
		
		public static function println(text:String, channel:String=CHANNEL_DEFAULT):void
		{
			if (_logger != null)
			{
				_logger.println(text, channel);
			}
			else
			{
				trace(text);
			}
		}
		
	}
}