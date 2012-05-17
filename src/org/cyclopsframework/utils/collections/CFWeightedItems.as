package org.cyclopsframework.utils.collections
{
	import org.cyclopsframework.utils.math.CFMath;

	public class CFWeightedItems
	{
		private var _items:Array;
		private var _probabilities:Array;
		private var _sumOfProbabilities:Number = 0;
		
		public function get random():Object
		{
			//var target:Number = Math.random() * _sumOfProbabilities;
			var target:Number = CFMath.random() * _sumOfProbabilities;
			
			for (var i:int = 0; i < _probabilities.length; ++i)
			{
				if (target < _probabilities[i])
				{
					return _items[i];
				}
			}
			
			throw(new Error("This line should never be reached."));
			
			return null;
			
		}
		
		public function CFWeightedItems(items:Array, indexedProbabilities:Array)
		{
			_items = items;
			_probabilities = new Array(indexedProbabilities.length);
			
			for (var i:int = 0; i < indexedProbabilities.length; ++i)
			{
				_sumOfProbabilities += indexedProbabilities[i];
				_probabilities[i] = _sumOfProbabilities;
			}
		}
		
		public static function fromKeyValuePairs(pairs:Object):CFWeightedItems
		{
			var keys:Array = [];
			var values:Array = [];
			
			for (var k:Object in pairs)
			{
				keys.push(k);
				values.push(pairs[k]);
			}
			
			return new CFWeightedItems(keys, values);
		}
		
		public static function fromIndexedArray(items:Array):CFWeightedItems
		{
			var keys:Array = [];
			var values:Array = [];
			
			for (var i:int = 0; i < items.length; ++i)
			{
				keys.push(i);
				values.push(items[i]);
			}
			
			return new CFWeightedItems(keys, values);
		}
		
	}
}