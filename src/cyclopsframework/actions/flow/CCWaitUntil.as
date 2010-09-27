package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	
	public class CCWaitUntil extends CCAction
	{
		public static const TAG:String = "@CCWaitUntil";
		
		private var _f:Function;
		
		public function CCWaitUntil(
			f:Function,
			timeout:Number=Number.MAX_VALUE)
		{
			super(timeout, 1, null, [TAG]);
			_f = f;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_f() == true) this.stop();
		}
	}
}