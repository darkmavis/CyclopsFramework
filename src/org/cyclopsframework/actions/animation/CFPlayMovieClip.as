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
	
	public class CFPlayMovieClip extends CFAction
	{
		public static const TAG:String = "@CFPlayMovieClip";
		
		public static const EVENT_ANIMATION_FINISHED:String = "ANIMATION_FINISHED";
		
		private var _mc:MovieClip;
		private var _stopEvents:Array = [EVENT_ANIMATION_FINISHED];
		private var _startingFrame:Object;
		
		public function CFPlayMovieClip(mc:MovieClip, startingFrame:Object=null, ...stopEvents)
		{
			super(0, Number.MAX_VALUE, null, [TAG]);
			_mc = mc;
			_startingFrame = startingFrame;
			if (stopEvents.length > 0)
			{
				_stopEvents = _stopEvents.concat(stopEvents);
			}
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
			_mc.gotoAndPlay(_startingFrame);
		}
		
		protected override function onExit():void
		{
			engine.remove(uniqueTag);
		}
		
	}
}