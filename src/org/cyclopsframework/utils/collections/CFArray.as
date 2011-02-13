package org.cyclopsframework.utils.collections
{
	public dynamic class CFArray extends Array
	{
		public function CFArray(source:Array=null)
		{
			super();
			
			if (source != null)
			{
				splice.apply(this, source);
			}
		}
				
		public function get first():Object
		{
			return (length > 0) ? this[0] : null;
		}
		
		public function get last():Object
		{
			return (length > 0) ? this[length - 1] : null;
		}
		
		public function get random():Object
		{
			return (length > 0) ? this[int(Math.random() * length)] : null;
		}
				
	}
}