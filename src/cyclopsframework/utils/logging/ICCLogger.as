package cyclopsframework.utils.logging
{
	public interface ICCLogger
	{
		function print(text:Object="", channel:String=""):void;
		function println(text:Object="", channel:String=""):void;
	}
}