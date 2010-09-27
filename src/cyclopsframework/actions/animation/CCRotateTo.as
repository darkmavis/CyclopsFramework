package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	
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
			value2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCRotateTo target must not be null.");
			if (target is String) throw new TypeError("CCRotateTo can't accept a tag as a target. Use CCRotate instead.");
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_value2 = value2;
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