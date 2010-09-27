package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.geom.Point;
	
	public class CCTranslateToObject extends CCAction
	{
		public static const TAG:String = "@CCTranslateToObject";
		
		private var _target:Object;
		private var _destination:Object;
		private var _p1:Point;
		
		public function CCTranslateToObject(
			target:Object,
			destination:Object,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCTranslateToObject target must not be null.");
			if (!(target.hasOwnProperty("x") && target.hasOwnProperty("y")))
			{
				throw new TypeError("CCTranslateToObject target must have x and y properties.");
			}
			
			if (destination == null) throw new TypeError("CCTranslateToObject destination must not be null.");
			if (!(destination.hasOwnProperty("x") && destination.hasOwnProperty("y")))
			{
				throw new TypeError("CCTranslateToObject destination must have x and y properties.");
			}
			
			_target = target;
			_destination = destination;
		}
		
		protected override function onEnter():void
		{
			_p1 = new Point(_target.x, _target.y);
		}
		
		protected override function onFrame(t:Number):void
		{
			CCMath.lerpTarget2(_target, _p1, _destination, t);
		}
	}
}