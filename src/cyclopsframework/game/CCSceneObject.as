package cyclopsframework.game
{
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.CCTaggable;
	import cyclopsframework.core.ICCHasEngine;
	
	public class CCSceneObject extends CCTaggable
	{
		public static const TAG:String = "@CCSceneObject";
		
		protected function get scene():CCScene { return CCScene.sceneContext; }
		protected function get engine():CCEngine { return scene.engine; }
		
		public function CCSceneObject(...tags)
		{
			super(TAG);
			this.tags.addItems(tags);
		}
	}
}