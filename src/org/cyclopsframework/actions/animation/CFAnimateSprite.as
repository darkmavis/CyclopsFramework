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

package org.cyclopsframework.actions.animation
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.game.tiles.CFTileset;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class CFAnimateSprite extends CFAction
	{
		public static const TAG:String = "@CFAnimateSprite";
		
		private var _target:BitmapData;
		private var _tileset:CFTileset;
		private var _indices:Array;
		private var _p:Point = new Point();
		
		private var _restingFrame:int;
		public function get restingFrame():int { return _restingFrame; }
		public function set restingFrame(value:int):void { _restingFrame = value; }
		
		private var _restingFrameThreshold:Number = 0;
		public function get restingFrameThreshold():Number { return _restingFrameThreshold; }
		public function set restingFrameThreshold(value:Number):void { _restingFrameThreshold = value; }
		
		public function CFAnimateSprite(
			target:BitmapData,
			tileset:CFTileset,
			indices:Array,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			_target = target;
			_tileset = tileset;
			_indices = indices;
		}
		
		protected override function onFrame(t:Number):void
		{
			var index:int = _indices[((t < 1) ? int(t * _indices.length) : (_indices.length - 1))];
			
			if ((speed <= _restingFrameThreshold) && (_restingFrame >= 0))
			{
				index = _restingFrame;
			}
			
			_target.copyPixels(_tileset.atlas, _tileset.getTileRect(index), _p);
		}
				
	}
}