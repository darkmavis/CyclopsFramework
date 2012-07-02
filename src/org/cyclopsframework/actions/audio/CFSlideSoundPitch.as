package org.cyclopsframework.actions.audio
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFSlideSoundPitch extends CFAction
	{
		public static const TAG:String = "@CFSlideSoundPitch";
		
		private var _target:CFDynamicSound;
		private var _dynamicTarget:Object;
		private var _a:Number;
		private var _b:Number;
		
		public function CFSlideSoundPitch(
			target:Object,
			a:Number,
			b:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			
			_target = target as CFDynamicSound;
			_dynamicTarget = target;
			_a = a;
			_b = b;
		}
		
		protected override function onEnter():void
		{
			if (_dynamicTarget.hasOwnProperty("speed"))
			{
				_a = _dynamicTarget["speed"];
			}
		}
		
		protected override function onFrame(t:Number):void
		{
			if (_target != null)
			{
				_target.speed = CFMath.lerp(_a, _b, t);
			}
			else if (_dynamicTarget != null)
			{
				safeset(_dynamicTarget, "speed", CFMath.lerp(_a, _b, t));
			}
		}
	}
}