package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.display.DisplayObject;
	
	public class CCScaleBy extends CCAction
	{
		public static const TAG:String = "@CCScaleTo";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _width1:Number;
		private var _width2:Number;
		private var _height1:Number;
		private var _height2:Number;
		
		public function CCScaleBy(
			target:Object,
			relWidth:Number,
			relHeight:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CCUtils.validate(target, "CCScaleBy target", null, true);
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_width2 = relWidth;
			_height2 = relHeight;
		}
		
		protected override function onEnter():void
		{
			if (_dynamicTarget.hasOwnProperty("scaleX"))
			{
				_width1 = _dynamicTarget["scaleX"];
			}
			
			if (_dynamicTarget.hasOwnProperty("scaleY"))
			{
				_height1 = _dynamicTarget["scaleY"];
			}
			
			_width2 += _width1;
			_height2 += _height1;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.scaleX = CCMath.lerp(_width1, _width2, t);
				_target.scaleY = CCMath.lerp(_height1, _height2, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "scaleX", CCMath.lerp(_width1, _width2, t));
				safeset(_dynamicTarget, "scaleY", CCMath.lerp(_height1, _height2, t));	
			}
		}
	}
}