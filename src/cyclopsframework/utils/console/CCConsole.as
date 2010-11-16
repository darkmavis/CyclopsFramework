package cyclopsframework.utils.console
{
	import cyclopsframework.core.CCAction;
	import cyclopsframework.core.CCEngine;
	import cyclopsframework.core.ICCTaggable;
	import cyclopsframework.game.CCScene;
	import cyclopsframework.game.bindings.CCKeyboardBindingsGroup;
	import cyclopsframework.utils.collections.CCStringHashSet;
	import cyclopsframework.utils.color.CCColor;
	import cyclopsframework.utils.math.CCMath;
	import cyclopsframework.utils.primitives.CCPrimitives;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataUtils;
	
	import r1.deval.D;
	
	public class CCConsole extends CCScene
	{
		public static const TAG:String = "@CCConsole";
		
		public static const CHANNEL_DEFAULT:String = "default";
		public static const CHANNEL_ERRORS:String = "errors";
		public static const CHANNEL_WARNINGS:String = "warnings";
						
		private var _tf:TextField;
		private var _buffer:String = "";
		private var _input:String = "";
		private var _backdrop:Sprite;
		private var _channels:CCStringHashSet = new CCStringHashSet();
		
		private var _dirty:Boolean = true;
		private var _bottomV:int = 0;
		
		private var _prompt:String = ">";
		public function get prompt():String { return _prompt; }
		public function set prompt(value:String):void { _prompt = value; _dirty = true;}
		
		private var _cursor:String = "_";
		public function get cursor():String { return _cursor; }
		public function set cursor(value:String):void { _cursor = value; _dirty = true;}
		
		private var _cursorVisible:Boolean = true;
		
		private var _history:Vector.<String> = new Vector.<String>();
		
		private var _commands:Object = {};
		public function get commands():Object { return _commands; }
		
		private var _scriptingContext:Object = {};
		public function get scriptingContext():Object { return _scriptingContext; }
		
		private var _active:Boolean = true;
		
		private var _locked:Boolean = false;
		
		public function CCConsole(width:Number, height:Number)
		{
			super(TAG);
			
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("Courier New", 14, 0xA0A0A0);
			_tf.text = "X";
			_tf.width = width - width % _tf.textWidth;
			_tf.height = height - height % _tf.textHeight;
			_tf.text = "";
			_tf.wordWrap = true;
			_tf.multiline = true;
			_tf.cacheAsBitmap = true;
		
			_channels.addItems([CHANNEL_DEFAULT, CHANNEL_ERRORS, CHANNEL_WARNINGS]);
		}
				
		protected override function onEnter():void
		{
			if (_locked) return;
			
			_backdrop = CCPrimitives.filledBox(_tf.width, _tf.height, 0, .9);
			addSprite(_backdrop, _tf.width / 2, _tf.height / 2);
			bg.addChild(_tf);
			
			D.setOutput(print);
			
			var _historyIndex:int = 0;
			
			// this handler isn't cleaned up, but likely doesn't need to be.
			bg.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
			{
				if (_locked) return;
				
				if (e.keyCode == Keyboard.ESCAPE)
				{
					if (!_active)
					{
						show();
					}
					else
					{
						hide();
					}
				}
			});
			
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_UP, Number.MAX_VALUE, Number.MAX_VALUE, function(e:KeyboardEvent):void
			{
				if ((e.charCode >= 32) && (e.charCode <= 255)
					|| (e.keyCode == Keyboard.ENTER)
					|| ((e.keyCode == Keyboard.DELETE) || (e.keyCode == Keyboard.BACKSPACE))
					|| (e.keyCode == Keyboard.UP)
					|| (_history.length > 0))
				{
					_dirty = true;
				}
			});
			
			engine.waitForEvent(bg.stage, KeyboardEvent.KEY_DOWN, Number.MAX_VALUE, Number.MAX_VALUE, function(e:KeyboardEvent):void
			{
				if ((e.charCode >= 32) && (e.charCode <= 255))
				{
					_input += (String.fromCharCode(e.charCode));
					_dirty = true;
				}
				else if (e.keyCode == Keyboard.ENTER)
				{
					processCommand(_input);
					if (_input.length > 0)
					{
						if (_history.length > 0)
						{
							if (_history[_history.length - 1] != _input)
							{
								_history.push(_input);
							}
						}
						else
						{
							_history.push(_input);
						}
					}
					_historyIndex = 0;
					_input = "";
					_dirty = true;
				}
				else if ((e.keyCode == Keyboard.DELETE) || (e.keyCode == Keyboard.BACKSPACE))
				{
					if (_input.length > 0)
					{
						_input = _input.slice(0, _input.length - 1);
						_dirty = true;
					}
				}
				else if (e.keyCode == Keyboard.UP)
				{
					if (_history.length > 0)
					{
						--_historyIndex;
						_input = _history[CCMath.wrap(_historyIndex, _history.length)];
					}
					_dirty = true;
				}
				else if (e.keyCode == Keyboard.DOWN)
				{
					if (_history.length > 0)
					{
						++_historyIndex;
						_input = _history[CCMath.wrap(_historyIndex, _history.length)];
					}
					_dirty = true;
				}
					
			});
			
			engine.loop(function():void
			{
				if (_dirty && bg.visible && (bg.parent != null))
				{
					_dirty = false;
					redraw();
				}
			});
			
			engine.loop(function():void
			{
				if (_tf.scrollV >= _bottomV)
				{
					_cursorVisible = !_cursorVisible;
					_dirty = true;
				}
			}, .5, Number.MAX_VALUE);
			
			// setup console commands and functions
			
			importConsoleCommands(this);
			
			commands["fps"] = { help:"display frame rate", method:function():void
			{
				println("" + int(engine.fps));
			}};
									
		}
						
		public function processCommand(command:String):void
		{
			var args:Array = command.split(" ");
			var cmd:String = args[0];
			
			if (args.length > 1)
			{
				args = args.slice(1);
			}
			else
			{
				args = null;
			}
			
			try
			{
				if (commands.hasOwnProperty(cmd))
				{
					var cmdo:Object = commands[cmd];
					if (cmdo.hasOwnProperty("method") && (cmdo.method is Function))
					{
						println(prompt + command);
						(cmdo.method as Function).apply(null, args);
					}
				}
				else if (cmd == "")
				{
					println(prompt);
				}
				else
				{
					println(prompt + command);
					var result:Object = D.eval(command, _scriptingContext, _scriptingContext);
					if (result != null)
					{
						println("" + result);
					}
				}
			}
			catch(e:Error)
			{
				println(e.toString());
			}
		}
		
		public function redraw():void
		{
			_tf.text = _buffer + _prompt + (_cursorVisible ? _input + _cursor : _input + " ");
			_tf.scrollV = _tf.numLines - 1;
			_bottomV = _tf.scrollV;
		}
		
		public function print(text:String="", channel:String=CCConsole.CHANNEL_DEFAULT):void
		{
			if (_channels.has(channel))
			{
				_buffer += text;
				_dirty = true;
			}
		}
		
		public function println(text:String="", channel:String=CCConsole.CHANNEL_DEFAULT):void
		{
			print(text + "\n", channel);
		}
		
		public function lock():void
		{
			_locked = true;
		}
		
		public function importConsoleCommands(source:Object):void
		{
			var desc:XML = flash.utils.describeType(source);
			for each (var methodData:* in desc.method.(hasOwnProperty("metadata") && metadata.attribute("name").contains("ConsoleCommand")))
			{
				var methodName:String = methodData.@name;
				var helpText:String = "" + methodData.metadata.arg.(@key=="help").@value;
				var syntaxText:String = "" + methodData.metadata.arg.(@key=="syntax").@value;
				
				_commands[methodName] = {method:this[methodName]};
				
				if (helpText.length > 0)
				{
					_commands[methodName].help = helpText;
				}
				
				if (syntaxText.length > 0)
				{
					_commands[methodName].syntax = syntaxText;
				}
			}
		}
		
		[ConsoleCommand(help="display help")]
		public function help():void
		{
			println("console commands:\n");
			
			for (var cmdName:String in commands)
			{
				println(cmdName + "\t\t\t" + ((cmdName.length < 4) ? "\t" : "") + commands[cmdName].help);
				if (commands[cmdName].hasOwnProperty("syntax"))
				{
					println("\t\t\t\t" + commands[cmdName].syntax);
				}
			}
			
			println("\nconsole functions:\n");
			
			for (var fname:String in _scriptingContext)
			{
				if (_scriptingContext[fname] is Function)
				{
					print(fname + " ");
				}
			}
			
			println();
		}
		
		[ConsoleCommand(help="enable channels", syntax="enable <channel1 [channel2 ...]>")]
		public function enable(...channels):void
		{
			_channels.addItems(channels);
		}
		
		[ConsoleCommand(help="disable channels", syntax="disable <channel1 [channel2 ...]>")]
		public function disable(...channels):void
		{
			_channels.removeItems(channels);
		}
		
		[ConsoleCommand(help="toggle channels", syntax="toggle <channel1 [channel2 ...]>")]
		public function toggle(...channels):void
		{
			for each (var channel:String in channels)
			{
				if (_channels.has(channel))
				{
					_channels.removeItem(channel);
				}
				else
				{
					_channels.addItem(channel);
				}
			}
		}
		
		[ConsoleCommand(help="clear screen")]
		public function cls():void
		{
			_buffer = "";
			_dirty = true;
		}
		
		[ConsoleCommand(help="show console")]
		public function show():void
		{
			_active = true;
			bg.visible = true;
			engine.resume(CCEngine.TAG_ALL);
		}
		
		[ConsoleCommand(help="hide console")]
		public function hide():void
		{
			_active = false;
			bg.visible = false;
			engine.pause(CCEngine.TAG_ALL);
		}
						
	}
}