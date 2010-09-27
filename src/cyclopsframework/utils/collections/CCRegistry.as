package cyclopsframework.utils.collections
{
	import flash.utils.Dictionary;

	public class CCRegistry
	{
		private var _table:Object = {};
		
		public function CCRegistry()
		{
		}
		
		public function addObject(key:String, value:Object):void
		{
			if (!_table.hasOwnProperty(key))
			{
				//_table[key] = new Dictionary();
				_table[key] = new CCDataStore();
			}
			
			//(_table[key] as Dictionary)[value] = value;
			(_table[key] as CCDataStore).add(value);
			
			//trace("adding " + key + ":" + value + " to registry.");
		}
		
		public function removeObject(key:String, value:Object):void
		{
			if (_table.hasOwnProperty(key))
			{
				//delete (_table[key] as Dictionary)[value];
				(_table[key] as CCDataStore).remove(value);
			}
		}
		
		//public function getObjects(key:String):Dictionary
		public function getObjects(key:String):CCDataStore
		{
			if (_table.hasOwnProperty(key))
			{
				//return _table[key];
				return _table[key] as CCDataStore;
			}
			else
			{
				//return new Dictionary();
				return new CCDataStore();
			}
		}
		
		public function removeKey(key:String):void
		{
			delete _table[key];
		}
		
		public function has(key:String):Boolean
		{
			return _table.hasOwnProperty(key);
		}
		
		// optimize this later
		public function count(key:String):int
		{
			var n:int = 0;
			
			if (_table.hasOwnProperty(key))
			{
				/*
				for each (var o:Object in _table[key])
				{
					n++;
				}
				*/
				n = (_table[key] as CCDataStore).numItems;
			}
			
			return n;
		}
		
		public function toString():String
		{
			var result:String = "";
			
			for each (var key:String in _table)
			{
				result += key + "\n";
			}
			
			return result;
		}
				
	}
}