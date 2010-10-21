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