package cyclopsframework.utils.collections
{
	public class CCBoolOp
	{
		private var _op:Function;
		private var _operand:Object;
		
		public function CCBoolOp(op:Function, operand:Object)
		{
			_op = op;
			_operand = operand;
		}
		
		public function op(leftOperand:Object):Boolean
		{
			if (leftOperand == null)
			{
				if (_op == CCBoolOp.opExists)
				{
					return _op(leftOperand, _operand);
				}
				else
				{
					return false;
				}
			}
			else
			{
				return _op(leftOperand, _operand);
			}
		}
		
		public static function lt(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opLt, operand);
		}
		
		public static function lte(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opLte, operand);
		}
		
		public static function gt(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opGt, operand);
		}
		
		public static function gte(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opGte, operand);
		}
		
		public static function not(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opNot, operand);
		}
		
		public static function eq(operand:Object):CCBoolOp
		{
			return new CCBoolOp(opEq, operand);
		}
		
		public static function exists(operand:Boolean):CCBoolOp
		{
			return new CCBoolOp(opExists, operand);
		}
		
		private static function opLt(a:Object, b:Object):Boolean
		{
			return a < b;
		}
		
		private static function opLte(a:Object, b:Object):Boolean
		{
			return a <= b;
		}
		
		private static function opGt(a:Object, b:Object):Boolean
		{
			return a > b;
		}
		
		private static function opGte(a:Object, b:Object):Boolean
		{
			return a >= b;
		}
				
		private static function opNot(a:Object, b:Object):Boolean
		{
			return a != b;
		}
		
		private static function opEq(a:Object, b:Object):Boolean
		{
			return a == b;
		}
		
		private static function opExists(a:Object, b:Object):Boolean
		{
			trace(a + ", " + b + ": " + ((a != null) && b));
			return ((a != null) == b);
		}
	}
}