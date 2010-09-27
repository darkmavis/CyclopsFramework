package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	
	public class CCFunction extends CCAction
	{
		public static const TAG:String = "@CCFunction";
		
		private var _f:Function;
		private var _thisObject:Object;
		private var _data:Array;
		
		public function CCFunction(
			period:Number,
			cycles:Number,
			thisObject:Object,
			data:Array,
			f:Function)
		{
			super(period, cycles, null, [TAG]);
			_thisObject = thisObject;
			_data = data;
			_f = f;
		}
		
		public static function initLoop(f:Function):CCFunction
		{
			return new CCFunction(0, Number.MAX_VALUE, null, null, f);	
		}
		
		protected override function onFirstFrame():void
		{
			_f.apply(_thisObject, _data);
		}
		
	}
}