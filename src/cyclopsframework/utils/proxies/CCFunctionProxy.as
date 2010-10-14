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

package cyclopsframework.utils.proxies
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class CCFunctionProxy extends Proxy
	{
		private var _f:Function;
		
		public function CCFunctionProxy(f:Function)
		{
			super();
			_f = f;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{	
			_f(methodName, args);
			return null;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return null;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_f(name, [value]);
		}
	}
}