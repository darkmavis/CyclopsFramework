package cyclopsframework.game
{
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;
	
	public class CCGame extends Sprite
	{
		private var _engine:CCEngine = new CCEngine();
		public function get engine():CCEngine { return _engine; }
		
		private var _lastTime:Number = flash.utils.getTimer();
		
		public function CCGame()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME, onReady);
		}
		
		private function onReady(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onReady);
			
			bootstrap();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var currentTime:Number = flash.utils.getTimer();
			var delta:Number = CCMath.clamp((currentTime - _lastTime) / 1000, Number.MIN_VALUE, .5);
			_lastTime = currentTime;
			
			engine.update(delta);
		}
		
		public function bootstrap():void
		{
			
		}
	}
}