package cyclopsframework.utils.collections
{
	public class CCStringHashSet
	{
		private var _table:Object = {};
		public function get items():Object { return _table; }
		
		private var _numItems:int = 0;
		public function get length():int { return _numItems; }
		
		public function CCStringHashSet()
		{
			
		}
		
		public function has(item:String):Boolean
		{
			return _table.hasOwnProperty(item);
		}
		
		public function addItem(item:String):void
		{
			_table[item] = item;
			++_numItems;
		}
		
		public function addItems(items:Array):void
		{
			for each (var item:String in items)
			{
				_table[item] = item;
				++_numItems;
			}
		}
		
		public function removeItem(item:String):void
		{
			if (_table.hasOwnProperty(item))
			{
				delete _table[item];
				--_numItems;
			}
		}
		
		public function removeItems(items:Array):void
		{
			for each (var item:String in items)
			{
				if (_table.hasOwnProperty(item))
				{
					delete _table[item];
					--_numItems;
				}
			}
		}
		
		public function toArray():Array
		{
			var a:Array = [];
			
			for each (var item:String in items)
			{
				a.push(item);
			}
			
			return a;
		}
		
		public function clear():void
		{
			_table = {};
			_numItems = 0;
		}
		
	}
}