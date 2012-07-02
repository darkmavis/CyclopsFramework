package org.cyclopsframework.actions.loading
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.cyclopsframework.actions.loading.enums.CFLoaderDataFormat;
	import org.cyclopsframework.actions.loading.status.CFLoaderStatus;
	import org.cyclopsframework.core.CFAction;
	import org.cyclopsframework.utils.logging.CFLog;
	
	public class CFLoadFromURL extends CFAction
	{
		public static const TAG:String = "@CFLoadFromURL";
		
		private var _handler:Function;
		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _loaderInfo:LoaderInfo;
		private var _status:CFLoaderStatus;
		private var _completed:Boolean = false;
		
		public function CFLoadFromURL(url:String, dataFormat:CFLoaderDataFormat, timeout:Number, handler:Function)
		{
			super(timeout, 1, null, [TAG]);
			
			var request:URLRequest = new URLRequest(url);
			
			_urlLoader = new URLLoader(request);
			
			_urlLoader.dataFormat = dataFormat.toString();
			
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, onError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			_status = new CFLoaderStatus();
			
			_handler = handler;
			
			_urlLoader.load(request);
		}
		
		private function onError(error:Object):void
		{
			CFLog.println(error.toString());
			_status.errorOccurred = true;
			_status.errorId = error["errorID"];
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			var bytesTotal:Number = e.bytesTotal;
			
			if (bytesTotal > 0)
			{
				_status.progress = e.bytesLoaded / bytesTotal;
			}
		}
		
		private function onComplete(e:Event):void
		{
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			
			context.allowCodeImport = true;
			
			_loader = new Loader();
			
			_status.loader = _loader;
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onByteLoaderComplete);
			
			_loader.loadBytes(_urlLoader.data, context);
		}
		
		private function onByteLoaderComplete(e:Event):void
		{
			_status.progress = 1;
			_status.context = this;
			_completed = true;
			
			stop();
		}
		
		protected override function onFrame(t:Number):void
		{
			_handler(_status);
		}
		
		protected override function onExit():void
		{
			_status.complete = _completed;
			
			_handler(_status);
			
			if (_loader != null)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onByteLoaderComplete);
			}
			
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onError);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.removeEventListener(Event.COMPLETE, onComplete);
		}
	}
}