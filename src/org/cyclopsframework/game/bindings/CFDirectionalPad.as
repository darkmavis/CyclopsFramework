package org.cyclopsframework.game.bindings
{
	import flash.geom.Point;
	
	import org.cyclopsframework.game.CFSceneObject;

	public class CFDirectionalPad extends CFSceneObject
	{
		public static const TAG:String = "CFDirectionalPad";
		
		private var _direction:Point = new Point();
		public function get direction():Point { return _direction; }
				
		private var _kb:CFKeyboardBindings;
		
		private var _keypressHandler:Function;
		public function get keypressHandler():Function { return _keypressHandler; }
		public function set keypressHandler(value:Function):void { _keypressHandler = value; }
		
		private var _pressed:Boolean = false;
		public function get pressed():Boolean { return _pressed; }
		public function set pressed(value:Boolean):void
		{
			_pressed = value;
			if (_keypressHandler != null)
			{
				if (engine == null) throw new Error("A CFDirectionalPad must be registered with a CFEngine.");
				if ((engine.count("keypressHandler") == 0) && !("CFDirectionalPad.kph" in engine.frameData))
				{
					engine.frameData["CFDirectionalPad.kph"] = "CFDirectionalPad.kph";
					engine.sugar.loop(function():void { if (_pressed) _keypressHandler(); }).addTag("keypressHandler");
				}
			}
		}
		
		public function CFDirectionalPad(kb:CFKeyboardBindings=null)
		{
			super(TAG);
			_kb = kb;
		}
		
		private function left():void
		{
			_direction.x = -1;
			pressed = true;
		}
		
		private function right():void
		{
			_direction.x = 1;
			pressed = true;
		}
		
		private function up():void
		{
			_direction.y = -1;
			pressed = true;
		}
		
		private function down():void
		{
			_direction.y = 1;
			pressed = true;
		}
				
		private function resetXAxis():void
		{
			_direction.x = 0;
			_pressed = false;
			engine.remove("keypressHandler");
		}
		
		private function resetYAxis():void
		{
			_direction.y = 0;
			_pressed = false;
			engine.remove("keypressHandler");
		}
		
		public function bindArrows(kb:CFKeyboardBindings=null):void
		{
			var akb:CFKeyboardBindings = (kb == null) ? _kb : kb;
			var k:CFKeyboardBindingsGroup = akb.keyDown;
			k.left = left;
			k.right = right;
			k.up = up;
			k.down = down;
			
			k = akb.keyUp;
			k.left = k.right = resetXAxis;
			k.up = k.down = resetYAxis;
		}
		
		public function bindWASD(kb:CFKeyboardBindings=null):void
		{
			var akb:CFKeyboardBindings = (kb == null) ? _kb : kb;
			var k:CFKeyboardBindingsGroup = akb.keyDown;
			k.a = left;
			k.d = right;
			k.w = up;
			k.s = down;
			
			k = akb.keyUp;
			k.a = k.d = resetXAxis;
			k.w = k.s = resetYAxis;
		}
		
				
	}
}