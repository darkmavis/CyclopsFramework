package org.cyclopsframework.actions.loading.status
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	
	import org.cyclopsframework.core.CFAction;

	public class CFLoaderStatus
	{
		public var loader:Loader;
		public var context:CFAction;
		public var progress:Number;
		public var errorOccurred:Boolean;
		public var errorId:int;
		public var complete:Boolean;
		
		public function CFLoaderStatus()
		{
		}
	}
}