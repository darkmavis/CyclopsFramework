package cyclopsframework.utils.collections
{
	public dynamic class CCArray extends Array
	{
		public function CCArray(...parameters)
		{
			super(parameters);
		}
		
		public function get first():Object
		{
			return (length > 0) ? this[0] : null;
		}
		
		public function get last():Object
		{
			return (length > 0) ? this[length - 1] : null;
		}
				
	}
}