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

package cyclopsframework.utils.misc
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CCUtils
	{
		public function CCUtils()
		{
			
		}
				
		public static function setProperties(item:Object, kvObject:Object, deep:Boolean=false):void
		{
			for (var key:String in kvObject)
			{
				if (item.hasOwnProperty(key))
				{
					if (deep)
					{
						var hasMembers:Boolean = false;
						
						for each (var member:Object in kvObject[key])
						{
							hasMembers = true;
							setProperties(item[key], member, deep);
						}
						
						if (!hasMembers)
						{
							item[key] = kvObject;
						}
					}
					else
					{
						item[key] = kvObject;
					}
				}
			}
		}
		
		public static function walk(o:Object, f:Function, path:Array=null):void
		{
			if (path == null)
			{
				path = [];
			}
			
			path.push(o);
			
			for each (var item:Object in o)
			{
				walk(item, f, path);
			}
			
			f(path);			
			path.pop();	
		}
		
		public static function objectToString(o:Object):String
		{
			var result:String = "";
			walk(o, function(path:Array):void
			{
				result += path.join(".") + "\n";
			});
			return result;
		}
		
		public static function walkDisplayObject(o:DisplayObject, f:Function, path:Array=null):void
		{
			if (path == null)
			{
				path = [];
			}
						
			path.push(o);
			
			if (o is DisplayObjectContainer)
			{
				for (var i:int = 0; i < (o as DisplayObjectContainer).numChildren; ++i)
				{
					walk(o, f, path);
				}
			}
			
			f(path);
			path.pop();
		}
		
		public static function hasProperties(o:Object, requiredProperties:Array):Boolean
		{	
			for each (var prop:String in requiredProperties)
			{
				var target:Object = o;
				var path:Array = prop.split(".");
				var seg:String;
				
				for (var i:int = 0; i < path.length; ++i)
				{
					seg = path[i] as String;
					if (target.hasOwnProperty(seg))
					{
						target = target[seg];
					}
					else
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		public static function validate(o:Object, name:String, requiredProperties:Array=null, tagStringNotAllowed:Boolean=false):void
		{
			if (o == null)
			{
				throw new TypeError(name + " must not be null.");
			}
			
			if ((requiredProperties != null) && (!CCUtils.hasProperties(o, requiredProperties)))
			{
				throw new TypeError(name + " must have the following properties: " + requiredProperties);
			}
			
			if (tagStringNotAllowed && (o is String))
			{
				throw new TypeError(name + " can't be a tag.  Perhaps another class that supports grouping by tags would work better.");
			}
		}
		
	}
}