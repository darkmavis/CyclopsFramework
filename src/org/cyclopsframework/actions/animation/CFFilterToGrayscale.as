package org.cyclopsframework.actions.animation
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFFilterToGrayscale extends CFAction
	{
		public static const TAG:String = "@CFFilterToGrayscale";
		
		private var _target:DisplayObject = null;
		private var _dynamicTarget:Object = null;
		
		public function CFFilterToGrayscale(
			target:DisplayObject,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			_target = target as DisplayObject;
			_dynamicTarget = target;
		}
		
		protected override function onFrame(t:Number):void
		{
			var r:Number = .2127 * t;
			var g:Number = .7152 * t;
			var b:Number = .0722 * t;
			
			var grayscale:ColorMatrixFilter = new ColorMatrixFilter([
				CFMath.lerp(1, r, t),	g,	b,	0,	0,
				r,	CFMath.lerp(1, g, t),	b,	0,	0,
				r,	g,	CFMath.lerp(1, b, t),	0,	0,
				0,0,0,1,0
			]);
			
			if (_target != null)
			{
				_target.filters = [grayscale];
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "filters", [grayscale]);
			}
		}
	}
}