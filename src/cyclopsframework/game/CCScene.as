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

package cyclopsframework.game
{
	import cyclopsframework.actions.audio.CCSound;
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCDisposable;
	import cyclopsframework.core.ICCMessageInterceptor;
	import cyclopsframework.core.ICCPausable;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.game.bindings.CCKeyboardBindings;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.proxies.CCDataStoreProxy;
	import cyclopsframework.utils.proxies.CCFunctionProxy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	
	public class CCScene implements ICCDisposable, ICCTaggable
	{
		public static const TAG:String = "@CCScene";
		
		private var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
		private var _parent:CCScene;
		public function get parent():CCScene { return _parent; }
		public function set parent(value:CCScene):void { _parent = value; }
		
		private var _engine:CCEngine = new CCEngine();
		public function get engine():CCEngine { return _engine; }
		
		private var _bg:Sprite = new Sprite();
		public function get bg():Sprite { return _bg; }
		
		private var _children:Vector.<CCScene> = new Vector.<CCScene>();
		private function get children():Vector.<CCScene> { return _children; }
		
		private var _onKeyDownListener:Function;
		public function get onKeyDownListener():Function { return _onKeyDownListener; }
		public function set onKeyDownListener(value:Function):void { _onKeyDownListener = value; }
		
		private var _onKeyUpListener:Function;
		public function get onKeyUpListener():Function { return _onKeyUpListener; }
		public function set onKeyUpListener(value:Function):void { _onKeyUpListener = value; }
		
		private var _bindings:CCKeyboardBindings = new CCKeyboardBindings();
		public function get bindings():CCKeyboardBindings { return _bindings; }
		
		public function CCScene()
		{
			super();
			tags.addItem(TAG);
			engine.runNextFrame(onEnter);
			bg.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			bg.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_DOWN, Number.MAX_VALUE, Number.MAX_VALUE, onKeyDown).addTag("key_down");
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_UP, Number.MAX_VALUE, Number.MAX_VALUE, onKeyUp).addTag("key_up");	
		}
				
		public function addScene(scene:CCScene):void
		{
			bg.addChild(scene.bg);
			scene.parent = this;
			children.push(scene);
			engine.add(scene);
		}
		
		public function removeScene(scene:CCScene):void
		{
			engine.removeObject(scene);
			bg.removeChild(scene.bg);
			scene.parent = null;
			children.splice(children.indexOf(scene), 1);
		}
		
		public function addDisplayObject(displayObject:DisplayObject, x:Number=0, y:Number=0):DisplayObject
		{
			displayObject.x = x;
			displayObject.y = y;
			bg.addChild(displayObject);
			return displayObject;
		}
		
		public function playSound(source:Sound, speed:Number=1, pan:Number=0, volume:Number=1):CCSound
		{
			return engine.add(new CCSound(source, speed, pan, volume)) as CCSound;
		}
		
		public function addSprite(sprite:Sprite, x:Number=0, y:Number=0):Sprite
		{
			sprite.x = x;
			sprite.y = y;
			bg.addChild(sprite);
			return sprite;
		}
		
		public function update(delta:Number):void
		{
			engine.update(delta);			
			for each (var scene:CCScene in children)
			{
				scene.update(delta);
			}
		}
		
		/*
		public function proxy(tag:String=CCEngine.TAG_ALL):CCFunctionProxy
		{
			return new CCFunctionProxy(function(name:String, args:Array):void
			{
				(engine.proxy(tag)[name] as Function).apply(null, args)
				for each (var scene:CCScene in children)
				{
					(scene.proxy(tag)[name] as Function).apply(null, args);
				}
			});
		}
		*/
		
		public function sendByProxy(tag:String=CCEngine.TAG_ALL, sender:Object=null, receiverType:Class=null):CCFunctionProxy
		{
			return new CCFunctionProxy(function(name:String, args:Array):void
			{
				engine.send(tag, name, args, sender, receiverType);
				for each (var scene:CCScene in children)
				{
					scene.send(tag, name, args, sender, receiverType);
				}
			});
		}
		
		public function send(tag:String, name:String, args:Array=null, sender:Object=null, receiverType:Class=null):void
		{
			engine.send(tag, name, args, sender, receiverType);
			for each (var scene:CCScene in children)
			{
				scene.send(tag, name, args, sender, receiverType);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (onKeyDownListener != null)
			{
				onKeyDownListener(e);
			}
			
			var f:Function = bindings.keyDown.getBoundFunction(e.keyCode);
			if (f != null)
			{
				f();
			}
			else
			{
				f = bindings.keyDown.getBoundFunction(e.charCode);
				if (f != null)
				{
					f();
				}
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (onKeyUpListener != null)
			{
				onKeyUpListener(e);
			}
			
			var f:Function = bindings.keyUp.getBoundFunction(e.keyCode);
			if (f != null)
			{
				f();
			}
			else
			{
				f = bindings.keyUp.getBoundFunction(e.charCode);
				if (f != null)
				{
					f();
				}
			}
		}
		
		protected function onEnter():void { }
				
		public function dispose():void
		{
			for each (var child:CCScene in children)
			{
				child.dispose();
			}
			engine.proxy(CCEngine.TAG_ALL).stop();
		}
		
	}
}