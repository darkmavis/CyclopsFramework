package org.cyclopsframework.actions.audio
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFSlideSoundVolume extends CFAction
	{
		public static const TAG:String = "@CFSlideSoundVolume";
		
		private var _target:ICFSound;
		private var _dynamicTarget:Object;
		private var _a:Number;
		private var _b:Number;
		
		public function CFSlideSoundVolume(
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
			if (_dynamicTarget.hasOwnProperty("volume"))
			{
				_a = _dynamicTarget["volume"];
			}
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.volume = CFMath.lerp(_a, _b, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "volume", CFMath.lerp(_a, _b, t));
			}
		}
	}
}