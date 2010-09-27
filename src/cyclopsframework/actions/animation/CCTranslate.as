package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class CCTranslate extends CCAction
	{
		public static const TAG:String = "@CCTranslate";
		
		private var _dynamicTarget:Object = null;
		private var _p1:Point;
		private var _p2:Point;
		
		public function CCTranslate(
			target:Object,
			x1:Number,
			y1:Number,
			x2:Number,
			y2:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCTranslate target must not be null.");
			if (target is String) throw new TypeError("CCTranslate can't accept a tag as a target.");
			if (!(target.hasOwnProperty("x") && target.hasOwnProperty("y")))
			{
				throw new TypeError("CCTranslate target must have x and y properties.");
			}
			
			_dynamicTarget = target;
			_p1 = new Point(x1, y1);
			_p2 = new Point(x2, y2);
		}
		
		protected override function onFrame(t:Number):void
		{
			CCMath.lerpTarget2(_dynamicTarget, _p1, _p2, t);
		}
	}
}