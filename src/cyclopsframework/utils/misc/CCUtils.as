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
		
		
		
	}
}