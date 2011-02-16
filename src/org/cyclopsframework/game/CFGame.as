/**
 * Cyclops Framework
 * 
 * Copyright 2010 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
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

package org.cyclopsframework.game
{
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.utils.console.CFConsole;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.math.CFMath;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;
	
	public class CFGame extends Sprite
	{
		private var _scene:CFScene = new CFScene();
		public function get scene():CFScene { return _scene; }
		
		private var _console:CFConsole;
		public function get console():CFConsole { return _console; }
		
		public function get self():CFGame { return this; }
		
		private var _width:Number;
		private var _height:Number;
		
		private var _lastTime:Number = flash.utils.getTimer();
		
		public function CFGame(width:Number=800, height:Number=600, fillBackground:Boolean=false)
		{
			super();
			_width = width;
			_height = height;
			this.addEventListener(Event.ADDED_TO_STAGE, onReady);
			if (fillBackground)
			{
				var g:Graphics = _scene.bg.graphics;
				g.beginFill(0);
				g.drawRect(0, 0, width, height);
				g.endFill();
			}
		}
		
		private function onReady(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onReady);
			
			this.addChild(scene.bg);
			
			_console = new CFConsole(_width, _height);
			console.scriptingContext["game"] = this;
			this.addChild(console.bg);
			
			console.scriptingContext["find"] = scene.find;
			
			CFLog.logger = console;
			
			bootstrap();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var currentTime:Number = flash.utils.getTimer();
			var delta:Number = CFMath.clamp((currentTime - _lastTime) / 1000, Number.MIN_VALUE, .5);
			_lastTime = currentTime;
			
			scene.update(delta);
			console.update(delta);
		}
		
		protected function bootstrap():void
		{
			console.println("Override bootstrap in CFGame to begin writing your game.");
		}
	}
}