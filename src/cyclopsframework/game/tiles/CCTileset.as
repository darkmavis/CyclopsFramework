package cyclopsframework.game.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CCTileset
	{
		private var _atlas:BitmapData;
		public function get atlas():BitmapData { return _atlas; }
		
		private var _tileRect:Rectangle;
				
		public function get tileWidth():int { return _tileRect.width; }
		public function get tileHeight():int { return _tileRect.height; }
		
		private var _destPoint:Point = new Point();
		
		private var _columns:int;
		public function get columns():int { return _columns; }
		
		private var _rows:int;
		public function get rows():int { return _rows; }
		
		public function CCTileset(tileWidth:int, tileHeight:int, source:BitmapData)
		{
			_atlas = source;
			_tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			_columns = source.width / tileWidth;
			_rows = source.height / tileHeight;
		}
		
		public function getTile(index:int):BitmapData
		{			
			_tileRect.x = (index % _columns) * tileWidth;
			_tileRect.y = int(index / _rows) * tileHeight;
			
			_destPoint.x = 0;
			_destPoint.y = 0;
			
			var _result:BitmapData = new BitmapData(tileWidth, tileHeight);
			_result.copyPixels(_atlas, _tileRect, _destPoint);
			
			return _result;
		}
				
		public function getTileRect(index:int, rectOut:Rectangle=null):Rectangle
		{
			if (rectOut == null) rectOut = new Rectangle();
			
			rectOut.x = (index % _columns) * tileWidth;
			rectOut.y = int(index / _rows) * tileHeight;
			rectOut.width = tileWidth;
			rectOut.height = tileHeight;
			
			return rectOut;
		}
	}
}