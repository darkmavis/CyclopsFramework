package cyclopsframework.core
{
	public class CCMessage
	{
		private var _receiverTag:String;
		public function get receiverTag():String { return _receiverTag; }
		
		private var _name:String;
		public function get name():String { return _name; }
		
		private var _data:Array;
		public function get data():Array { return _data; }
		
		private var _sender:Object;
		public function get sender():Object { return _sender; }
		
		private var _receiverType:Class;
		public function get receiverType():Class { return _receiverType; }
		
		private var _canceled:Boolean;
		public function get canceled():Boolean { return _canceled; }
		public function set canceled(value:Boolean):void { _canceled = value; }
				
		public function CCMessage(receiverTag:String, name:String, data:Array, sender:Object, receiverType:Class)
		{
			_receiverTag = receiverTag;
			_name = name;
			_data = data;
			_sender = sender;
			_receiverType = receiverType;
		}
		
	}
}