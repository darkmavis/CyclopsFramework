package org.cyclopsframework.starling.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	public class CFTileAtlas
	{
		private var _tileWidth:int = 0;
		public function get tileWidth():int { return _tileWidth; }
		
		private var _tileHeight:int = 0;
		public function get tileHeight():int { return _tileHeight; }
		
		private var _tilePositions:Vector.<Point> = new Vector.<Point>();
		public function get tilePositions():Vector.<Point> { return _tilePositions; }
		
		private var _tiles:Vector.<SubTexture> = new Vector.<SubTexture>();
		public function get tiles():Vector.<SubTexture> { return _tiles; }
		
		private var _textures:Vector.<Texture> = new Vector.<Texture>();
		
		private var _maxInternalTextureHeight:int;
		private var _maxInternalTextureWidth:int;
		
		private var _skipFullyTransparentTiles:Boolean;
		
		public function CFTileAtlas(o:flash.display.DisplayObject, skipFullyTransparentTiles:Boolean=false,
			tileWidth:int=256, tileHeight:int=256, maxInternalTextureWidth:int=2048, maxInternalTextureHeight:int=2048)
		{
			_skipFullyTransparentTiles = skipFullyTransparentTiles;
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			_maxInternalTextureWidth = maxInternalTextureWidth;
			_maxInternalTextureHeight = maxInternalTextureHeight;
			
			var bitmapTiles:Vector.<Bitmap> = displayObjectToBitmapTiles(o);
			
			_tiles = bitmapTilesToSubTextures(bitmapTiles);
		}
		
		private function displayObjectToBitmapTiles(o:flash.display.DisplayObject):Vector.<Bitmap>
		{
			var bmTiles:Vector.<Bitmap> = new Vector.<Bitmap>();
			var numTilesWide:int = Math.ceil(o.width / tileWidth);
			var numTilesHigh:int = Math.ceil(o.height / tileHeight);
			
			for (var j:int = 0; j < numTilesHigh; ++j)
			{
				for (var i:int = 0; i < numTilesWide; ++i)
				{
					var surface:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0);
					var p:Point = new Point(i * (tileWidth), j * (tileHeight));
					var m:Matrix = new Matrix();
					
					m.translate(-p.x, -p.y);
					surface.draw(o, m, null, null, new Rectangle(0, 0, tileWidth, tileHeight));
					
					_tilePositions.push(p);
					
					if (_skipFullyTransparentTiles)
					{
						var alphaHistogram:Vector.<Number> = surface.histogram()[3];
						var numFullyTransparentPixels:int = alphaHistogram[0];
						
						if (numFullyTransparentPixels == (tileWidth * tileHeight))
						{
							bmTiles.push(null);
							
							continue;
						}
					}
					
					var bitmap:Bitmap = new Bitmap(surface);
					
					bitmap.x = p.x;
					bitmap.y = p.y;
					
					bmTiles.push(bitmap);
				}
			}
			
			return bmTiles;
		}
		
		private function bitmapTilesToSubTextures(bmTiles:Vector.<Bitmap>):Vector.<SubTexture>
		{
			var numColumns:int = _maxInternalTextureWidth / tileWidth;
			var numRows:int = Math.ceil(bmTiles.length / numColumns);
			var numRowsPerTexture:int = _maxInternalTextureHeight / tileHeight;
			var numTextures:int = Math.ceil(numRows / numRowsPerTexture);
			var maxTilesPerTexture:int = numColumns * numRowsPerTexture;
			
			var surfaceWidth:int = tileWidth * numColumns;
			var surfaceHeight:int = tileHeight * numRowsPerTexture;
			
			var subtextures:Vector.<SubTexture> = new Vector.<SubTexture>();
			
			for (var textureIndex:int = 0; textureIndex < numTextures; ++textureIndex)
			{
				var surface:BitmapData = new BitmapData(surfaceWidth, surfaceHeight, true, 0);
				var baseIndex:int = textureIndex * maxTilesPerTexture;
				var eor:int = Math.min(baseIndex + maxTilesPerTexture, bmTiles.length);
				
				for (var i:int = baseIndex; i < eor; ++i)
				{
					if (bmTiles[i] == null) continue;
					
					var i0:int = i - baseIndex;
					var p:Point = new Point((i0 % numColumns) * tileWidth, Math.floor(i0 / numColumns) * tileHeight);
					
					surface.copyPixels(bmTiles[i].bitmapData, bmTiles[i].bitmapData.rect, p);
				}
				
				var atlas:Texture = Texture.fromBitmapData(surface, false, false);
				
				_textures.push(atlas);
				
				atlas.repeat = false;
				
				for (i = baseIndex; i < eor; ++i)
				{
					if (bmTiles[i] == null)
					{
						subtextures.push(null);
						
						continue;
					}
					
					i0 = i - baseIndex;
					p = new Point((i0 % numColumns) * tileWidth, Math.floor(i0 / numColumns) * tileHeight);
					
					// Note: Tile dimensions are adjusted to prevent unwanted borders.
					var subtexture:SubTexture = new SubTexture(atlas, new Rectangle(p.x + 1, p.y + 1, tileWidth - 2, tileHeight - 2));
					
					subtexture.repeat = false;
					
					subtextures.push(subtexture);
				}
			}
			
			return subtextures;
		}
		
		public function dispose():void
		{
			for (var i:int = 0; i < _tiles.length; ++i)
			{
				if (_tiles[i] != null)
				{
					_tiles[i].dispose();
				}
			}
			
			for (i = 0; i < _tiles.length; ++i)
			{
				_textures[i].dispose();
			}
		}
		
	}
}