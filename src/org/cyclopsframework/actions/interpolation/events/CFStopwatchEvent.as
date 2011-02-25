package org.cyclopsframework.actions.interpolation.events
{
	import flash.events.Event;
	
	public class CFStopwatchEvent extends Event
	{
		public static var SECONDS_CHANGED:String = "SECONDS_CHANGED";
		public static var MINUTES_CHANGED:String = "MINUTES_CHANGED";
		public static var HOURS_CHANGED:String = "HOURS_CHANGED";
		public static var DAYS_CHANGED:String = "DAYS_CHANGED";
		
		public function CFStopwatchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}