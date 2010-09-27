package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.display.DisplayObject;
	
	public class CCScale extends CCAction
	{
		public static const TAG:String = "@CCScale";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		private var _width1:Number;
		private var _width2:Number;
		private var _height1:Number;
		private var _height2:Number;
				
		public function CCScale(
			target:Object,
			width1:Number,
			height1:Number,
			width2:Number,
			height2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCScale target must not be null.");
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
			_width1 = width1;
			_height1 = height1;
			_width2 = width2;
			_height2 = height2;
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