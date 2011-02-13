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

package org.cyclopsframework.game.pathfinding.waypoints
{
	import org.cyclopsframework.core.ICFDisposable;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.utils.collections.CFHashSet;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.math.CFMath;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class CFWaypoint implements ICFDisposable, ICFTaggable
	{
		public static const TAG:String = "@CFWaypoint";
		
		public var _tags:CFStringHashSet = new CFStringHashSet();
		public function get tags():CFStringHashSet { return _tags; }
		
		private var _v:Vector3D;
		
		public function get x():Number { return _v.x; }
		public function set x(value:Number):void { _v.x = value; }
		
		public function get y():Number { return _v.y; }
		public function set y(value:Number):void { _v.y = value; }
		
		public function get z():Number { return _v.z; }
		public function set z(value:Number):void { _v.z = value; }
		
		private var _radius:Number = 0;
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void { _radius = value; }
		
		private var _links:CFHashSet = new CFHashSet();
		public function get links():CFHashSet { return _links; };
		
		private var _data:Object = {};
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		
		private var _tmpV:Vector3D = new Vector3D();
				
		public function CFWaypoint(x:Number=0, y:Number=0, z:Number=0, radius:Number=0)
		{
			tags.addItem(TAG);
			_v = new Vector3D(x, y, z);
			_radius = radius;
		}
		
		public static function fromVector3D(v:Vector3D, radius:Number=0):CFWaypoint
		{
			return new CFWaypoint(v.x, v.y, v.z, radius);
		}
		
		public static function fromPoint(p:Point, radius:Number=0):CFWaypoint
		{
			return new CFWaypoint(p.x, p.y, 0, radius);
		}
		
		public function linkTo(waypoint:CFWaypoint, bidirectional:Boolean=false):CFWaypoint
		{
			links.add(waypoint);
			if (bidirectional)
			{
				waypoint.links.add(this);
			}
			return waypoint;
		}
		
		public function withinRange2(o:Object, scale:Number=1):Boolean
		{
			//_tmpV.x = o.x;
			//_tmpV.y = o.y;
			return CFMath.objectWithinRadiusOfTarget2(o, _radius * scale, this);
		}
		
		public function withinRange3(o:Object, scale:Number=1):Boolean
		{
			//_tmpV.x = o.x;
			//_tmpV.y = o.y;
			//_tmpV.z = o.hasOwnProperty("z") ? o.z : _v.z;
			return CFMath.objectWithinRadiusOfTarget3(o, _radius * scale, this);
		}
		
		public function walk(f:Function, visitedLinks:CFHashSet=null):void
		{
			var currVisitedLinks:CFHashSet = visitedLinks;
			if (visitedLinks == null)
			{
				currVisitedLinks = new CFHashSet();
			}
			else if (currVisitedLinks.has(this))
			{
				return;
			}
			
			currVisitedLinks.add(this);
			f(this);
			links.proxy.walk(f, currVisitedLinks);
		}
		
		public function dispose():void
		{
			links.forEach(function(waypoint:CFWaypoint):void
			{
				waypoint.links.remove(this);
			});
		}
		
		public function toString():String
		{
			return "{ x:" + x + " y:" + y + " z:" + z + " radius:" + radius + " }"; 
		}
				
	}
}