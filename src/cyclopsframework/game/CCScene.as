package cyclopsframework.game
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.CCMessage;
	import cyclopsframework.core.ICCDisposable;
	import cyclopsframework.core.ICCMessageInterceptor;
	import cyclopsframework.core.ICCPausable;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.proxies.CCDataStoreProxy;
	import cyclopsframework.utils.proxies.CCFunctionProxy;
	
	import flash.display.Sprite;
	
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
				
		public function CCScene()
		{
			super();
			tags.addItem(TAG);
			onEnter();
		}
				
		public function addScene(scene:CCScene):void
		{
			bg.addChild(scene.bg);
			scene.parent = this;
			children.push(scene);
			engine.addObject(scene);
		}
		
		public function removeScene(scene:CCScene):void
		{
			bg.removeChild(scene.bg);
			scene.parent = null;
			children.splice(children.indexOf(scene), 1);
			engine.removeObject(scene);
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
		
		public function onEnter():void { }
		
		public function dispose():void { }
		
	}
}