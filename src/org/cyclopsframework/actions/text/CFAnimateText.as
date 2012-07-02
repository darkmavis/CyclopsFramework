package org.cyclopsframework.actions.text
{
	import org.cyclopsframework.core.CFAction;
	
	public class CFAnimateText extends CFAction
	{
		public static const TAG:String = "@CFAnimateText";
		
		private var _srcText:String;
		private var _srcTextChars:Array;
		private var _textChangeListener:Function;
		
		private var _text:String = "";
		
		private var _numChars:Number;
		private var _currentCharIndex:Number;
		
		public function CFAnimateText(
			srcText:String,
			period:Number,
			cycles:Number,
			bias:Function,
			textChangeListener:Function)
		{
			super(period, cycles, bias, [TAG]);
			
			_srcText = srcText;
			_textChangeListener = textChangeListener;
			_numChars = srcText.length;
		}
		
		protected override function onFirstFrame():void
		{
			_currentCharIndex = 0;
			_srcTextChars = _srcText.split("");
			_text = "";
		}
		
		protected override function onFrame(t:Number):void
		{
			while (_currentCharIndex <= (t * _numChars))
			{
				++_currentCharIndex;
				_text += _srcTextChars.shift();
				_textChangeListener(_text);
			}
		}
		
		protected override function onLastFrame():void
		{
			_textChangeListener(_srcText);
		}
	}
}