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

package org.cyclopsframework.actions.interpolation
{
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.core.ICFTaggable;
	import org.cyclopsframework.utils.math.CFMath;
	
	public class CFInterpolate extends CFAction
	{
		public static const TAG:String = "@CFInterpolate";
		
		private var _target:Object;
		private var _propertyName:String;
		private var _a:Number;
		private var _b:Number;
		private var _mapFunc:Function;
		
		public function CFInterpolate(
			target:Object,
			propertyName:String,
			a:Number,
			b:Number,
			period:Number=0,
			cycles:Number=1,
			bias:Function=null,
			mapFunc:Function=null)
		{
			super(period, cycles, bias, [TAG]);
			_target = target;
			_propertyName = propertyName;
			_a = a;
			_b = b;
			_mapFunc = mapFunc;
		}
		
		protected override function onFrame(t:Number):void
		{
			if (!(_target is String))
			{
				processFrame(_target, t);
			}
			else
			{
				engine.query(_target as String).forEach(function(o:ICFTaggable):void
				{
					processFrame(o, t);
				});
			}
		}
		
		private function processFrame(target:Object, t:Number):void
		{
			if (_mapFunc == null)
			{
				target[_propertyName] = CFMath.lerp(_a, _b, t);
			}
			else
			{
				target[_propertyName] = _mapFunc(CFMath.lerp(_a, _b, t));
			}
		}
		
	}
}