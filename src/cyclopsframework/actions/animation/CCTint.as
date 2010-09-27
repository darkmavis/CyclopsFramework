package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.color.CCColor;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class CCTint extends CCAction
	{
		public static const TAG:String = "@CCTint";
		
		private var _target:DisplayObject = null;
		private var _tc:CCColor = new CCColor(1,1,1,1);
		private var _c1:CCColor;
		private var _c2:CCColor;
		
		public function CCTint(
			target:DisplayObject,
			c1:CCColor,
			c2:CCColor,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCTint target must not be null.");
			
			_target = target;
			_c1 = c1;
			_c2 = c2;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				var ct:ColorTransform = CCColor.lerp(_tc, _c1, _c2, t).toColorTransform();
				ct.alphaMultiplier = _target.transform.colorTransform.alphaMultiplier;
				_target.transform.colorTransform = ct;
			}
		}
	}
}