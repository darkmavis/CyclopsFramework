package cyclopsframework.actions.flow
{
	import cyclopsframework.core.CCAction;
	
	public class CCSleep extends CCAction
	{
		public static const TAG:String = "@CCSleep";
		
		public function CCSleep(
			period:Number=0)
		{
			super(period, 1, null, [TAG]);
		}
		
	}
}