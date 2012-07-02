package org.cyclopsframework.starling.tiles
{
	import org.cyclopsframework.utils.math.CFMath;

	public class CFBoundedTileDataSource implements ICFTileDataSource
	{
		private var _numColumns:int;
		public function get numColumns():int { return _numColumns; }
		
		private var _numRows:int;
		public function get numRows():int { return _numRows; }
		
		private var _grid:Vector.<int>;
		
		public function CFBoundedTileDataSource(numColumns:int, numRows:int)
		{
			_numColumns = numColumns;
			_numRows = numRows;
			_grid = new Vector.<int>(numColumns * numRows);
		}
		
		public function readTileIndex(x:int, y:int):int
		{
			var px:int = CFMath.wrap(x, _numColumns);
			var py:int = CFMath.wrap(y, _numRows);
			
			return _grid[py * _numColumns + px];
		}
		
		public function writeTileIndex(x:int, y:int, tileIndex:int):void
		{
			var px:int = CFMath.wrap(x, _numColumns);
			var py:int = CFMath.wrap(y, _numRows);
			
			_grid[py * _numColumns + px] = tileIndex;
		}
		
	}
}