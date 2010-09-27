package cyclopsframework.utils.collections
{
	public class CCDataStoreRemoteItem
	{
		private var _source:Function;
		public function get value():Object { return _source(); }
		
		public function CCDataStoreRemoteItem(source:Function)
		{
			_source = source;
		}
		
	}
}