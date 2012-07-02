package org.cyclopsframework.actions.animation
{
	import flash.geom.Point;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	public class CFTranslateByVelocity extends CFAction
	{
		public static const TAG:String = "@CFTranslateByVelocity";
		
		private var _dynamicTarget:Object = null;
		private var _dampingPeriod:Number = 0;
		private var _dampingPosition:Number = 0;
		private var _dampingBias:Function;
		
		private var _velocity:Point = new Point(0, 0);
		public function get velocity():Point { return _velocity; }
		public function set velocity(value:Point):void
		{
			_velocity = value;
			_dampingPosition = 0;
		}
		
		public function CFTranslateByVelocity(
			target:Object,
			dampingPeriod:Number,
			dampingBias:Function=null)
		{
			super(Number.MAX_VALUE, 1, null, [TAG]);
			
			CFUtils.validate(target, "CFTranslateByVelocity", ["x", "y"]);
			
			_dynamicTarget = target;
			_dampingPeriod = Math.max(dampingPeriod, .001);
			_dampingBias = dampingBias;
		}
		
		protected override function onFrame(t:Number):void
		{
			_dynamicTarget.x = _dynamicTarget.x + _velocity.x * speed;
			_dynamicTarget.y = _dynamicTarget.y + _velocity.y * speed;
			
			var damper:Number = CFMath.clamp(1.0 - _dampingBias(_dampingPosition), 0, 1);
			
			_velocity.x *= damper;
			_velocity.y *= damper;
		
			_dampingPosition = CFMath.clamp(_dampingPosition + engine.delta / _dampingPeriod, 0, 1);
		}
	}
}