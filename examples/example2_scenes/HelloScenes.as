package org.cyclopsframework.examples.example2_scenes
{
	import flash.display.Sprite;
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.actions.flow.CFSleep;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.game.CFGame;
	
	[SWF(width="800", height="600", frameRate="30")]
	public class HelloScenes extends CFGame
	{
		public static const WIDTH:Number = 800;
		public static const HEIGHT:Number = 600;
		
		// Instance of this class in case we need it later.
		private static var _game:HelloScenes;
		public static function get game():HelloScenes { return _game; }
		
		public function HelloScenes()
		{
			// All defaults: width=800, height=600, fillBackground=false
			super(WIDTH, HEIGHT, false);
			
			// Provide this instance of this class in case we need it later.
			_game = this;
		}
		
		protected override function bootstrap():void
		{
			// Hide the console... you can bring it back with: console.show() or by pressing: [ESC]
			// If you really don't want the console, use: console.lock() and nothing will bring it back.
			console.hide();
			
			scene.addScene(new Gameplay());
			
		}
	}
}