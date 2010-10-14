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

package cyclopsframework.game.tiles
{
	public class CCTileData implements ICCTileData
	{
		private var _tileIndex:int = 0;
		public function get tileIndex():int { return _tileIndex; }
		public function set tileIndex(value:int):void { _tileIndex = value;	}
		
		private var _data:Object;
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		
		public function CCTileData(tileIndex:int=0)
		{
			_tileIndex = tileIndex;
		}
		
		
		
		
	}
}