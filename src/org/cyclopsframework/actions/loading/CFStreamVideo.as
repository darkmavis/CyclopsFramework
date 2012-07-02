package org.cyclopsframework.actions.loading
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.logging.CFLog;
	
	public class CFStreamVideo extends CFAction
	{
		public static const TAG:String = "CFStreamVideo";
		
		private var _video:Video;
		public function get video():Video { return _video; }
		
		private var _url:String;
		private var _minBufferLength:Number;
		private var _progressFunction:Function;
		
		private var _ns:NetStream;
		public function get netstream():NetStream { return _ns; }
		
		public function CFStreamVideo(video:Video, url:String, minBufferLength:Number=2, progressFunction:Function=null)
		{
			super(0, Number.MAX_VALUE, null, [TAG]);
			
			_video = video;
			_url = url;
			_minBufferLength = minBufferLength;
			_progressFunction = progressFunction;
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			_ns = new NetStream(nc);
		}
		
		protected override function onEnter():void
		{
			_ns.bufferTime = _minBufferLength;
			_ns.client = {"onMetaData": function(info:Object):void {}};
			_ns.play(_url);
			
			_video.attachNetStream(_ns);
			_ns.pause();
		}
		
		protected override function onFrame(t:Number):void
		{
			var progress:Number = Math.min(_ns.bufferLength / _minBufferLength, 1);
			
			if (_progressFunction != null)
			{
				_progressFunction(progress);
			}
			
			if (progress == 1)
			{
				stop();
			}
		}
		
		protected override function onExit():void
		{
			// cleanup required?
		}
	}
}