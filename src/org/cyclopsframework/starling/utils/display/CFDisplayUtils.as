package org.cyclopsframework.starling.utils.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.Image;

	public class CFDisplayUtils
	{
		public function CFDisplayUtils()
		{
		}
		
		public static function nativeDisplayObjectToStarlingImage(o:flash.display.DisplayObject):Image
		{
			var surface:BitmapData = new BitmapData(o.width, o.height, true, 0);
			var p:Point = o.getBounds(o).topLeft;
			var m:Matrix = new Matrix();
			
			m.translate(-p.x, -p.y);
			
			surface.draw(o, m);
			
			var image:Image = Image.fromBitmap(new Bitmap(surface));
			
			image.x = p.x;
			image.y = p.y;
			
			return image;
		}
	}
}