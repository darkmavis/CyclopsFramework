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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.utils.console.CFConsole;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFGame extends Sprite
	{
		private var _scene:CFScene = new CFScene();
		public function get scene():CFScene { return _scene; }
		
		private var _console:CFConsole;
		public function get console():CFConsole { return _console; }
		
		public function get self():CFGame { return this; }
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; };
		
		private var _centerPoint:Point;
		public function get centerPoint():Point { return _centerPoint; }
		
		private var _lastTime:Number = flash.utils.getTimer();
		
		public function CFGame(gameWidth:Number=800, gameHeight:Number=600, fillBackground:Boolean=false)
		{
			super();
			
			_rect = new Rectangle(0, 0, gameWidth, gameHeight);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onReady);
			if (fillBackground)
			{
				var g:Graphics = _scene.bg.graphics;
				g.beginFill(0);
				g.drawRect(0, 0, _rect.width, _rect.height);
				g.endFill();
			}
		}
		
		private function onReady(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onReady);
			
			this.addChild(scene.bg);
			
			_console = new CFConsole(_rect.width, _rect.height);
			console.scriptingContext["game"] = this;
			this.addChild(console.bg);
			
			console.scriptingContext["find"] = scene.find;
			
			console.importConsoleCommands(this);
			
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
		
		[ConsoleCommand(help="display scene status")]
		public function status():void
		{
			console.println(scene.status());
		}
	}
}