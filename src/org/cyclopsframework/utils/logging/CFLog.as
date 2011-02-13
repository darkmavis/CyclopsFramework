package org.cyclopsframework.utils.logging
{
	public class CFLog
	{
		public static const CHANNEL_DEFAULT:String = "default";
		public static const CHANNEL_INFO:String = "info";
		public static const CHANNEL_WARNINGS:String = "warnings";
		public static const CHANNEL_ERRORS:String = "errors";
		
		private static var _logger:ICFLogger;
		public static function set logger(value:ICFLogger):void { _logger = value; }
		
		public function CFLog()
		{
			throw new Error("No need to instantiate CFLog.");
		}
		
		public static function print(text:Object="", channel:String=CHANNEL_DEFAULT):void
		{
			if (_logger != null)
			{
				_logger.print(String(text), channel);
			}
			else
			{
				trace(text);
			}
		}
		
		public static function println(text:Object="", channel:String=CHANNEL_DEFAULT):void
		{
			if (_logger != null)
			{
				_logger.println(String(text), channel);
			}
			else
			{
				trace(text);
			}
		}
		
	}
}