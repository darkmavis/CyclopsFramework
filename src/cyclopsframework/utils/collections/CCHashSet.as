package cyclopsframework.utils.collections
{
	import flash.utils.Dictionary;

	public class CCHashSet
	{
		private var _table:Dictionary = new Dictionary();
		public function get items():Object { return _table; }
		
		private var _numItems:int = 0;
		public function get length():int { return _numItems; }
		
		public function CCHashSet()
		{
			
		}
				
		public function add(item:Object):void
		{
			_table[item] = item;
			++_numItems;
		}
		
		public function remove(item:Object):void
		{
			if (_table.hasOwnProperty(item))
			{
				delete _table[item];
				--_numItems;
			}
		}
		
		public function has(item:Object):Boolean
		{
			return _table.hasOwnProperty(item);
		}
		
		public function forEach(f:Function):void 
		{
			for each (var item:Object in _table)
			{
				f(item);
			}
		}
		
		public function toArray():Array
		{
			var a:Array = [];
			
			for each (var item:Object in items)
			{
				a.push(item);
			}
			
			return a;
		}
		
		public function clear():void
		{
			_table = new Dictionary();
			_numItems = 0;
		}
	}
}