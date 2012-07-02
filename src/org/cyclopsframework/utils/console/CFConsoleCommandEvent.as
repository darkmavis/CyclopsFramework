package org.cyclopsframework.utils.console
{
	import flash.events.Event;
	
	public class CFConsoleCommandEvent extends Event
	{
		private var _args:Array;
		public function get args():Array { return _args; }
		
		public function CFConsoleCommandEvent(name:String, args:Array)
		{
			super(name);
			
			_args = args;
		}
	}
}