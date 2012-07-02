package org.cyclopsframework.starling.game
{
	import flash.media.Sound;
	import flash.utils.getTimer;
	
	import org.cyclopsframework.actions.animation.CFFadeTo;
	import org.cyclopsframework.actions.audio.CFDynamicSound;
	import org.cyclopsframework.actions.audio.CFSound;
	import org.cyclopsframework.actions.interpolation.CFInterpolate;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.core.CFMessage;
	import org.cyclopsframework.core.CFTaggable;
	import org.cyclopsframework.core.ICFDisposable;
	import org.cyclopsframework.core.ICFMessageInterceptor;
	import org.cyclopsframework.core.ICFPausable;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.core.easing.CFBias;
	import org.cyclopsframework.game.bindings.CFKeyboardBindings;
	import org.cyclopsframework.starling.game.CFSceneObject;
	import org.cyclopsframework.utils.collections.CFDataStore;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	import org.cyclopsframework.utils.proxies.CFDataStoreProxy;
	import org.cyclopsframework.utils.proxies.CFFunctionProxy;
	
	import r1.deval.D;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CFScene implements ICFDisposable, ICFTaggable //, IEventDispatcher
	{
		public static const TAG:String = "@CFScene";
		
		public static const TAG_KEYBOARD_INPUT:String = "@CFSceneKeyboardInput";
		public static const TAG_KEY_DOWN:String = "@CFSceneKeyDown";
		public static const TAG_KEY_UP:String = "@CFSceneKeyUp";
		
		public static const EVENT_SCENE_READY:String = "ready";
		
		private var _dispatcher:EventDispatcher;
		private var _manualStart:Boolean = false;
		private var _lastTime:Number = flash.utils.getTimer();
		
		private var _stageReady:Boolean = false;
		
		private var _tags:CFStringHashSet = new CFStringHashSet();
		public function get tags():CFStringHashSet { return _tags; }
		
		private var _parent:CFScene;
		public function get parent():CFScene { return _parent; }
		public function set parent(value:CFScene):void { _parent = value; }
		
		private var _engine:CFEngine = new CFEngine();
		public function get engine():CFEngine { return _engine; }
		
		private var _bg:Sprite = new Sprite();
		public function get bg():Sprite { return _bg; }
		
		private var _children:Vector.<CFScene> = new Vector.<CFScene>();
		public function get children():Vector.<CFScene> { return _children; }
		
		private var _onKeyDownListener:Function;
		public function get onKeyDownListener():Function { return _onKeyDownListener; }
		public function set onKeyDownListener(value:Function):void { _onKeyDownListener = value; }
		
		private var _onKeyUpListener:Function;
		public function get onKeyUpListener():Function { return _onKeyUpListener; }
		public function set onKeyUpListener(value:Function):void { _onKeyUpListener = value; }
		
		private var _bindings:CFKeyboardBindings = new CFKeyboardBindings();
		public function get bindings():CFKeyboardBindings { return _bindings; }
		
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
		
		private static var _sceneContext:CFScene;
		public static function get sceneContext():CFScene { return _sceneContext; }
		
		public function get self():CFScene { return this; }
		
		private var _ready:Boolean = false;
		public function get ready():Boolean { return _ready; }
		
		public function CFScene(...tags)
		{
			super();
			
			this.tags.addItem(TAG);
			
			if (tags != null)
			{
				this.tags.addItems(tags);
			}
			
			bg.addEventListener(Event.ADDED, onAdded);
			
			engine.runNextFrame(onEnter);
		}
		
		private function onAdded(e:Event):void
		{
			bg.removeEventListener(Event.ADDED, onAdded);
			
			engine.sugar.waitForEvent(Starling.current.stage, KeyboardEvent.KEY_DOWN, Number.MAX_VALUE, Number.MAX_VALUE,
				onKeyDown).addTags([TAG_KEYBOARD_INPUT, TAG_KEY_DOWN]);
			
			engine.sugar.waitForEvent(Starling.current.stage, KeyboardEvent.KEY_UP, Number.MAX_VALUE, Number.MAX_VALUE,
				onKeyUp).addTags([TAG_KEYBOARD_INPUT, TAG_KEY_UP]);
			
			_ready = true;
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
			var delta:Number = CFMath.clamp((currentTime - _lastTime) / 1000, Number.MIN_VALUE, .5);
			
			_lastTime = currentTime;
			
			update(delta);
		}
		
		public function addScene(scene:CFScene):void
		{
			scene.parent = this;
			bg.addChild(scene.bg);
			children.push(scene);
			engine.add(scene);
		}
		
		public function removeScene(scene:CFScene):void
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
		
		public function getSceneByTag(tag:String):CFScene
		{
			return engine.query(tag).first() as CFScene;
		}
		
		public function crossfadeToScene(toScene:CFScene, period:Number=1, bias:Function=null):void
		{
			toScene.bg.alpha = 0;
			
			parent.addScene(toScene);
			
			engine
				.add(new CFFadeTo(toScene.bg, 1, period, 1, bias))
				.add(removeFromParent);
			
			engine.query(CFSound.TAG).forEach(function(sound:CFSound):void
			{
				engine.add(new CFInterpolate(sound, "volume", sound.volume, 0, period, 1, bias));
			});
		}
		
		public function gotoScene(scene:CFScene):void
		{
			var pscene:CFScene = parent;
			
			pscene.removeScene(self);
			pscene.addScene(scene);
		}
		
		public function launchSceneOnClick(scene:CFScene, target:DisplayObject):CFAction
		{
			target.touchable = true;
			
			return (engine.sugar.waitForEvent(target, TouchEvent.TOUCH, Number.MAX_VALUE, 1, function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(target, TouchPhase.BEGAN);
				
				if (touch != null) gotoScene(scene);
			}));
		}
		
		public function doOnClick(target:DisplayObject, f:Function, cycles:Number=1, thisObject:Object=null, ...data):CFAction
		{
			target.touchable = true;
			
			return (engine.sugar.waitForEvent(target, TouchEvent.TOUCH, Number.MAX_VALUE, cycles, function(e:TouchEvent):void
			{
				var touch:Touch = e.getTouch(target, TouchPhase.BEGAN);
				
				if (touch != null)
				{
					f.apply(thisObject, data);
				}
			}));
		}
		
		public function addSceneObject(sceneObject:CFSceneObject):CFSceneObject
		{
			sceneObject.scene = this;
			engine.add(sceneObject);
			
			return sceneObject;
		}
		
		public function addDisplayObject(displayObject:DisplayObject, x:Number=0, y:Number=0):DisplayObject
		{
			displayObject.x = x;
			displayObject.y = y;
			
			bg.addChild(displayObject);
			
			return displayObject;
		}
		
		public function playSound(source:Sound, cycles:int=1, pan:Number=0, volume:Number=1, channelTag:String=null):CFSound
		{
			if (channelTag == null)
			{
				return engine.add(new CFSound(source, cycles, pan, volume)) as CFSound;
			}
			else if (engine.count(channelTag) == 0)
			{
				return engine.add(channelTag, new CFSound(source, cycles, pan, volume)) as CFSound;
			}
			else
			{
				return null;
			}
		}
		
		public function playDynamicSound(source:Sound, speed:Number=1, pan:Number=0, volume:Number=1, channelTag:String=null):CFDynamicSound
		{
			if (channelTag == null)
			{
				return engine.add(new CFDynamicSound(source, speed, pan, volume)) as CFDynamicSound;
			}
			else if (engine.count(channelTag) == 0)
			{
				return engine.add(channelTag, new CFDynamicSound(source, speed, pan, volume)) as CFDynamicSound;
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
			for each (var scene:CFScene in children)
			{
				scene.update(delta);
			}
		}
		
		public function $(...args):Object // :CFDataStoreProxy
		{	
			return engine.proxy.apply(null, args);
		}
		
		public function sendByProxy(tag:String=CFEngine.TAG_ALL, sender:Object=null, receiverType:Class=null):Object // :CFFunctionProxy
		{
			return new CFFunctionProxy(function(name:String, args:Array):void
			{
				engine.send(tag, name, args, sender, receiverType);
				
				for each (var scene:CFScene in children)
				{
					scene.send(tag, name, args, sender, receiverType);
				}
			});
		}
		
		public function send(tag:String, name:String, args:Array=null, sender:Object=null, receiverType:Class=null):void
		{
			engine.send(tag, name, args, sender, receiverType);
			
			for each (var scene:CFScene in children)
			{
				scene.send(tag, name, args, sender, receiverType);
			}
		}
		
		public function sendMessage(msg:CFMessage):void
		{
			engine.sendMessage(msg);
			
			for each (var scene:CFScene in children)
			{
				scene.sendMessage(msg);
			}
		}
		
		public function find(tag:String):Object
		{
			var result:Object = engine.query(tag).first();
			
			if (result != null) return result;
			
			for each (var scene:CFScene in children)
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
		
		protected function log(text:String, channel:String=CFLog.CHANNEL_DEFAULT):void
		{
			CFLog.println(text, channel);
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
			
			for each (var child:CFScene in children)
			{
				child.dispose();
			}
			
			(engine.proxy(CFEngine.TAG_ALL, function(o:Object):Boolean { return (o.hasOwnProperty("stop")); }) as Object).stop();
			
			if (bg.parent != null)
			{
				if (_manualStart)
				{
					bg.parent.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				
				bg.parent.removeChild(bg);
			}
			
		}
	}
}