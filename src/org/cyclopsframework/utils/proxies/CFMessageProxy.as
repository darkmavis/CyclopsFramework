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

package org.cyclopsframework.utils.proxies
{
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.core.CFMessage;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CFMessageProxy extends Proxy
	{
		private var _engine:CFEngine;
		private var _tag:String;
		private var _sender:Object;
		private var _receiverType:Class;
		
		public function CFMessageProxy(engine:CFEngine, tag:String, sender:Object=null, receiverType:Class=null)
		{
			super();
			_engine = engine;
			_tag = tag;
			_sender = sender;
			_receiverType = receiverType;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{	
			_engine.send(_tag, methodName, args, _sender, _receiverType);	
			return null;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return null;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_engine.send(_tag, name, [value], _sender, _receiverType);
		}
	}
}