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