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

package cyclopsframework.game.goals
{
	import cyclopsframework.utils.collections.CCStringHashSet;
	
	public class CCGoalEngine
	{
		private var _registry:Object = {};
		
		public function CCGoalEngine()
		{
			
		}
		
		public function update():void
		{
			for each (var stack:Vector.<Function> in _registry)
			{
				if (stack.length > 0)
				{
					var goal:Function = stack.pop() as Function;
					if (goal()) stack.push(goal);
				}
			}
		}
		
		public function pushGoal(tag:String, goal:Function):void
		{
			if (!_registry.hasOwnProperty(tag))
			{
				_registry[tag] = new Vector.<Function>();
			}
			(_registry[tag] as Vector.<Function>).push(goal);
		}
				
		public function clearGoals(tag:String):void
		{
			if (_registry.hasOwnProperty(tag))
			{
				delete _registry[tag];
			}
		}
		
	}
}