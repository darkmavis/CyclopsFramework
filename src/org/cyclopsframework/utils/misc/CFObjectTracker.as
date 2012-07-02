package org.cyclopsframework.utils.misc
{
	import org.cyclopsframework.core.CFTaggable;
	
	public class CFObjectTracker extends CFTaggable
	{
		public static const TAG:String = "CFObjectTracker";
		
		private var _object:Object;
		public function get object():Object { return _object; }
		
		public function CFObjectTracker(object:Object, tags:Array)
		{
			super(TAG);
			
			_object = object;
			this.tags.addItems(tags);
		}
	}
}