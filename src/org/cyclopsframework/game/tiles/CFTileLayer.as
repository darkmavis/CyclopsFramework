/**
 * Cyclops Framework
 * 
 * Copyright 2010 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyclopsframework.game.tiles
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.actions.flow.CFSleep;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFTileLayer
	{
		private var _tileset:CFTileset;
		public function get tileset():CFTileset { return _tileset; }
		public function set tileset(value:CFTileset):void { _tileset = value; }
				
		private var _columns:int;
		public function get columns():int { return _columns; }
		
		private var _rows:int;
		public function get rows():int { return _rows; }
		
		private var _transparentTileIndex:int = 0;
		public function get transparentTileIndex():int { return _transparentTileIndex; }
		public function set transparentTileIndex(value:int):void { _transparentTileIndex = value; }
				
		private var _tileGrid:Vector.<ICFTileData>;
				
		public function CFTileLayer(columns:int, rows:int, tileset:CFTileset)
		{
			_columns = columns;
			_rows = rows;
			_tileGrid = new Vector.<ICFTileData>();
			_tileset = tileset;
			
			for (var i:int = 0; i < (columns * rows); ++i)
			{
				_tileGrid.push(new CFTileData());
			}
		}
		
		public function getTile(x:int, y:int):ICFTileData
		{
			return _tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)];
		}
		
		public function setTile(x:int, y:int, data:ICFTileData):void
		{
			_tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)] = data;
		}
				
		public function forEachTile(f:Function):void
		{
			for (var y:int = 0; y < _rows; ++y)
			{
				for (var x:int = 0; x < _columns; ++x)
				{
					f(x, y, _tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)]);
				}
			}
		}
		
		public function yieldTiles(f:Function):Array
		{
			var result:Array = [];
			for (var y:int = 0; y < _rows; ++y)
			{
				for (var x:int = 0; x < _columns; ++x)
				{
					result.push(new CFFunction(0, 1, this, [x, y], function(x:int, y:int):void
					{
						f(x, y, _tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)]);	
					}));
				}
			}
			return result;
		}
		
		public function yieldTilesByRow(f:Function):Array
		{
			var result:Array = [];
			for (var y:int = 0; y < _rows; ++y)
			{
				result.push(new CFFunction(0, 1, this, [y], function(y:int):void
				{
					for (var x:int = 0; x < _columns; ++x)
					{
						f(x, y, _tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)]);	
					}
				}));
			}
			return result;
		}
		
		public function yieldTilesByColumn(f:Function):Array
		{
			var result:Array = [];
			for (var x:int = 0; x < _columns; ++x)
			{
				result.push(new CFFunction(0, 1, this, [x], function(x:int):void
				{
					for (var y:int = 0; y < _rows; ++y)
					{
						f(x, y, _tileGrid[CFMath.wrap(y, _rows) * _columns + CFMath.wrap(x, _columns)]);	
					}
				}));
			}
			return result;
		}
				
		public function drawView(viewRect:Rectangle, target:BitmapData=null):BitmapData
		{
			if (target == null)
			{
				target = new BitmapData(viewRect.width * tileset.tileWidth, viewRect.height * tileset.tileHeight, true, 0);
			}
			
			var srect:Rectangle = new Rectangle();
			var p:Point = new Point();
			
			var vx:int = int(viewRect.x);
			var vy:int = int(viewRect.y);
			var vw:int = int(viewRect.width);
			var vh:int = int(viewRect.height);
			
			var tw:Number = tileset.tileWidth;
			var th:Number = tileset.tileHeight;
			
			for (var y:int = 0; y < vh; ++y)
			{
				p.y = int((y - (viewRect.y % 1)) * th);
				for (var x:int = 0; x < vw; ++x)
				{
					var tileIndex:int = getTile(vx + x, vy + y).tileIndex;
					if (tileIndex != _transparentTileIndex)
					{
						p.x = int((x - (viewRect.x % 1)) * tw);
						srect = tileset.getTileRect(tileIndex, srect);
						target.copyPixels(tileset.atlas, srect, p, null, null, true);
					}
				}
			}
			
			return target;
		}
		
		/*
		public static function fromTMX(tileset:CFTileset):void
		{
			
		}
		*/
		
	}
}