package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.geom.Point;
		
	public class CCTranslateBy extends CCAction
	{
		public static const TAG:String = "@CCTranslateBy";
		
		private var _dynamicTarget:Object = null;
		private var _p1:Point;
		private var _p2:Point;
		
		public function CCTranslateBy(
			target:Object,
			relX:Number,
			relY:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			CCUtils.validate(target, "CCTranslateBy target", ["x", "y"]);
			
			_dynamicTarget = target;
			_p2 = new Point(relX, relY);
		}
		
		protected override function onEnter():void
		{
			_p1 = new Point(_dynamicTarget.x, _dynamicTarget.y);
			_p2 = _p2.add(_p1);
		}
		
		protected override function onFrame(t:Number):void
		{
			CCMath.lerpTarget2(_dynamicTarget, _p1, _p2, t);
		}
	}
}