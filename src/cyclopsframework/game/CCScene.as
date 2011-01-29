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
	import cyclopsframework.actions.audio.CCDynamicSound;
	import cyclopsframework.actions.audio.CCSound;
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCDisposable;
	import cyclopsframework.core.ICCMessageInterceptor;
	import cyclopsframework.core.ICCPausable;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.game.bindings.CCKeyboardBindings;
	import cyclopsframework.utils.collections.CCDataStore;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.proxies.CCDataStoreProxy;
	import cyclopsframework.utils.proxies.CCFunctionProxy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.utils.getTimer;
	
	import r1.deval.D;
	
	public class CCScene implements ICCDisposable, ICCTaggable, IEventDispatcher
	{
		public static const TAG:String = "@CCScene";
		
		public static const TAG_KEYBOARD_INPUT:String = "@CCSceneKeyboardInput";
		public static const TAG_KEY_DOWN:String = "@CCSceneKeyDown";
		public static const TAG_KEY_UP:String = "@CCSceneKeyUp";
		
		public static const EVENT_SCENE_READY:String = "ready";
		
		private var _dispatcher:EventDispatcher;
		private var _manualStart:Boolean = false;
		private var _lastTime:Number = flash.utils.getTimer();
		
		private var _stageReady:Boolean = false;
		
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
		public function get children():Vector.<CCScene> { return _children; }
		
		private var _onKeyDownListener:Function;
		public function get onKeyDownListener():Function { return _onKeyDownListener; }
		public function set onKeyDownListener(value:Function):void { _onKeyDownListener = value; }
		
		private var _onKeyUpListener:Function;
		public function get onKeyUpListener():Function { return _onKeyUpListener; }
		public function set onKeyUpListener(value:Function):void { _onKeyUpListener = value; }
		
		private var _bindings:CCKeyboardBindings = new CCKeyboardBindings();
		public function get bindings():CCKeyboardBindings { return _bindings; }
		
		private var _keyboardEnabled:Boolean = true;
		public function get keyboardEnabled():Boolean { return _keyboardEnabled; }
		public function set keyboardEnabled(value:Boolean):void
		{
			_keyboardEnabled = value;
			if (keyboardEnabled == false)
			{
				engine.pause(TAG_KEYBOARD_INPUT);
			}
			else
			{
				engine.resume(TAG_KEYBOARD_INPUT);
			}
		}
		
		private static var _sceneContext:CCScene;
		public static function get sceneContext():CCScene { return _sceneContext; }
		
		public function get self():CCScene { return this; }
		
		public function CCScene(...tags)
		{
			super();
			this.tags.addItem(TAG);
			if (tags != null)
			{
				this.tags.addItems(tags);
			}
			engine.runNextFrame(onEnter);
			
			_dispatcher = new EventDispatcher(this);
			
			engine.runNextFrame(function():void
			{
				dispatchEvent(new Event(EVENT_SCENE_READY));
			});
			
			bg.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			bg.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_DOWN, Number.MAX_VALUE, Number.MAX_VALUE, onKeyDown).addTags([TAG_KEYBOARD_INPUT, TAG_KEY_DOWN]);
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_UP, Number.MAX_VALUE, Number.MAX_VALUE, onKeyUp).addTags([TAG_KEYBOARD_INPUT, TAG_KEY_UP]);
			_stageReady = true;
		}
		
		public function manualStart(container:DisplayObjectContainer):void
		{
			_manualStart = true;
			container.addChild(bg);
			container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (!_stageReady) return;
			
			var currentTime:Number = flash.utils.getTimer();
			var delta:Number = CCMath.clamp((currentTime - _lastTime) / 1000, Number.MIN_VALUE, .5);
			_lastTime = currentTime;
			update(delta);
		}
		
		public function addScene(scene:CCScene):void
		{
			scene.parent = this;
			bg.addChild(scene.bg);
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
		
		public function removeFromParent():void
		{
			parent.removeScene(this);
		}
		
		public function getSceneByTag(tag:String):CCScene
		{
			return engine.query(tag).first() as CCScene;
		}
		
		public function addDisplayObject(displayObject:DisplayObject, x:Number=0, y:Number=0):DisplayObject
		{
			displayObject.x = x;
			displayObject.y = y;
			bg.addChild(displayObject);
			return displayObject;
		}
		
		public function playSound(source:Sound, cycles:int=1, pan:Number=0, volume:Number=1, channelTag:String=null):CCSound
		{
			if (channelTag == null)
			{
				return engine.add(new CCSound(source, cycles, pan, volume)) as CCSound;
			}
			else if (engine.count(channelTag) == 0)
			{
				return engine.add(channelTag, new CCSound(source, cycles, pan, volume)) as CCSound;
			}
			else
			{
				return null;
			}
		}
		
		public function playDynamicSound(source:Sound, speed:Number=1, pan:Number=0, volume:Number=1, channelTag:String=null):CCDynamicSound
		{
			if (channelTag == null)
			{
				return engine.add(new CCDynamicSound(source, speed, pan, volume)) as CCDynamicSound;
			}
			else if (engine.count(channelTag) == 0)
			{
				return engine.add(channelTag, new CCDynamicSound(source, speed, pan, volume)) as CCDynamicSound;
			}
			else
			{
				return null;
			}
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
			_sceneContext = this;
			engine.update(delta);			
			for each (var scene:CCScene in children)
			{
				scene.update(delta);
			}
		}
		
		public function $f(expression:String):Function
		{
			return function(o:Object):Boolean
			{
				var container:Object = {"o":o};
				return D.evalToBoolean(expression, container, this);
			}
		}
		
		public function $(...args):CCDataStoreProxy
		{	
			return engine.proxy.apply(null, args);
		}
		
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
		
		public function find(tag:String):Object
		{
			var result:Object = engine.query(tag).first();
			if (result != null) return result;
			
			for each (var scene:CCScene in children)
			{
				result = scene.find(tag);
				if (result != null) return result;
			}
			
			return null;
		}
		
		public function status():String
		{
			var result:String = engine.status();
			result += "\nChild scenes: " + _children.toString() + "\nTotal local display objects: " + bg.numChildren;
			return result;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			_sceneContext = this;
			
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
			_sceneContext = this;
			
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
			_sceneContext = this;
			
			for each (var child:CCScene in children)
			{
				child.dispose();
			}
			engine.proxy(CCEngine.TAG_ALL).stop();
			
			if (bg.parent != null)
			{
				if (_manualStart)
				{
					bg.parent.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				bg.parent.removeChild(bg);
			}
			
		}
						
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
	}
}