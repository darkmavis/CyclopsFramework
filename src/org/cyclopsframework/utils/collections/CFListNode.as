package org.cyclopsframework.utils.collections
{
	public class CFListNode
	{
		public var data:Object = null;
		public var next:CFListNode = null;
		
		public function CFListNode(data:Object)
		{
			this.data = data;
		}
	}
}