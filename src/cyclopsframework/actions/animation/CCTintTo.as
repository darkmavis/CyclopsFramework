package cyclopsframework.actions.animation
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.color.CCColor;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class CCTintTo extends CCAction
	{
		public static const TAG:String = "@CCTintTo";
		
		private var _target:DisplayObject = null;
		private var _tc:CCColor = new CCColor(1,1,1,1);
		private var _c1:CCColor;
		private var _c2:CCColor;
		
		public function CCTintTo(
			target:DisplayObject,
			c2:CCColor,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			if (target == null) throw new TypeError("CCTintTo target must not be null.");
			
			_target = target;
			_c2 = c2;
		}
		
		protected override function onEnter():void
		{
			_c1 = CCColor.fromColorTransform(_target.transform.colorTransform);
		}
		
		protected override function onFrame(t:Number):void
		{
			var ct:ColorTransform = CCColor.lerp(_tc, _c1, _c2, t).toColorTransform();
			ct.alphaMultiplier = _target.transform.colorTransform.alphaMultiplier;
			_target.transform.colorTransform = ct;
		}
	}
}