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

package cyclopsframework.game.bindings
{
	public class CCKeyboardBindings
	{
		private var _up:CCKeyboardBindingsGroup = new CCKeyboardBindingsGroup();
		public function get keyUp():CCKeyboardBindingsGroup { return _up; }
		
		private var _down:CCKeyboardBindingsGroup = new CCKeyboardBindingsGroup();
		public function get keyDown():CCKeyboardBindingsGroup { return _down; }
		
		public function CCKeyboardBindings()
		{
			
		}
		
	}
}