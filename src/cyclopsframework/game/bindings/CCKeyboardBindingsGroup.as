package cyclopsframework.game.bindings
{
	import flash.ui.Keyboard;

	public class CCKeyboardBindingsGroup
	{
		private var _bindings:Object = {};
		
		public function get backspace():Function { return _bindings[Keyboard.BACKSPACE]; }
		public function set backspace(value:Function):void { _bindings[Keyboard.BACKSPACE] = value; }
		
		public function get capslock():Function { return _bindings[Keyboard.CAPS_LOCK]; }
		public function set capslock(value:Function):void { _bindings[Keyboard.CAPS_LOCK] = value; }
		
		public function get control():Function { return _bindings[Keyboard.CONTROL]; }
		public function set control(value:Function):void { _bindings[Keyboard.CONTROL] = value; }
		
		public function get del():Function { return _bindings[Keyboard.DELETE]; }
		public function set del(value:Function):void { _bindings[Keyboard.DELETE] = value; }
		
		public function get down():Function { return _bindings[Keyboard.DOWN]; }
		public function set down(value:Function):void { _bindings[Keyboard.DOWN] = value; }
		
		public function get end():Function { return _bindings[Keyboard.END]; }
		public function set end(value:Function):void { _bindings[Keyboard.END] = value; }
		
		public function get enter():Function { return _bindings[Keyboard.ENTER]; }
		public function set enter(value:Function):void { _bindings[Keyboard.ENTER] = value; }
		
		public function get escape():Function { return _bindings[Keyboard.ESCAPE]; }
		public function set escape(value:Function):void { _bindings[Keyboard.ESCAPE] = value; }
		
		public function get f1():Function { return _bindings[Keyboard.F1]; }
		public function set f1(value:Function):void { _bindings[Keyboard.F1] = value; }
		
		public function get f2():Function { return _bindings[Keyboard.F2]; }
		public function set f2(value:Function):void { _bindings[Keyboard.F2] = value; }
		
		public function get f3():Function { return _bindings[Keyboard.F3]; }
		public function set f3(value:Function):void { _bindings[Keyboard.F3] = value; }
		
		public function get f4():Function { return _bindings[Keyboard.F4]; }
		public function set f4(value:Function):void { _bindings[Keyboard.F4] = value; }
		
		public function get f5():Function { return _bindings[Keyboard.F5]; }
		public function set f5(value:Function):void { _bindings[Keyboard.F5] = value; }
		
		public function get f6():Function { return _bindings[Keyboard.F6]; }
		public function set f6(value:Function):void { _bindings[Keyboard.F6] = value; }
		
		public function get f7():Function { return _bindings[Keyboard.F7]; }
		public function set f7(value:Function):void { _bindings[Keyboard.F7] = value; }
		
		public function get f8():Function { return _bindings[Keyboard.F8]; }
		public function set f8(value:Function):void { _bindings[Keyboard.F8] = value; }
		
		public function get f9():Function { return _bindings[Keyboard.F9]; }
		public function set f9(value:Function):void { _bindings[Keyboard.F9] = value; }
		
		public function get f10():Function { return _bindings[Keyboard.F10]; }
		public function set f10(value:Function):void { _bindings[Keyboard.F10] = value; }
		
		public function get f11():Function { return _bindings[Keyboard.F11]; }
		public function set f11(value:Function):void { _bindings[Keyboard.F11] = value; }
		
		public function get f12():Function { return _bindings[Keyboard.F12]; }
		public function set f12(value:Function):void { _bindings[Keyboard.F12] = value; }
		
		public function get home():Function { return _bindings[Keyboard.HOME]; }
		public function set home(value:Function):void { _bindings[Keyboard.HOME] = value; }
		
		public function get insert():Function { return _bindings[Keyboard.INSERT]; }
		public function set insert(value:Function):void { _bindings[Keyboard.INSERT] = value; }
		
		public function get left():Function { return _bindings[Keyboard.LEFT]; }
		public function set left(value:Function):void { _bindings[Keyboard.LEFT] = value; }
		
		public function get numpad0():Function { return _bindings[Keyboard.NUMPAD_0]; }
		public function set numpad0(value:Function):void { _bindings[Keyboard.NUMPAD_0] = value; }
		
		public function get numpad1():Function { return _bindings[Keyboard.NUMPAD_1]; }
		public function set numpad1(value:Function):void { _bindings[Keyboard.NUMPAD_1] = value; }
		
		public function get numpad2():Function { return _bindings[Keyboard.NUMPAD_2]; }
		public function set numpad2(value:Function):void { _bindings[Keyboard.NUMPAD_2] = value; }
		
		public function get numpad3():Function { return _bindings[Keyboard.NUMPAD_3]; }
		public function set numpad3(value:Function):void { _bindings[Keyboard.NUMPAD_3] = value; }
		
		public function get numpad4():Function { return _bindings[Keyboard.NUMPAD_4]; }
		public function set numpad4(value:Function):void { _bindings[Keyboard.NUMPAD_4] = value; }
		
		public function get numpad5():Function { return _bindings[Keyboard.NUMPAD_5]; }
		public function set numpad5(value:Function):void { _bindings[Keyboard.NUMPAD_5] = value; }
		
		public function get numpad6():Function { return _bindings[Keyboard.NUMPAD_6]; }
		public function set numpad6(value:Function):void { _bindings[Keyboard.NUMPAD_6] = value; }
		
		public function get numpad7():Function { return _bindings[Keyboard.NUMPAD_7]; }
		public function set numpad7(value:Function):void { _bindings[Keyboard.NUMPAD_7] = value; }
		
		public function get numpad8():Function { return _bindings[Keyboard.NUMPAD_8]; }
		public function set numpad8(value:Function):void { _bindings[Keyboard.NUMPAD_8] = value; }
		
		public function get numpad9():Function { return _bindings[Keyboard.NUMPAD_9]; }
		public function set numpad9(value:Function):void { _bindings[Keyboard.NUMPAD_9] = value; }
				
		public function get pagedown():Function { return _bindings[Keyboard.PAGE_DOWN]; }
		public function set pagedown(value:Function):void { _bindings[Keyboard.PAGE_DOWN] = value; }
		
		public function get pageup():Function { return _bindings[Keyboard.PAGE_UP]; }
		public function set pageup(value:Function):void { _bindings[Keyboard.PAGE_UP] = value; }
		
		public function get right():Function { return _bindings[Keyboard.RIGHT]; }
		public function set right(value:Function):void { _bindings[Keyboard.RIGHT] = value; }
		
		public function get shift():Function { return _bindings[Keyboard.SHIFT]; }
		public function set shift(value:Function):void { _bindings[Keyboard.SHIFT] = value; }
		
		public function get space():Function { return _bindings[Keyboard.SPACE]; }
		public function set space(value:Function):void { _bindings[Keyboard.SPACE] = value; }
		
		public function get tab():Function { return _bindings[Keyboard.TAB]; }
		public function set tab(value:Function):void { _bindings[Keyboard.TAB] = value; }
		
		public function get up():Function { return _bindings[Keyboard.UP]; }
		public function set up(value:Function):void { _bindings[Keyboard.UP] = value; }
		
		public function get num0():Function { return _bindings["0".charCodeAt()]; }
		public function set num0(value:Function):void { _bindings["0".charCodeAt()] = value; }
		
		public function get num1():Function { return _bindings["1".charCodeAt()]; }
		public function set num1(value:Function):void { _bindings["1".charCodeAt()] = value; }
		
		public function get num2():Function { return _bindings["2".charCodeAt()]; }
		public function set num2(value:Function):void { _bindings["2".charCodeAt()] = value; }
		
		public function get num3():Function { return _bindings["3".charCodeAt()]; }
		public function set num3(value:Function):void { _bindings["3".charCodeAt()] = value; }
		
		public function get num4():Function { return _bindings["4".charCodeAt()]; }
		public function set num4(value:Function):void { _bindings["4".charCodeAt()] = value; }
		
		public function get num5():Function { return _bindings["5".charCodeAt()]; }
		public function set num5(value:Function):void { _bindings["5".charCodeAt()] = value; }
		
		public function get num6():Function { return _bindings["6".charCodeAt()]; }
		public function set num6(value:Function):void { _bindings["6".charCodeAt()] = value; }
		
		public function get num7():Function { return _bindings["7".charCodeAt()]; }
		public function set num7(value:Function):void { _bindings["7".charCodeAt()] = value; }
		
		public function get num8():Function { return _bindings["8".charCodeAt()]; }
		public function set num8(value:Function):void { _bindings["8".charCodeAt()] = value; }
		
		public function get num9():Function { return _bindings["9".charCodeAt()]; }
		public function set num9(value:Function):void { _bindings["9".charCodeAt()] = value; }
		
		public function get a():Function { return _bindings["a".charCodeAt()]; }
		public function set a(value:Function):void { _bindings["a".charCodeAt()] = value; }
		
		public function get b():Function { return _bindings["b".charCodeAt()]; }
		public function set b(value:Function):void { _bindings["b".charCodeAt()] = value; }
		
		public function get c():Function { return _bindings["c".charCodeAt()]; }
		public function set c(value:Function):void { _bindings["c".charCodeAt()] = value; }
		
		public function get d():Function { return _bindings["d".charCodeAt()]; }
		public function set d(value:Function):void { _bindings["d".charCodeAt()] = value; }
		
		public function get e():Function { return _bindings["e".charCodeAt()]; }
		public function set e(value:Function):void { _bindings["e".charCodeAt()] = value; }
		
		public function get f():Function { return _bindings["f".charCodeAt()]; }
		public function set f(value:Function):void { _bindings["f".charCodeAt()] = value; }
		
		public function get g():Function { return _bindings["g".charCodeAt()]; }
		public function set g(value:Function):void { _bindings["g".charCodeAt()] = value; }
		
		public function get h():Function { return _bindings["h".charCodeAt()]; }
		public function set h(value:Function):void { _bindings["h".charCodeAt()] = value; }
		
		public function get i():Function { return _bindings["i".charCodeAt()]; }
		public function set i(value:Function):void { _bindings["i".charCodeAt()] = value; }
		
		public function get j():Function { return _bindings["j".charCodeAt()]; }
		public function set j(value:Function):void { _bindings["j".charCodeAt()] = value; }
		
		public function get k():Function { return _bindings["k".charCodeAt()]; }
		public function set k(value:Function):void { _bindings["k".charCodeAt()] = value; }
		
		public function get l():Function { return _bindings["l".charCodeAt()]; }
		public function set l(value:Function):void { _bindings["l".charCodeAt()] = value; }
		
		public function get m():Function { return _bindings["m".charCodeAt()]; }
		public function set m(value:Function):void { _bindings["m".charCodeAt()] = value; }
		
		public function get n():Function { return _bindings["n".charCodeAt()]; }
		public function set n(value:Function):void { _bindings["n".charCodeAt()] = value; }
		
		public function get o():Function { return _bindings["o".charCodeAt()]; }
		public function set o(value:Function):void { _bindings["o".charCodeAt()] = value; }
		
		public function get p():Function { return _bindings["p".charCodeAt()]; }
		public function set p(value:Function):void { _bindings["p".charCodeAt()] = value; }
		
		public function get q():Function { return _bindings["q".charCodeAt()]; }
		public function set q(value:Function):void { _bindings["q".charCodeAt()] = value; }
		
		public function get r():Function { return _bindings["r".charCodeAt()]; }
		public function set r(value:Function):void { _bindings["r".charCodeAt()] = value; }
		
		public function get s():Function { return _bindings["s".charCodeAt()]; }
		public function set s(value:Function):void { _bindings["s".charCodeAt()] = value; }
		
		public function get t():Function { return _bindings["t".charCodeAt()]; }
		public function set t(value:Function):void { _bindings["t".charCodeAt()] = value; }
		
		public function get u():Function { return _bindings["u".charCodeAt()]; }
		public function set u(value:Function):void { _bindings["u".charCodeAt()] = value; }
		
		public function get v():Function { return _bindings["v".charCodeAt()]; }
		public function set v(value:Function):void { _bindings["v".charCodeAt()] = value; }
		
		public function get w():Function { return _bindings["w".charCodeAt()]; }
		public function set w(value:Function):void { _bindings["w".charCodeAt()] = value; }
		
		public function get x():Function { return _bindings["x".charCodeAt()]; }
		public function set x(value:Function):void { _bindings["x".charCodeAt()] = value; }
		
		public function get y():Function { return _bindings["y".charCodeAt()]; }
		public function set y(value:Function):void { _bindings["y".charCodeAt()] = value; }
		
		public function get z():Function { return _bindings["z".charCodeAt()]; }
		public function set z(value:Function):void { _bindings["z".charCodeAt()] = value; }
		
		public function get minus():Function { return _bindings["-".charCodeAt()]; }
		public function set minus(value:Function):void { _bindings["-".charCodeAt()] = value; }
		
		public function get plus():Function { return _bindings["+".charCodeAt()]; }
		public function set plus(value:Function):void { _bindings["+".charCodeAt()] = value; }
				
		// more mappings to do later if required.
				
		public function CCKeyboardBindingsGroup()
		{
			
		}
		
		public function getBoundFunction(key:Object):Function
		{
			if (key is String)
			{
				var keycode:uint = (key as String).charCodeAt();
				if (_bindings.hasOwnProperty(keycode))
				{
					return _bindings[key] as Function;
				}
			}
			
			return _bindings[key] as Function;
		}
		
	}
}