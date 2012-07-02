package org.cyclopsframework.actions.loading.enums
{
	import flash.net.URLLoaderDataFormat;
	
	import org.cyclopsframework.utils.misc.CFEnum;
	
	public class CFLoaderDataFormat extends CFEnum
	{
		public static const BINARY:CFLoaderDataFormat = new CFLoaderDataFormat(URLLoaderDataFormat.BINARY);
		public static const TEXT:CFLoaderDataFormat = new CFLoaderDataFormat(URLLoaderDataFormat.TEXT);
		public static const VARIABLES:CFLoaderDataFormat = new CFLoaderDataFormat(URLLoaderDataFormat.VARIABLES);
		
		public function CFLoaderDataFormat(name:String=null)
		{
			super(name);
		}
	}
}