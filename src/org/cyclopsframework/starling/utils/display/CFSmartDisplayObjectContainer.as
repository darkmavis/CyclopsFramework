package org.cyclopsframework.starling.utils.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class CFSmartDisplayObjectContainer extends DisplayObjectContainer
	{
		private var _viewport:Rectangle;
		public function get viewport():Rectangle { return _viewport; }
		public function set viewport(value:Rectangle):void { _viewport = value; }
		
		private var _safeZoneDirty:Boolean = true;
		
		private var _safeZone:Rectangle;
		public function get safeZone():Rectangle
		{
			if (_safeZoneDirty)
			{
				_safeZone = new Rectangle(
					_viewport.x + _leftMargin,
					_viewport.y + _topMargin,
					_viewport.right - _rightMargin - _viewport.x,
					_viewport.bottom - _bottomMargin - _viewport.y);
				_safeZoneDirty = false;
			}
			
			return _safeZone;
		}
		
		private var _leftMargin:int;
		public function get leftMargin():int { return _leftMargin; }
		public function set leftMargin(value:int):void { _leftMargin = value; _safeZoneDirty = true; }
		
		private var _rightMargin:int;
		public function get rightMargin():int { return _rightMargin; }
		public function set rightMargin(value:int):void { _rightMargin = value; _safeZoneDirty = true; }
		
		private var _topMargin:int;
		public function get topMargin():int { return _topMargin; }
		public function set topMargin(value:int):void { _topMargin = value; _safeZoneDirty = true; }
		
		private var _bottomMargin:int;
		public function get bottomMargin():int { return _bottomMargin; }
		public function set bottomMargin(value:int):void { _bottomMargin = value; _safeZoneDirty = true; }
		
		private var _scaleToFit:Boolean;
		public function get scaleToFit():Boolean { return _scaleToFit; }
		public function set scaleToFit(value:Boolean):void { _scaleToFit = value; }
		
		private var _anchor:CFSmartAnchor = CFSmartAnchor.NONE;
		public function get anchor():CFSmartAnchor { return _anchor; }
		public function set anchor(value:CFSmartAnchor):void { _anchor = value; }
		
		private var _p:Point = new Point();
		
		public function CFSmartDisplayObjectContainer()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:Event):void
		{
			var ap:Point = _anchor.value as Point;
			
			var rect:Rectangle = getBounds(this);
			var p:Point = rect.topLeft;
			
			if (ap.x < 0)
			{
				p.x = _safeZone.x;
			}
			else if (ap.x > 0)
			{
				p.x = _safeZone.right -rect.width;
			}
			
			if (ap.y < 0)
			{
				p.y = _safeZone.y;
			}
			else if (ap.y > 0)
			{
				p.y = _safeZone.bottom - rect.height;
			}
			
			if (p.x < _safeZone.left)
			{
				p.x = _safeZone.left;
			}
			else if (p.x > (_safeZone.right - rect.width))
			{
				p.x = _safeZone.right - rect.width;
			}
			
			if (p.y < _safeZone.top)
			{
				p.y = _safeZone.top;
			}
			else if (p.y > (_safeZone.bottom - rect.height))
			{
				p.y = _safeZone.bottom - rect.height;
			}
			
			p = globalToLocal(p);
			x = p.x;
			y = p.y;
		}	
	}
}