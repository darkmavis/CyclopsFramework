package org.cyclopsframework.utils.collections
{
	public class CFList
	{
		private var _head:CFListNode = null;
		public function get head():CFListNode { return _head; }
		
		private var _tail:CFListNode = null;
		public function get tail():CFListNode { return _tail; }
		
		public function CFList()
		{
			
		}
		
		public function push(data:Object):void
		{
			//trace("push: " + data);
			if (_tail == null)
			{
				_head = new CFListNode(data);
				_tail = _head;
			}
			else
			{
				var node:CFListNode = new CFListNode(data);
				
				_tail.next = node;
				_tail = node;
			}
		}
		/*
		public function shift():Object
		{
			//trace("shift");
			if (_head != null)
			{
				var tmp:CFListNode = _head;
				_head = _head.next;
				return tmp;
			}
			else
			{
				return null;
			}
		}
		
		public function unshift(data:Object):void
		{
			//trace("unshift");
			if (_head == null)
			{
				push(data);
			}
			else
			{
				var node:CFListNode = new CFListNode(data);
				
				node.next = _head;
				_head = node;
			}
		}
		*/
		public function walk(f:Function):void
		{
			if (_head == null) return;
			
			var cursor:CFListNode = _head;
			
			do
			{
				f(cursor.data);
				cursor = cursor.next;
			} while (cursor != null);
		}
		
		private function walkNodes(f:Function):void
		{
			if (_head == null) return;
			
			var cursor:CFListNode = _head;
			
			do
			{
				f(cursor);
				cursor = cursor.next;
			} while (cursor != null);
		}
		
		public function filter(f:Function):void
		{
			var last:CFListNode = null;
			
			walkNodes(function(node:CFListNode):void
			{
				if (!f(node.data))
				{		
					if (last != null)
					{
						last.next = node.next;
					}
					else
					{
						_head = node.next;
					}
				}
				else
				{
					last = node;
				}
			});
		}
		
	}
}