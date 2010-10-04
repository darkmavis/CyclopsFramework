/* 
 * Some of this code was borrowed from an example provided by: Andre Michelle (andre.michelle@gmail.com)
 * http://blog.andre-michelle.com/upload/mp3pitch/MP3Pitch.as
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
		
		private const BLOCK_SIZE: int = 3072;
		
		private var _source:Sound;
		private var _output:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		
		private var _target:ByteArray = new ByteArray();
		private var _position:Number = 0;
		private var _samplePosition:Number = 0;		
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
			speed:Number=1,
			pan:Number=0,
			volume:Number=1)
		{
			super(Number.MAX_VALUE, 1, null, [TAG]);
			_source = sound;
			this.speed = speed;
			_transform = new SoundTransform(volume, pan);
		}
		
		protected override function onEnter():void
		{
			_output = new Sound();
			_output.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
			_channel = _output.play(0, 0, _transform);
		}
		
		protected override function onExit():void
		{
			_channel.stop();
			_output.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
		}
		
		protected override function onFrame(t:Number):void
		{	
			if (_channel.position >= _source.length)
			{
				stop();
			}
		}
		
		private function sampleData( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * speed;
			var positionInt: int = _position;
			var alpha: Number = _position - positionInt;
			
			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;
			
			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _source.extract( _target, need, positionInt );
			
			var n: int = read == need ? BLOCK_SIZE : read / speed;
			
			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;
			
			try
			{
				for( var i: int = 0 ; i < n ; ++i )
				{
					//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
					if( int( positionTargetNum ) != positionTargetInt )
					{
						positionTargetInt = positionTargetNum;
						
						//-- SET TARGET READ POSITION
						_target.position = positionTargetInt << 3;
						
						//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
						l0 = _target.readFloat();
						r0 = _target.readFloat();
						
						l1 = _target.readFloat();
						r1 = _target.readFloat();
					}
					
					//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
					data.writeFloat( l0 + alpha * ( l1 - l0 ) );
					data.writeFloat( r0 + alpha * ( r1 - r0 ) );
					
					//-- INCREASE TARGET POSITION
					positionTargetNum += speed;
					
					//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
					alpha += speed;
					while( alpha >= 1.0 ) --alpha;
				}
			}
			catch(e:Error)
			{
				// this can and will happen when shifting pitch.
			}
			
			//-- FILL REST OF STREAM WITH ZEROs
			if( i < BLOCK_SIZE )
			{
				while( i < BLOCK_SIZE )
				{
					data.writeFloat( 0.0 );
					data.writeFloat( 0.0 );
					
					++i;
				}
			}
			
			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;
		}
	}
}