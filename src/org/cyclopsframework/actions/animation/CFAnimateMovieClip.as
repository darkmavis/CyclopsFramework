package org.cyclopsframework.actions.animation
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.easing.CFBias;

	public class CFAnimateMovieClip extends CFAction
	{
		public static const TAG:String = "@CFAnimateMovieClip";
		
		public static const EVENT_ANIMATION_FINISHED:String = "ANIMATION_FINISHED";
		
		private var _mc:MovieClip;
		private var _stopEvents:Array = [EVENT_ANIMATION_FINISHED];
		
		public function CFAnimateMovieClip(mc:MovieClip, fps:Number=24)
		{
			super(1 / fps, Number.MAX_VALUE, CFBias.LINEAR, [TAG]);
			_mc = mc;
		}
		
		protected override function onEnter():void
		{
			var self:CFAnimateMovieClip = this;
			for each (var name:String in _stopEvents)
			{
				engine.waitForEvent(_mc, name, Number.MAX_VALUE, Number.MAX_VALUE, function(e:Event):void
				{
					self.stop();
				});
			}
		}
				
		protected override function onLastFrame():void
		{
			//_mc.gotoAndStop((_mc.currentFrame + 1) % _mc.currentScene.numFrames);
			_mc.nextFrame();
			_mc.stop();
		}
		
		public function addStopEvent(name:String):CFAnimateMovieClip
		{
			_stopEvents.push(name);
			return this;
		}
		
		public function setStartingFrame(frame:Object):CFAnimateMovieClip
		{
			_mc.gotoAndStop(frame);
			return this;
		}
		
	}
}