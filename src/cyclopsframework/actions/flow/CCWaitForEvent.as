package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class CCWaitForEvent extends CCAction
	{
		public static const TAG:String = "@CCWaitForEvent";
		
		private var _target:IEventDispatcher;
		private var _eventType:String;
		
		public function CCWaitForEvent(
			target:IEventDispatcher,
			eventType:String,
			timeout:Number=Number.MAX_VALUE,
			cycles:Number=1)
		{
			super(timeout, cycles, null, [TAG]);
			_target = target;
			_eventType = eventType;
		}
		
		protected override function onEnter():void
		{
			_target.addEventListener(_eventType, onEvent);
		}
		
		private function onEvent(e:Event):void
		{
			jumpTo(this.cycle + 1);
		}
		
		protected override function onExit():void
		{
			_target.removeEventListener(_eventType, onEvent);
		}
	}
}