package cyclopsframework.utils.primitives
{
	import flash.display.Sprite;

	public class CCPrimitives
	{
		public function CCPrimitives()
		{
			
		}
		
		public static function box(width:Number, height:Number, thickness:Number, color:uint, alpha:Number=1):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(thickness, color, alpha);
			sprite.graphics.drawRect(-width / 2, -height / 2, width, height);
			sprite.graphics.lineStyle();
			return sprite;
		}
		
		public static function filledBox(width:Number, height:Number, color:uint, alpha:Number=1):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(-width / 2, -height / 2, width, height);
			sprite.graphics.endFill();
			return sprite;
		}
		
		public static function circle(radius:Number, thickness:Number, color:uint, alpha:Number=1):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(thickness, color, alpha);
			sprite.graphics.drawCircle(0, 0, radius);
			sprite.graphics.lineStyle();
			return sprite;
		}
		
		public static function filledCircle(radius:Number, color:uint, alpha:Number=1):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawCircle(0, 0, radius);
			sprite.graphics.endFill();
			return sprite;
		}
		
	}
}