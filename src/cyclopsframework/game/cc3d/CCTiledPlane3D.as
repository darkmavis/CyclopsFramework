package cyclopsframework.game.cc3d
{
	import away3d.containers.Bone;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import cyclopsframework.game.tiles.CCTileLayer;
	import cyclopsframework.game.tiles.CCTileset;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class CCTiledPlane3D extends CCScene3D
	{
		private var _textureBitmap:Bitmap;
		public function get texture():BitmapData { return _textureBitmap.bitmapData; }
				
		private var _tileset:CCTileset;
		public function get tileset():CCTileset { return _tileset; }
				
		private var _tileLayer:CCTileLayer;
		public function get tileLayer():CCTileLayer { return _tileLayer; }
		
		private var _tileLayerCameraRect:Rectangle;
		
		private var _autoRefreshEnabled:Boolean;
		
		private var _terrain:Plane;
		private var _terrainMaterial:BitmapMaterial;
		
		
		public function CCTiledPlane3D(columns:int, rows:int, width:Number, height:Number, tileset:CCTileset, autoRefreshEnabled:Boolean=true)
		{
			super();
			
			_tileset = tileset;
			_autoRefreshEnabled = autoRefreshEnabled;
			
			_tileLayer = new CCTileLayer(columns, rows, tileset);
			_tileLayerCameraRect = new Rectangle(0, 0, columns, columns);
			_textureBitmap = new Bitmap(new BitmapData(_tileLayerCameraRect.width * tileset.tileHeight, _tileLayerCameraRect.height * tileset.tileHeight));
			
			if (_autoRefreshEnabled)
			{
				engine.loop(refresh).addTag("refresh");
			}
			
			_terrain = new Plane();
			_terrainMaterial = new BitmapMaterial(texture);
		
			_terrainMaterial.smooth = true;
			_terrain.material = _terrainMaterial;
			_terrain.width = width;
			_terrain.height = height;
			_terrain.segmentsW = 1;
			_terrain.segmentsH = 1;
			
			scene3d.addChild(_terrain);
		}
		
		public function refresh():void
		{
			tileLayer.drawView(_tileLayerCameraRect, texture);
		}
		
		
		
	}
}