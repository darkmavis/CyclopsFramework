package cyclopsframework.utils.logging
{
	public interface ICCLogger
	{
		function print(text:String="", channel:String=""):void;
		function println(text:String="", channel:String=""):void;
	}
}