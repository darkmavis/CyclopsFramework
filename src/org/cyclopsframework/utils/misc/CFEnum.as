package org.cyclopsframework.utils.misc
{
	import flash.utils.getQualifiedClassName;

	public class CFEnum
	{
		private var _value:*;
		public function get value():* { return _value; }
		
		private var _name:String;
		
		public function CFEnum(name:String=null, value:*=null)
		{
			_name = (name != null) ? name : flash.utils.getQualifiedClassName(this);
			_value = value;
		}
		
		public function toString():String
		{
			return _name;
		}
	}
}