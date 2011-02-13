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

package org.cyclopsframework.actions.physics.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.misc.CFUtils;
	
	import flash.geom.Point;
	
	public class CFPhysicsActorBox2D extends CFAction
	{
		public static const TAG:String = "@CFPhysicsActor";
		
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
		
		private var _offset:Point = new Point(0, 0);
		public function get offset():Point { return _offset; }
		public function set offset(value:Point):void { _offset = value; }
		
		public function CFPhysicsActorBox2D(
			target:Object,
			body:b2Body,
			scale:Number,
			orientation:int,
			period:Number=Number.MAX_VALUE)
		{
			super(period, 1, null, [TAG]);
			CFUtils.validate(target, "CFPhysicsActor target", ["x", "y"], true);
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
				target.x = position.x / _scale + _offset.x;
				target.y = position.y / _scale + _offset.y;
			}
			else if(_orientation == ORIENTATION_XZ)
			{
				target.x = position.x / _scale + _offset.x;
				target.z = position.y / _scale + _offset.y;
			}
			else
			{
				throw new Error("Orientation incorrect.  Please choose ORIENTATION_XY or ORIENTATION_XZ.");
			}
		}
		
	}
}