/**
 * Cyclops Framework
 * 
 * Copyright 2010 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyclopsframework.core
{
	public class CFMessage
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
				
		public function CFMessage(receiverTag:String, name:String, data:Array=null, sender:Object=null, receiverType:Class=null)
		{
			_receiverTag = receiverTag;
			_name = name;
			_data = data;
			_sender = sender;
			_receiverType = receiverType;
		}
		
	}
}