package cyclopsframework.actions.physics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.misc.CCUtils;
	
	import flash.geom.Point;
	
	public class CCPhysicsActor extends CCAction
	{
		public static const TAG:String = "@CCPhysicsActor";
		
		public static const ORIENTATION_XY:int = 0;
		public static const ORIENTATION_XZ:int = 1;
				
		private var _target:Object;
		public function get target():Object { return _target; }
		
		private var _orientation:int = ORIENTATION_XY;
		public function get orientation():int { return _orientation; }
		public function set orientation(value:int):void { _orientation = value; }
		
		private var _body:b2Body;
		public function get body():b2Body { return _body; }
		public function set body(value:b2Body):void { _body = value; }
		
		private var _scale:Number;
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void { _scale = value; }
		
		public function CCPhysicsActor(
			target:Object,
			body:b2Body,
			scale:Number,
			orientation:int,
			period:Number=Number.MAX_VALUE)
		{
			super(period, 1, null, [TAG]);
			CCUtils.validate(target, "CCPhysicsActor target", ["x", "y"], true);
			_target = target;
			_body = body;
			_scale = scale;
			_orientation = orientation;
		}
				
		protected override function onFrame(t:Number):void
		{
			var position:b2Vec2 = body.GetPosition();
			
			if (_orientation == ORIENTATION_XY)
			{
				target.x = position.x * _scale;
				target.y = position.y * _scale;
			}
			else if(_orientation == ORIENTATION_XZ)
			{
				target.x = position.x * _scale;
				target.z = position.y * _scale;
			}
			else
			{
				throw new Error("Orientation incorrect.  Please choose ORIENTATION_XY or ORIENTATION_XZ.");
			}
		}
		
	}
}