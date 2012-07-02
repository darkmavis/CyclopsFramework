package org.cyclopsframework.starling.tiles
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.cyclopsframework.core.ICFDisposable;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.utils.collections.CFHashSet;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	public class CFTileLayer extends Sprite implements ICFTaggable
	{
		public static const TAG:String = "CFTileLayer";
		
		private var _tags:CFHashSet = new CFHashSet();
		public function get tags():CFStringHashSet { return tags; }
		
		private var _atlas:CFTileAtlas;
		
		private var _viewport:Rectangle;
		public function get viewport():Rectangle { return _viewport; }
		
		private var _tileDataSource:ICFTileDataSource;
		
		private var _grid:Vector.<Image>;
		
		private var _numGridColumns:int;
		private var _numGridRows:int;
		
		private var _bg:Sprite = new Sprite();
		
		public function CFTileLayer(atlas:CFTileAtlas, tileDataSource:ICFTileDataSource, viewport:Rectangle)
		{
			_tags.add(TAG);
			
			_atlas = atlas;
			_viewport = viewport;
			_tileDataSource = tileDataSource;
			
			_numGridColumns = viewport.width;
			_numGridRows = viewport.height;
			
			_grid = new Vector.<Image>(_numGridColumns * _numGridRows);
			
			addChild(_bg);
			
			update();
		}
		
		public function update():void
		{
			_bg.x = -(_viewport.x % 1.0) * _atlas.tileWidth;
			_bg.y = -(_viewport.y % 1.0) * _atlas.tileHeight;
			
			var flattenRequired:Boolean = false;
			
			for (var i:int = 0; i < _numGridColumns; ++i)
			{
				for (var j:int = 0; j < _numGridRows; ++j)
				{
					var px:int = i + viewport.x;
					var py:int = j + viewport.y;
					
					var gridIndex:int = j * _numGridColumns + i;
					
					var targetTileIndex:int = _tileDataSource.readTileIndex(px, py);
					var targetSubTexture:Texture = _atlas.tiles[targetTileIndex];
					var existingSubTexture:Texture = (_grid[gridIndex] != null) ? _grid[gridIndex].texture : null;
					
					if (targetSubTexture == null) continue;
					
					if (targetSubTexture != existingSubTexture)
					{
						var targetImage:Image = new Image(targetSubTexture);
						
						// fix image width, height
						// see: CFTileAtlas.bitmapTilesToSubTextures
						targetImage.width += 2;
						targetImage.height += 2;
						
						targetImage.x = i * targetImage.width;
						targetImage.y = j * targetImage.height;
						
						if (_grid[gridIndex] != null)
						{
							_bg.removeChild(_grid[gridIndex]);
							_grid[gridIndex].dispose();
						}
						
						_grid[gridIndex] = targetImage;
						
						_bg.addChild(targetImage);
						
						flattenRequired = true;
					}
					
				}
			}
			
			if (flattenRequired)
			{
				_bg.flatten();
			}
		}
		
	}
}