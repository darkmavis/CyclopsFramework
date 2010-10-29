package cyclopsframework.game.pathfinding.waypoints
{
	import cyclopsframework.core.ICCDisposable;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.utils.collections.CCHashSet;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class CCWaypoint implements ICCDisposable, ICCTaggable
	{
		public static const TAG:String = "@CCWaypoint";
		
		public var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
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
		
		private var _links:CCHashSet = new CCHashSet();
		public function get links():CCHashSet { return _links; };
		
		private var _data:Object = {};
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		
		private var _tmpV:Vector3D = new Vector3D();
				
		public function CCWaypoint(x:Number=0, y:Number=0, z:Number=0, radius:Number=0)
		{
			tags.addItem(TAG);
			_v = new Vector3D(x, y, z);
			_radius = radius;
		}
		
		public static function fromVector3D(v:Vector3D, radius:Number=0):CCWaypoint
		{
			return new CCWaypoint(v.x, v.y, v.z, radius);
		}
		
		public static function fromPoint(p:Point, radius:Number=0):CCWaypoint
		{
			return new CCWaypoint(p.x, p.y, 0, radius);
		}
		
		public function linkTo(waypoint:CCWaypoint, bidirectional:Boolean=false):CCWaypoint
		{
			links.add(waypoint);
			if (bidirectional)
			{
				waypoint.links.add(this);
			}
			return waypoint;
		}
		
		public function withinRange2(o:Object):Boolean
		{
			_tmpV.x = o.x;
			_tmpV.y = o.y;
			return CCMath.objectWithinRadiusOfTarget2(o, _radius, this);
		}
		
		public function withinRange3(o:Object):Boolean
		{
			_tmpV.x = o.x;
			_tmpV.y = o.y;
			_tmpV.z = o.hasOwnProperty("z") ? o.z : _v.z; 
			return CCMath.objectWithinRadiusOfTarget3(o, _radius, this);
		}
		
		public function walk(f:Function, visitedLinks:CCHashSet=null):void
		{
			var currVisitedLinks:CCHashSet = visitedLinks;
			if (visitedLinks == null)
			{
				currVisitedLinks = new CCHashSet();
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
			links.forEach(function(waypoint:CCWaypoint):void
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