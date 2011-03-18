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
		
		public function shuffled():CFArray
		{
			var src:Array = slice(0);
			var result:CFArray = new CFArray();
			for (var i:int = 0; i < length; ++i)
			{
				result[i] = src.splice(int(Math.random() * src.length), 1)[0];
			}
			return result;
		}
		
		public function clustered(minSize:int, maxSize:int):CFArray
		{
			var src:Array = [].concat(this);
			var result:CFArray = new CFArray();
			var range:int = maxSize - minSize;
			while (src.length > 0)
			{
				result.push(src.splice(0, minSize + int(Math.random() * range)));
			}
			return result;
		}
				
	}
}