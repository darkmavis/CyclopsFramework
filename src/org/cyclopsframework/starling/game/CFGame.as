package org.cyclopsframework.starling.game
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.utils.console.CFConsole;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.math.CFMath;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CFGame extends Sprite
	{
		private var _scene:CFScene;
		public function get scene():CFScene { return _scene; }
		
		private var _console:CFConsole;
		public function get console():CFConsole { return _console; }
		
		private var _consoleEnabled:Boolean = false;
		
		public function get self():CFGame { return this; }
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; };
		
		private var _centerPoint:Point;
		public function get centerPoint():Point { return _centerPoint; }
		
		private var _lastTime:Number = flash.utils.getTimer();
		
		public function CFGame(gameWidth:Number=960, gameHeight:Number=640, consoleEnabled:Boolean=true)
		{
			super();
			
			_rect = new Rectangle(0, 0, gameWidth, gameHeight);
			
			addEventListener(Event.ADDED_TO_STAGE, onReady);
		}
		
		private function onReady(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onReady);
			
			_scene = new CFScene();
			
			addChild(_scene.bg);
			
			if (_consoleEnabled)
			{
				_console = new CFConsole(_rect.width, _rect.height);
				
				_console.scriptingContext["game"] = this;
				_console.scriptingContext["find"] = scene.find;
				
				Starling.current.nativeStage.addChild(_console.bg);
				
				CFLog.logger = _console;
			}
			
			bootstrap();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var currentTime:Number = flash.utils.getTimer();
			var delta:Number = CFMath.clamp((currentTime - _lastTime) / 1000, Number.MIN_VALUE, .5);
			
			_lastTime = currentTime;
			
			scene.update(delta);
			
			if (_consoleEnabled)
			{
				console.update(delta);
			}
		}
		
		protected function bootstrap():void
		{
			CFLog.println("Override bootstrap in CFGame to begin writing your game.");
		}
	}
}