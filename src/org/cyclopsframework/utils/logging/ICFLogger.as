package org.cyclopsframework.utils.logging
{
	public interface ICFLogger
	{
		function print(text:Object="", channel:String=""):void;
		function println(text:Object="", channel:String=""):void;
	}
}