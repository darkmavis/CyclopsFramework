package cyclopsframework.core
{
	public class CCStopActionRequest
	{
		public var actionTag:String;
		public var stopChildren:Boolean;
		
		public function CCStopActionRequest(actionTag:String, stopChildren:Boolean)
		{
			this.actionTag = actionTag;
			this.stopChildren = stopChildren;
		}
	}
}