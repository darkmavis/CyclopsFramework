package org.cyclopsframework.game
{
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.core.CFTaggable;
	import org.cyclopsframework.core.ICFHasEngine;
	
	public class CFSceneObject extends CFTaggable
	{
		public static const TAG:String = "@CFSceneObject";
		
		protected function get scene():CFScene { return CFScene.sceneContext; }
		protected function get engine():CFEngine { return scene.engine; }
		
		public function CFSceneObject(...tags)
		{
			super(TAG);
			this.tags.addItems(tags);
		}
	}
}