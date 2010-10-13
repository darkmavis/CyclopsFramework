package cyclopsframework.game.bindings
{
	public class CCKeyboardBindings
	{
		private var _up:CCKeyboardBindingsGroup = new CCKeyboardBindingsGroup();
		public function get keyUp():CCKeyboardBindingsGroup { return _up; }
		
		private var _down:CCKeyboardBindingsGroup = new CCKeyboardBindingsGroup();
		public function get keyDown():CCKeyboardBindingsGroup { return _down; }
		
		public function CCKeyboardBindings()
		{
			
		}
		
	}
}