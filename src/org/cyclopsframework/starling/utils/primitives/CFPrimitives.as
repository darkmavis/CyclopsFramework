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

package org.cyclopsframework.starling.utils.primitives
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import org.cyclopsframework.starling.utils.display.CFDisplayUtils;

	public class CFPrimitives
	{
		public function CFPrimitives()
		{
			
		}
		
		public static function box(width:Number, height:Number, thickness:Number, color:uint, alpha:Number=1):Image
		{
			var nativeSprite:flash.display.Sprite = new flash.display.Sprite;
			
			nativeSprite.graphics.lineStyle(thickness, color, alpha);
			nativeSprite.graphics.drawRect(-width / 2, -height / 2, width, height);
			nativeSprite.graphics.lineStyle();
			
			return CFDisplayUtils.nativeDisplayObjectToStarlingImage(nativeSprite);
		}
		
		public static function filledBox(width:Number, height:Number, color:uint, alpha:Number=1):Image
		{
			var nativeSprite:flash.display.Sprite = new flash.display.Sprite;
			
			nativeSprite.graphics.beginFill(color, alpha);
			nativeSprite.graphics.drawRect(-width / 2, -height / 2, width, height);
			nativeSprite.graphics.endFill();
			
			return CFDisplayUtils.nativeDisplayObjectToStarlingImage(nativeSprite);
		}
		
		public static function circle(radius:Number, thickness:Number, color:uint, alpha:Number=1):Image
		{
			var nativeSprite:flash.display.Sprite = new flash.display.Sprite;
			
			nativeSprite.graphics.lineStyle(thickness, color, alpha);
			nativeSprite.graphics.drawCircle(0, 0, radius);
			nativeSprite.graphics.lineStyle();
			
			return CFDisplayUtils.nativeDisplayObjectToStarlingImage(nativeSprite);
		}
		
		public static function filledCircle(radius:Number, color:uint, alpha:Number=1):Image
		{
			var nativeSprite:flash.display.Sprite = new flash.display.Sprite;
			
			nativeSprite.graphics.beginFill(color, alpha);
			nativeSprite.graphics.drawCircle(0, 0, radius);
			nativeSprite.graphics.endFill();
			
			return CFDisplayUtils.nativeDisplayObjectToStarlingImage(nativeSprite);
		}
		
	}
}