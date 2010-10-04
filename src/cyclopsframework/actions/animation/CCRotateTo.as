package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.display.DisplayObject;
	
	public class CCRotateTo extends CCAction
	{
		public static const TAG:String = "@CCRotateTo";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _value1:Number;
		private var _value2:Number;
		
		public function CCRotateTo(
			target:Object,
			degrees:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CCUtils.validate(target, "CCRotateTo target", null, true);
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_value2 = degrees;
		}
		
		protected override function onEnter():void
		{
			if (_dynamicTarget.hasOwnProperty("rotation"))
			{
				_value1 = _dynamicTarget["rotation"];
			}
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.rotation = CCMath.lerp(_value1, _value2, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "rotation", CCMath.lerp(_value1, _value2, t));
			}
		}
	}
}