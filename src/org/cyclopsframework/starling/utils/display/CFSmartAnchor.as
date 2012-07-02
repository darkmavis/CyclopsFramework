package org.cyclopsframework.starling.utils.display
{
	import flash.geom.Point;
	
	import org.cyclopsframework.utils.misc.CFEnum;

	public class CFSmartAnchor extends CFEnum
	{
		public static const NONE:CFSmartAnchor = new CFSmartAnchor("NONE", 0, 0);
		public static const TOP:CFSmartAnchor = new CFSmartAnchor("TOP", 0, -1);
		public static const TOP_LEFT:CFSmartAnchor = new CFSmartAnchor("TOP_LEFT", -1, -1);
		public static const LEFT:CFSmartAnchor = new CFSmartAnchor("LEFT", -1, 0);
		public static const BOTTOM_LEFT:CFSmartAnchor = new CFSmartAnchor("BOTTOM_LEFT", -1, 1);
		public static const BOTTOM:CFSmartAnchor = new CFSmartAnchor("BOTTOM", 0, -1);
		public static const BOTTOM_RIGHT:CFSmartAnchor = new CFSmartAnchor("BOTTOM_RIGHT", 1, 1);
		public static const RIGHT:CFSmartAnchor = new CFSmartAnchor("RIGHT", 1, 0);
		public static const TOP_RIGHT:CFSmartAnchor = new CFSmartAnchor("TOP_RIGHT", 1, 1);
		
		public function CFSmartAnchor(name:String, h:int, v:int)
		{
			super(name, new Point(h, v));
		}
	}
}