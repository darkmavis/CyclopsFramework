package cyclopsframework.actions.physics
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import cyclopsframework.actions.physics.listeners.CCContactListener;
	import cyclopsframework.core.CCAction;
	
	public class CCPhysics extends CCAction
	{
		public static const TAG:String = "@CCPhysics";
		
		private const DEFAULT_FIXED_DELTA:Number = 1 / 60;
				
		private var _world:b2World;
		public function get world():b2World { return _world; }
		
		private var _gravity:b2Vec2;
		public function get gravity():b2Vec2 { return _gravity; }
		
		private var _velocityIterations:int = 10;
		public function get velocityIterations():int { return _velocityIterations; }
		public function set velocityIterations(value:int):void { _velocityIterations = value; }
		
		private var _positionIterations:int = 10;
		public function get positionIterations():int { return _positionIterations; }
		public function set positionIterations(value:int):void { _positionIterations = value; }
		
		private var _scale:Number = 1;
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void { _scale = (value != 0) ? value : Number.MIN_VALUE; }
		
		// force min and max deltas to the same value.
		private var _fixedDelta:Number = DEFAULT_FIXED_DELTA;
		public function get fixedDelta():Number { return _fixedDelta; }
		public function set fixedDelta(value:Number):void
		{
			_fixedDelta = value;
			maxDelta = value;
			minDelta = value;
		}
		
		private var _contactListener:CCContactListener = new CCContactListener();
				
		public function get onBeginContact():Function { return _contactListener.onBeginContact; }
		public function set onBeginContact(value:Function):void { _contactListener.onBeginContact = value; }
		
		public function get onEndContact():Function { return _contactListener.onEndContact; }
		public function set onEndContact(value:Function):void { _contactListener.onEndContact = value; }
		
		public function get onPreSolve():Function { return _contactListener.onPreSolve; }
		public function set onPreSolve(value:Function):void { _contactListener.onPreSolve = value; }
		
		public function get onPostSolve():Function { return _contactListener.onPostSolve; }
		public function set onPostSolve(value:Function):void { _contactListener.onPostSolve = value; }
		
		public function CCPhysics(gravity:b2Vec2=null, sleepingEnabled:Boolean=true)
		{
			super(0, Number.MAX_VALUE, null, [TAG]);
			
			_gravity = (gravity == null) ? new b2Vec2(0, 0) : gravity;
			_world = new b2World(_gravity, sleepingEnabled);
			
			maxDelta = DEFAULT_FIXED_DELTA;
			//minDelta = DEFAULT_FIXED_DELTA;
			//fixedDelta = DEFAULT_FIXED_DELTA;
		}
		
		protected override function onEnter():void
		{
			_world.SetContactListener(_contactListener);
		}
		
		protected override function onFrame(t:Number):void
		{
			_world.Step(fixedDelta, velocityIterations, positionIterations);
			_world.ClearForces();
		}
		
		public function createSimpleActor(target:Object, radius:Number=0, density:Number=1, orientation:int=0, period:Number=Number.MAX_VALUE):CCPhysicsActor
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = b2Body.b2_dynamicBody;
			
			if (orientation == CCPhysicsActor.ORIENTATION_XY)
			{
				bodydef.position.x = target.x / scale;
				bodydef.position.y = target.y / scale;
			}
			else if(orientation == CCPhysicsActor.ORIENTATION_XZ)
			{
				bodydef.position.x = target.x / scale;
				bodydef.position.y = target.z / scale;
			}
			
			var body:b2Body = world.CreateBody(bodydef);			
			var actor:CCPhysicsActor = new CCPhysicsActor(target, body, scale, orientation, period);
			
			var shape:b2CircleShape = new b2CircleShape(radius);
			var fixture:b2Fixture = body.CreateFixture2(shape, density);
			
			fixture.SetRestitution(.5);
			
			return actor;
		}
		
	}
}