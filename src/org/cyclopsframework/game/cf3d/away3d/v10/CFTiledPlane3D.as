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

package org.cyclopsframework.game.cf3d.away3d.v10
{
	import away3d.containers.Bone;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import org.cyclopsframework.game.tiles.CFTileLayer;
	import org.cyclopsframework.game.tiles.CFTileset;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class CFTiledPlane3D extends CFScene3D
	{
		private var _textureBitmap:Bitmap;
		public function get texture():BitmapData { return _textureBitmap.bitmapData; }
				
		private var _tileset:CFTileset;
		public function get tileset():CFTileset { return _tileset; }
				
		private var _tileLayer:CFTileLayer;
		public function get tileLayer():CFTileLayer { return _tileLayer; }
		
		private var _tileLayerCameraRect:Rectangle;
		
		private var _autoRefreshEnabled:Boolean;
		
		private var _terrain:Plane;
		private var _terrainMaterial:BitmapMaterial;
		
		
		public function CFTiledPlane3D(columns:int, rows:int, width:Number, height:Number, tileset:CFTileset, autoRefreshEnabled:Boolean=true)
		{
			super();
			
			_tileset = tileset;
			_autoRefreshEnabled = autoRefreshEnabled;
			
			_tileLayer = new CFTileLayer(columns, rows, tileset);
			_tileLayerCameraRect = new Rectangle(0, 0, columns, columns);
			_textureBitmap = new Bitmap(new BitmapData(_tileLayerCameraRect.width * tileset.tileHeight, _tileLayerCameraRect.height * tileset.tileHeight));
			
			if (_autoRefreshEnabled)
			{
				engine.sugar.loop(refresh).addTag("refresh");
			}
			
			_terrain = new Plane();
			_terrainMaterial = new BitmapMaterial(texture);
		
			_terrainMaterial.smooth = true;
			_terrain.material = _terrainMaterial;
			_terrain.width = width;
			_terrain.height = height;
			_terrain.segmentsW = 1;
			_terrain.segmentsH = 1;
			
			_terrain.pitch(-90);
			
			scene3d.addChild(_terrain);
		}
		
		public function refresh():void
		{
			tileLayer.drawView(_tileLayerCameraRect, texture);
		}
		
		
		
	}
}