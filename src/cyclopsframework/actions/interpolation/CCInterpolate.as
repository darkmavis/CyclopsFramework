package cyclopsframework.actions.interpolation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.utils.math.CCMath;
	
	public class CCInterpolate extends CCAction
	{
		public static const TAG:String = "@CCInterpolate";
		
		private var _target:Object;
		private var _propertyName:String;
		private var _a:Number;
		private var _b:Number;
		private var _mapFunc:Function;
		
		public function CCInterpolate(
			target:Object,
			propertyName:String,
			a:Number,
			b:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null,
			mapFunc:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			_target = target;
			_propertyName = propertyName;
			_a = a;
			_b = b;
			_mapFunc = mapFunc;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (!(_target is String))
			{
				processFrame(_target, t);
			}
			else
			{
				engine.query(_target as String).forEach(function(o:ICCTaggable):void
				{
					processFrame(o, t);
				});
			}
		}
		
		private function processFrame(target:Object, t:Number):void
		{
			if (_mapFunc == null)
			{
				target[_propertyName] = CCMath.lerp(_a, _b, t);
			}
			else
			{
				target[_propertyName] = _mapFunc(CCMath.lerp(_a, _b, t));
			}
		}
		
	}
}