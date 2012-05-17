package org.cyclopsframework.utils.collections
{
	import org.cyclopsframework.utils.math.CFMath;

	public dynamic class CFArray extends Array
	{
		public function CFArray(source:Array=null)
		{
			super();
			
			if (source != null)
			{
				push.apply(this, source);
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
			return (length > 0) ? this[int(CFMath.random() * length)] : null;
		}
		
		public function shuffled():CFArray
		{
			var src:Array = slice(0);
			var result:CFArray = new CFArray();
			for (var i:int = 0; i < length; ++i)
			{
				result[i] = src.splice(int(CFMath.random() * src.length), 1)[0];
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
				result.push(src.splice(0, minSize + int(CFMath.random() * range)));
			}
			return result;
		}
		
		public function remapToIndices(indices:Array):CFArray
		{
			var result:CFArray = new CFArray();
			
			for (var i:int = 0; i < indices.length; ++i)
			{
				result.push(this[indices[i]]);
			}
			
			return result;
		}
		
		public static function arraysToKeyValuePairs(keys:Array, values:Array):Object
		{
			var result:Object = {};
			for (var i:int = 0; i < keys.length; ++i)
			{
				result[keys[i]] = values[i];
			}
			return result;
		}		
	}
}