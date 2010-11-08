package cyclopsframework.core
{
	import cyclopsframework.utils.collections.CCStringHashSet;
	
	public class CCTaggable implements ICCTaggable
	{
		private var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
		public function CCTaggable(...tags)
		{
			_tags.addItems(tags);
		}
		
	}
}