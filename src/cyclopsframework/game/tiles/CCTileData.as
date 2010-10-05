package cyclopsframework.game.tiles
{
	public class CCTileData implements ICCTileData
	{
		private var _tileIndex:int = 0;
		public function get tileIndex():int { return _tileIndex; }
		public function set tileIndex(value:int):void { _tileIndex = value;	}
		
		private var _data:Object;
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		
		public function CCTileData(tileIndex:int=0)
		{
			_tileIndex = tileIndex;
		}
		
		
		
		
	}
}