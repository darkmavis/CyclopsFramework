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

package org.cyclopsframework.utils.misc
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import org.cyclopsframework.utils.collections.CFArray;

	public class CFUtils
	{
		private static var _typeCache:Dictionary = new Dictionary(true);
		
		public function CFUtils()
		{
			
		}
		
		public static function isDynamic(o:Object):Boolean
		{
			if (!_typeCache.hasOwnProperty(o))
			{
				var type:XML = describeType(o);
				_typeCache[o] = (type.@isDynamic.toString() == "true");
			}
			return _typeCache[o] as Boolean;
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
		
		public static function walk(o:Object, f:Function, path:CFArray=null):void
		{
			if (path == null)
			{
				path = new CFArray();
			}
			
			path.push(o);
			
			for each (var item:Object in o)
			{
				walk(item, f, path);
			}
			
			if (f.length == 1)
			{
				f(path);
			}
			else if (f.length == 2)
			{
				f(path, o);
			}
			
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
		
		public static function walkDisplayObject(o:DisplayObject, f:Function, path:CFArray=null):void
		{
			if (path == null)
			{
				path = new CFArray();
			}
						
			path.push(o);
			
			if (o is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = o as DisplayObjectContainer;
				for (var i:int = 0; i < container.numChildren; ++i)
				{
					walkDisplayObject(container.getChildAt(i), f, path);
				}
			}
						
			f(path);
			path.pop();
		}
		
		public static function positionGlobally(o:Object, destObject:Object):void
		{
			var dp:Point = destObject.hasOwnProperty("localToGlobal")
				? destObject.localToGlobal(new Point()) : new Point(destObject.x, destObject.y);
			
			var p:Point = o.hasOwnProperty("globalToLocal") ? o.globalToLocal(dp) : new Point(dp.x, dp.y);
			
			o.x = p.x;
			o.y = p.y;
		}
		
		public static function gotoAndStopMovieClips(target:DisplayObject, frame:Object):void
		{
			CFUtils.walkDisplayObject(target, function(path:CFArray):void
			{
				var o:Object = path.last;
				if (o is MovieClip)
				{
					(o as MovieClip).gotoAndStop(frame);
				}
			});
		}
		
		public static function disableTextInput(target:DisplayObject):void
		{
			CFUtils.walkDisplayObject(target, function(path:CFArray):void
			{
				var o:Object = path.last;
				if (o is TextField)
				{
					(o as TextField).mouseEnabled = false;
				}
			});
		}
		
		public static function hasValidShape(target:Object, template:Object):Boolean
		{
			for (var childName:Object in template)
			{
				if (!target.hasOwnProperty(childName))
				{
					return false;
				}
				else if(target[childName] != null)
				{
					if (typeof(target[childName]) != getDefinitionByName(template[childName]))
					{
						return false;
					}
					else
					{
						return hasValidShape(target, template[childName]);
					}
				}
				else
				{
					return true;
				}
			}
			
			return true;
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
			
			if ((requiredProperties != null) && (!CFUtils.hasProperties(o, requiredProperties)))
			{
				throw new TypeError(name + " must have the following properties: " + requiredProperties);
			}
			
			if (tagStringNotAllowed && (o is String))
			{
				throw new TypeError(name + " can't be a tag.  Perhaps another class that supports grouping by tags would work better.");
			}
		}
		
		public static function anyAreNull(...params):Boolean
		{
			for (var i:int = 0; i < params.length; ++i)
			{
				if (params[i] == null) return true;
			}
			
			return false;	
		}
		
		public static function createResource(inputType:Class, outputType:Class):*
		{
			var data:ByteArray = (new inputType()) as ByteArray;
			var o:Object = new outputType(data.readUTFBytes(data.length));
			
			return o;
		}
		
		public static function ignoreErrorIDs(errorIDs:Array, f:Function):void
		{
			try
			{
				f();
			}
			catch(e:Error)
			{
				if (errorIDs.indexOf(e.errorID) == -1)
				{
					throw(e);
				}
			}
		}
				
	}
}