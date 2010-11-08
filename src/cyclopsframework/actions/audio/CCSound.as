/**
 * Cyclops Framework - CCSound.as
 * 
 * All code is the copyright of the respective owners. (1a)
 * Licensed under the Apache License, Version 2.0 (the "License");
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
 * 
 */

package cyclopsframework.actions.audio
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.utils.math.CCMath;
	
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class CCSound extends CCAction
	{
		public static const TAG:String = "@CCSound";
		
		private var _source:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		
		private var _numCycles:int = 0;
		
		private var _position:Number = 0;
		private var _lastChannelPosition:Number = Number.MAX_VALUE;
		
		public function get pan():Number { return _transform.pan; }
		public function set pan(value:Number):void
		{
			if (_channel == null) return;
			_transform.pan = value;
			_transform.leftToRight = 2 - CCMath.PHI;
			_transform.rightToLeft = 2 - CCMath.PHI;
			_channel.soundTransform = _transform;
		}
		
		public function get volume():Number { return _transform.volume; }
		public function set volume(value:Number):void
		{
			if (_channel == null) return;
			_transform.volume = value;
			_channel.soundTransform = _transform;
		}
		
		public function CCSound(
			sound:Sound,
			cycles:int=1,
			pan:Number=0,
			volume:Number=1)
		{
			super(Number.MAX_VALUE, 1, null, [TAG]);
			_source = sound;
			_numCycles = cycles;
			_transform = new SoundTransform(volume, pan);
		}
		
		protected override function onEnter():void
		{
			_channel = _source.play(0, _numCycles, _transform);
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		protected override function onExit():void
		{
			_channel.stop();
		}
		
		protected override function onFrame(t:Number):void
		{
			
		}
		
		private function onSoundComplete(e:Event):void
		{
			stop();
		}
		
	}
}