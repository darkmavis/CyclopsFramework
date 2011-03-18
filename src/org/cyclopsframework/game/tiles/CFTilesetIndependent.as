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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CFTilesetIndependent implements ICFTileset
	{
		private var _tiles:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		private var _tileRect:Rectangle;
		
		public function get tileWidth():int { return _tileRect.width; }
		public function get tileHeight():int { return _tileRect.height; }
		
		private var _destPoint:Point = new Point();
		
		public function get numTiles():int { return _tiles.length; }
		
		public function CFTilesetIndependent(tileWidth:int, tileHeight:int)
		{
			_tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
		}
		
		public function addTile(data:BitmapData):void
		{
			_tiles.push(data);
		}
		
		public function getTile(index:int):BitmapData
		{
			return _tiles[index];
		}
				
	}
}