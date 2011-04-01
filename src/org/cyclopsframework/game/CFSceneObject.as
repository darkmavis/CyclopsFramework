package org.cyclopsframework.game
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.core.CFEvent;
	import org.cyclopsframework.core.CFTaggable;
	import org.cyclopsframework.core.ICFHasEngine;
	
	public class CFSceneObject extends CFTaggable implements IEventDispatcher
	{
		public static const TAG:String = "@CFSceneObject";
		
		private var _dispatcher:EventDispatcher;
		
		private var _scene:CFScene = null;
		protected function get scene():CFScene
		{
			if (_scene == null) throw new Error("CFSceneObject hasn't been registered with a CFScene.");
			return _scene;
		}
		
		protected function get engine():CFEngine { return _scene.engine; }
		
		public function CFSceneObject(...tags)
		{
			super(TAG);
			this.tags.addItems(tags);
			_dispatcher = new EventDispatcher(this);
			
			this.addEventListener(CFEvent.OBJECT_REGISTERED, onObjectRegistered);
			
		}
		
		private function onObjectRegistered(e:Event):void
		{
			_scene = CFScene.sceneContext;
			onRegistered();
		}
		
		protected function onRegistered():void
		{
			
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