/**
 * Cyclops Framework
 * 
 * Copyright 2010 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package cyclopsframework.actions.physics
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Math;
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
		
		private var _targetDelta:Number;
		
		private var _world:b2World;
		public function get world():b2World { return _world; }
		
		private var _gravity:b2Vec2;
		public function get gravity():b2Vec2 { return _gravity; }
		
		private var _velocityIterations:int = 4;
		public function get velocityIterations():int { return _velocityIterations; }
		public function set velocityIterations(value:int):void { _velocityIterations = value; }
		
		private var _positionIterations:int = 4;
		public function get positionIterations():int { return _positionIterations; }
		public function set positionIterations(value:int):void { _positionIterations = value; }
		
		private var _scale:Number = 1;
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void { _scale = (value != 0) ? value : Number.MIN_VALUE; }
		
		private var _contactListener:CCContactListener = new CCContactListener();
				
		public function get onBeginContact():Function { return _contactListener.onBeginContact; }
		public function set onBeginContact(value:Function):void { _contactListener.onBeginContact = value; }
		
		public function get onEndContact():Function { return _contactListener.onEndContact; }
		public function set onEndContact(value:Function):void { _contactListener.onEndContact = value; }
		
		public function get onPreSolve():Function { return _contactListener.onPreSolve; }
		public function set onPreSolve(value:Function):void { _contactListener.onPreSolve = value; }
		
		public function get onPostSolve():Function { return _contactListener.onPostSolve; }
		public function set onPostSolve(value:Function):void { _contactListener.onPostSolve = value; }
		
		public function CCPhysics(gravity:b2Vec2=null, targetDelta:Number=1/30, sleepingEnabled:Boolean=true)
		{
			super(0, Number.MAX_VALUE, null, [TAG]);
			
			_gravity = (gravity == null) ? new b2Vec2(0, 0) : gravity;
			_targetDelta = targetDelta;
			_world = new b2World(_gravity, sleepingEnabled);
			_world.SetContinuousPhysics(true);
		}
		
		protected override function onEnter():void
		{
			_world.SetContactListener(_contactListener);
		}
		
		protected override function onFrame(t:Number):void
		{
			_world.Step(_targetDelta, velocityIterations, positionIterations);
			_world.ClearForces();
		}
		
		public function createBoxBody(x:Number, y:Number, width:Number, height:Number, bodyType:uint, density:Number):b2Body
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = bodyType;
			bodydef.position = new b2Vec2(x, y);
			var body:b2Body = world.CreateBody(bodydef);
			var shape:b2Shape = b2PolygonShape.AsBox(width, height);
			var fixture:b2Fixture = body.CreateFixture2(shape, density);
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			return body;
		}
		
		public function createEdgeBody(originX:Number, originY:Number, edgeX1:Number, edgeY1:Number, edgeX2:Number, edgeY2:Number, bodyType:uint):b2Body
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = bodyType;
			bodydef.position = new b2Vec2(originX, originY);
			var body:b2Body = world.CreateBody(bodydef);
			var shape:b2Shape = b2PolygonShape.AsEdge(new b2Vec2(edgeX1, edgeY1), new b2Vec2(edgeX2, edgeY2));
			var fixture:b2Fixture = body.CreateFixture2(shape);
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			return body;
		}
		
		public function createEdgeLoopBody(originX:Number, originY:Number, sourceVertices:Array, bodyType:uint):b2Body
		{
			var vertices:Array = [].concat(sourceVertices);
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = bodyType;
			bodydef.position = new b2Vec2(originX, originY);
			var body:b2Body = world.CreateBody(bodydef);
			var headv:b2Vec2 = vertices.shift();
			var tailv:b2Vec2 = headv;
			while(vertices.length > 0)
			{
				var v:b2Vec2 = vertices.shift();
				body.CreateFixture2(b2PolygonShape.AsEdge(tailv, v));
				tailv = v;
			}
			body.CreateFixture2(b2PolygonShape.AsEdge(tailv, headv));
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			return body;
		}
		
		public function createPolygonBody(originX:Number, originY:Number, vertices:Array, bodyType:uint):b2Body
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = bodyType;
			bodydef.position = new b2Vec2(originX, originY);
			var body:b2Body = world.CreateBody(bodydef);
			var shape:b2Shape = b2PolygonShape.AsArray(vertices, vertices.length);
			var fixture:b2Fixture = body.CreateFixture2(shape);
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			return body;
		}
				
		public function createCircleBody(x:Number, y:Number, radius:Number, bodyType:uint, density:Number):b2Body
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = bodyType;
			bodydef.position = new b2Vec2(x, y);
			var body:b2Body = world.CreateBody(bodydef);
			var shape:b2CircleShape = new b2CircleShape(radius);
			var fixture:b2Fixture = body.CreateFixture2(shape, density);
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			return body;
		}
		
		public function createSimpleActor(target:Object, radius:Number=0, density:Number=1, orientation:int=0, period:Number=Number.MAX_VALUE):CCPhysicsActor
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.type = b2Body.b2_dynamicBody;
			bodydef.fixedRotation = false;
			
			if (orientation == CCPhysicsActor.ORIENTATION_XY)
			{
				bodydef.position.x = target.x * scale;
				bodydef.position.y = target.y * scale;
			}
			else if(orientation == CCPhysicsActor.ORIENTATION_XZ)
			{
				bodydef.position.x = target.x * scale;
				bodydef.position.y = target.z * scale;
			}
			
			var body:b2Body = world.CreateBody(bodydef);
			var actor:CCPhysicsActor = new CCPhysicsActor(target, body, scale, orientation, period);
			
			var shape:b2CircleShape = new b2CircleShape(radius);
			var fixture:b2Fixture = body.CreateFixture2(shape, density);
			
			fixture.SetRestitution(.5);
			body.SetLinearDamping(.25);
			body.SetAngularDamping(.25);
			
			return actor;
		}
		
	}
}