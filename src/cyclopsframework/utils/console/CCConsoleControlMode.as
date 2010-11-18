package cyclopsframework.utils.console
{
	public class CCConsoleControlMode
	{
		private var _controlFunction:Function;
		public function get controlFunction():Function { return _controlFunction; }
		
		private var _defaultPrompt:String;
		public function get defaultPrompt():String { return _defaultPrompt; }
		
		private var _defaultCursor:String;
		public function get defaultCursor():String { return _defaultCursor; }
		
		public function CCConsoleControlMode(defaultPrompt:String, defaultCursor:String, controlFunction:Function)
		{
			_controlFunction = controlFunction;
			_defaultPrompt = defaultPrompt;
			_defaultCursor = defaultCursor;
		}
	}
}