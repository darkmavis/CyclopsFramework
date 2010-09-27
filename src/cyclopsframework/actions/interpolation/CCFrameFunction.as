package cyclopsframework.actions.interpolation
{
	import cyclopsframework.core.CCAction;
	
	public class CCFrameFunction extends CCAction
	{
		public static const TAG:String = "@CCFrameFunction";
		
		private var _f:Function;
		
		public function CCFrameFunction(
			period:Number,
			cycles:Number,
			bias:Function,
			f:Function)
		{
			super(period, cycles, bias, [TAG]);
			_f = f;
		}
		
		protected override function onFrame(t:Number):void
		{
			_f(t);
		}
	}
}