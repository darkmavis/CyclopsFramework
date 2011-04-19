package org.cyclopsframework.core
{
	import flash.events.Event;
	
	public class CFEvent extends Event
	{
		public static const OBJECT_REGISTERED:String = "object_registered";
		
		public function CFEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}