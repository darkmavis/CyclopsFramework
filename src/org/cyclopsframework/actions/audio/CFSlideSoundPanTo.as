package org.cyclopsframework.actions.audio
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFSlideSoundPanTo extends CFAction
	{
		public static const TAG:String = "@CFSlideSoundPanTo";
		
		private var _target:ICFSound;
		private var _dynamicTarget:Object;
		private var _a:Number;
		private var _b:Number;
		
		public function CFSlideSoundPanTo(
			target:Object,
			a:Number,
			b:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			_target = target as ICFSound;
			_dynamicTarget = target;
			_a = a;
			_b = b;
		}
		
		protected override function onEnter():void
		{
			if (_dynamicTarget.hasOwnProperty("pan"))
			{
				_a = _dynamicTarget["pan"];
			}
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.pan = CFMath.lerp(_a, _b, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "pan", CFMath.lerp(_a, _b, t));
			}
		}
	}
}