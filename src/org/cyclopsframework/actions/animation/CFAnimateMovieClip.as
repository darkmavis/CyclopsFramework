/**
 * Cyclops Framework
 * 
 * Copyright 2011 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
		
		public function CFAnimateMovieClip(mc:MovieClip, fps:Number=30)
		{
			super(1 / fps, Number.MAX_VALUE, null, [TAG]);
			_mc = mc;
		}
		
		protected override function onEnter():void
		{
			for each (var name:String in _stopEvents)
			{
				engine.sugar.waitForEvent(_mc, name, Number.MAX_VALUE, Number.MAX_VALUE, function(e:Event):void
				{
					stop();
				}).addTag(uniqueTag);
			}
		}
						
		protected override function onLastFrame():void
		{
			_mc.nextFrame();
			_mc.stop();
		}
		
		protected override function onExit():void
		{
			engine.remove(uniqueTag);
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