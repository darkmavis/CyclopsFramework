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