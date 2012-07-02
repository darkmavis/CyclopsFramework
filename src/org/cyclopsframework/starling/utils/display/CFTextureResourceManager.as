package org.cyclopsframework.starling.utils.display
{
	import flash.display.Bitmap;
	
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class CFTextureResourceManager
	{
		private var _atlasXml:XML;
		
		private var _atlas:TextureAtlas;
		public function get atlas():TextureAtlas { return _atlas; }
		
		public function CFTextureResourceManager(resourceImageType:Class, atlasXmlType:Class)
		{
			var atlasBitmap:Bitmap = new resourceImageType() as Bitmap;
			var xml:XML = CFUtils.createResource(atlasXmlType, XML);
			
			_atlas = new TextureAtlas(Texture.fromBitmap(atlasBitmap), xml);
		}
	}
}