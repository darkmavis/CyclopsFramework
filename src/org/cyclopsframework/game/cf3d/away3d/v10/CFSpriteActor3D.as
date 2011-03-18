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

package org.cyclopsframework.game.cf3d.away3d.v10
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.materials.BitmapMaterial;
	import away3d.sprites.Sprite3D;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.cyclopsframework.actions.physics.box2d.CFPhysicsActorBox2D;
	import org.cyclopsframework.actions.physics.box2d.CFPhysicsBox2D;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.game.tiles.CFTileset;
	import org.cyclopsframework.game.tiles.CFTilesetIndependent;
	import org.cyclopsframework.game.tiles.ICFTileset;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFSpriteActor3D extends CFAction
	{
		public static const TAG:String = "@CFSpriteActor3D";
		
		public static const FIXED_FRAME_MODE_DISABLED:int = -1;
		
		private var _scene:CFScene3D;
		private var _physics:CFPhysicsBox2D;
		private var _radius:Number;
		private var _physicsActor:CFPhysicsActorBox2D;
		private var _startingFrameIndex:Number;
		private var _frameOffset:int;
		private var _numAngles:int;
		private var _numFramesPerAnimation:int;
		private var _animationPosition:Number = 0;
		
		private var _tileset:ICFTileset;
		public function get tileset():ICFTileset { return _tileset; }
		public function set tileset(value:ICFTileset):void { _tileset = value; }
		
		private var _fixedFrame:int = FIXED_FRAME_MODE_DISABLED;
		public function get fixedFrame():int { return _fixedFrame; }
		public function set fixedFrame(value:int):void { _fixedFrame = value; }
		
		private var _animationFps:Number = 0;
		public function get animationFps():Number { return _animationFps; }
		public function set animationFps(value:Number):void { _animationFps = value; }
		
		private var _rotation:Number;
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void { _rotation = value; }
		
		private var _body:b2Body;
		public function get body():b2Body { return _physicsActor.body; }
		
		private var _sprite3d:Sprite3D;
		public function get sprite3D():Sprite3D { return _sprite3d; }
				
		public function get position3D():Vector3D
		{
			return new Vector3D(_sprite3d.x, _sprite3d.y, _sprite3d.z);
		}
		
		private var _rect:Rectangle;
		private var _p:Point = new Point();
		
		private var _lastAngleIndex:int = -1;
		
		public function CFSpriteActor3D(
			scene:CFScene3D,
			physics:CFPhysicsBox2D,
			radius:Number,
			density:Number,
			tileset:ICFTileset,
			scale:Number,
			x:Number=0,
			y:Number=0,
			z:Number=0,
			rotation:Number=0,
			startingFrameIndex:int=0,
			numAngles:int=1,
			numFramesPerAnimation:int=1,
			period:Number=Number.MAX_VALUE)
		{
			super(period, 1, null, [TAG]);
			
			_scene = scene;
			_physics = physics;
			_radius = radius;
			_tileset = tileset;
			_sprite3d = new Sprite3D(new BitmapMaterial(new BitmapData(_tileset.tileWidth, _tileset.tileHeight)), _tileset.tileWidth, _tileset.tileHeight, 0, "center", scale);
			_sprite3d.x = x;
			_sprite3d.y = y;
			_sprite3d.z = z;
			_rotation = rotation;
			_frameOffset = startingFrameIndex;
			_numAngles = numAngles;
			_numFramesPerAnimation = numFramesPerAnimation;
			_rect = _tileset.getTile(0).rect;
			
			_physicsActor = _physics.createSimpleActor(_sprite3d, _radius, 1);
			_physicsActor.body.SetActive(false);
		}
		
		protected override function onEnter():void
		{
			_scene.scene3d.addSprite(_sprite3d);
			_physicsActor.body.SetActive(true);
			engine.add(_physicsActor);
		}
		
		protected override function onFrame(t:Number):void
		{
			var angleIndex:int;
			
			if (fixedFrame > FIXED_FRAME_MODE_DISABLED)
			{
				angleIndex = fixedFrame;
			}
			else
			{
				_rotation = body.GetAngle() * (180 / Math.PI);
				
				angleIndex = (_frameOffset + int((CFMath.wrap(_rotation, 360) / 360) * _numAngles) + _numAngles
					- ((Math.atan2(_sprite3d.x - _scene.camera.x, _sprite3d.y - _scene.camera.y) / (Math.PI * 2)) * _numAngles + (_numAngles * .5))) % _numAngles;
				
				angleIndex += 1;
				if (angleIndex >= _numAngles) angleIndex = 0;
				
				angleIndex *= _numFramesPerAnimation;
				
				if (_animationFps > 0)
				{
					_animationPosition = (_animationPosition + engine.delta * _animationFps) % _numFramesPerAnimation;
					angleIndex += int(_animationPosition);
				}
			}
			
			if (angleIndex != _lastAngleIndex)
			{
				/*if (_tileset is CFTilesetIndependent)
				{
					(_sprite3d.material as BitmapMaterial).bitmap = _tileset.getTile(angleIndex);
				}
				else
				{*/
					(_sprite3d.material as BitmapMaterial).bitmap.copyPixels(_tileset.getTile(angleIndex), _rect, _p);
				//}
			}
			
			_lastAngleIndex = angleIndex;
			
		}
				
		protected override function onExit():void
		{
			_scene.scene3d.removeSprite(_sprite3d);
			engine.removeObject(_physicsActor);
			if (_physicsActor.body != null)
			{
				_physics.world.DestroyBody(_physicsActor.body);
			}
			else
			{
				trace ("null");
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}