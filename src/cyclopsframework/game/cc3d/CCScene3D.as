package cyclopsframework.game.cc3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.clip.FrustumClipping;
	import away3d.core.render.QuadrantRenderer;
	
	import cyclopsframework.game.CCScene;
	
	public class CCScene3D extends CCScene
	{
		private var _scene3d:Scene3D;
		public function get scene3d():Scene3D { return _scene3d; }
		
		private var _camera:Camera3D;
		public function get camera():Camera3D { return _camera; }
		public function set camera(value:Camera3D):void { _camera = value; }
				
		private var _view:View3D;
		public function get view():View3D { return _view; }
		public function set view(value:View3D):void { _view = value; }
		
		public function CCScene3D()
		{
			super();
			
			_scene3d = new Scene3D();
			_camera = new Camera3D();
			_view = new View3D();
						
			_view.camera = _camera;
			_view.scene = _scene3d;
			
			view.renderer = new QuadrantRenderer();
			view.clipping = new FrustumClipping();
			
			engine.runNextFrame(function():void
			{
				//center view to root
				view.x = 400;//bg.root.width / 2;
				view.y = 300;//bg.root.height / 2;
				
				//add view to the displaylist
				bg.addChild(view);
			});	
			
			// render each frame
			engine.loop(view.render).addTag("view.render");
		}
		
	}
}