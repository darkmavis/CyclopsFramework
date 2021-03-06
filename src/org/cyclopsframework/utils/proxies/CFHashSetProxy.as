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
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import org.cyclopsframework.utils.collections.CFHashSet;
	
	public dynamic class CFHashSetProxy extends Proxy
	{
		private var _hashset:CFHashSet;
		
		public function CFHashSetProxy(hashset:CFHashSet)
		{
			super();
			_hashset = hashset;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			var results:Array = [];
			
			_hashset.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(methodName) && (item[methodName] is Function))
				{
					results.push(item[methodName].apply(null, args));
				}
			});
			
			return results;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			var results:Array = [];
			
			_hashset.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(name) && !(item[name] is Function))
				{
					results.push(item[name]);
				}
			});
			
			return results;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_hashset.forEach(function(item:Object):void
			{
				if (item.hasOwnProperty(name) && !(item[name] is Function))
				{
					item[name] = value;
				}
			});
		}
		
		
	}
}