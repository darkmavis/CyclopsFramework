package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.game.tiles.CCTileset;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class CCAnimateSprite extends CCAction
	{
		public static const TAG:String = "@CCAnimateSprite";
		
		private var _target:BitmapData;
		private var _tileset:CCTileset;
		private var _indices:Array;
		private var _p:Point = new Point();
		
		private var _restingFrame:int;
		public function get restingFrame():int { return _restingFrame; }
		public function set restingFrame(value:int):void { _restingFrame = value; }
		
		private var _restingFrameThreshold:Number = 0;
		public function get restingFrameThreshold():Number { return _restingFrameThreshold; }
		public function set restingFrameThreshold(value:Number):void { _restingFrameThreshold = value; }
		
		public function CCAnimateSprite(
			target:BitmapData,
			tileset:CCTileset,
			indices:Array,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			_target = target;
			_tileset = tileset;
			_indices = indices;
		}
		
		protected override function onFrame(t:Number):void
		{
			var index:int = _indices[((t < 1) ? int(t * _indices.length) : (_indices.length - 1))];
			
			if ((speed <= _restingFrameThreshold) && (_restingFrame >= 0))
			{
				index = _restingFrame;
			}
			
			_target.copyPixels(_tileset.atlas, _tileset.getTileRect(index), _p);
		}
				
	}
}