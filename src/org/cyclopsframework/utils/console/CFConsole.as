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

package org.cyclopsframework.utils.console
{
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.game.CFScene;
	import org.cyclopsframework.utils.collections.CFStringHashSet;
	import org.cyclopsframework.utils.logging.CFLog;
	import org.cyclopsframework.utils.logging.ICFLogger;
	import org.cyclopsframework.utils.math.CFMath;
	import org.cyclopsframework.utils.misc.CFUtils;
	import org.cyclopsframework.utils.primitives.CFPrimitives;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	import r1.deval.D;
	
	/**
	 * CFConsole is an extendable, scriptable console, designed to integrate well with CyclopsFramework or work equally well in stand-alone mode.<br/>
	 * The console supports AS3 scripting via the D.eval library.<br/>
	 * <a href="http://www.riaone.com/products/deval/">http://www.riaone.com/products/deval/</a>
	 * <p>
	 * Integrated mode example:<br/><listing>
	 * var console:CFConsole = new CFConsole(800, 600);<br/>
	 * scene.addScene(console);<br/>
	 * // An integrated option for using the console when it becomes ready.<br/>
	 * console.engine.add(function():void { console.println("Hello World!"); });
	 * </listing></p>
	 * <p>
	 * Stand-alone mode example:<br/><listing>
	 * var console:CFConsole = new CFConsole(800, 600);<br/>
	 * console.manualStart(this);<br/>
	 * // The integrated option will work here, but some unfamiliar with CyclopsFramework may prefer using this instead.<br/>
	 * console.addEventListener(CFScene.EVENT_SCENE_READY, function(e:Event):void { console.println("Hello World!"); });<br/>
	 * </listing></p>
	 * <p>
	 * CFGame mode example:<br/><listing>
	 * // Assumes that a public static property 'game' (of type MyGame) exists in this hypothetical CFGame subclass, MyGame.<br/>
	 * // Using CFGame is a great way to go if you are starting from scratch.<br/>
	 * MyGame.game.console.println("Hello World!");
	 * </listing></p>
	 * 
	 * @author Mark Davis
	 * 
	 */
	public class CFConsole extends CFScene implements ICFLogger
	{
		public static const TAG:String = "@CFConsole";
		
		public static const CHANNEL_DEFAULT:String = CFLog.CHANNEL_DEFAULT;
		public static const CHANNEL_INFO:String = CFLog.CHANNEL_INFO;
		public static const CHANNEL_WARNINGS:String = CFLog.CHANNEL_WARNINGS;
		public static const CHANNEL_ERRORS:String = CFLog.CHANNEL_ERRORS;
						
		private var _tf:TextField;
		private var _buffer:String = "";
		private var _input:String = "";
		private var _channels:CFStringHashSet = new CFStringHashSet();
		
		private var _dirty:Boolean = true;
		private var _bottomV:int = 0;
		
		private var _prompt:String = ">";
		
		private var _controlStack:Vector.<CFConsoleControlMode> = new Vector.<CFConsoleControlMode>();
		protected function get activeControlMode():CFConsoleControlMode { return _controlStack.slice(-1)[0]; }
		
		private var _backdrop:Sprite;
		public function get backdrop():Sprite { return _backdrop; }
		
		/**
		 * Current command prompt.
		 * @return String
		 * 
		 */		
		public function get prompt():String { return _prompt; }
		
		/**
		 * @private
		 */	
		public function set prompt(value:String):void { _prompt = value; _dirty = true;}
		
		private var _cursor:String = "_";
		
		/**
		 * Current console cursor.<br/>
		 * The default cursor is: _
		 * @return String
		 * 
		 */		
		public function get cursor():String { return _cursor; }
		
		/**
		 * @private
		 */	
		public function set cursor(value:String):void { _cursor = value; _dirty = true;}
		
		private var _cursorVisible:Boolean = true;
		
		private var _history:Vector.<String> = new Vector.<String>();
		
		private var _commands:Object = {};
		
		/**
		 * Add objects to <code>commands</code> in order to extend the console's functionality.<p>
		 * Example:<br/>
		 * <listing>console.commands["fps"] = { help:"display fps", method:function():void<br/>
		 * {<br/>
		 *     println("" + int(engine.fps));<br/>
		 * }};</listing></p>
		 * See <code>importConsoleCommands</code> and the <code>[ConsoleCommand(...)]</code> metatag for more options.
		 * @return Object
		 * 
		 */		
		public function get commands():Object { return _commands; }
		
		private var _scriptingContext:Object = {};
		
		/**
		 * This is the global or root object referenced by the scripting engine.<br/>
		 * Add objects to <code>scriptingContext</code> in order to make them available to the interpreter.
		 * @return Object
		 * 
		 */		
		public function get scriptingContext():Object { return _scriptingContext; }
		
		private var _active:Boolean = true;
		
		private var _locked:Boolean = false;
		
		/**
		 * CFConsole is an extendable, scriptable console, designed to integrate well with CyclopsFramework or work equally well in stand-alone mode.<br>
		 * The console supports AS3 scripting via the D.eval library.<br/>
		 * <a href="http://www.riaone.com/products/deval/">http://www.riaone.com/products/deval/</a>
		 * @param width Number of pixels wide.
		 * @param height Number of pixels high.
		 * 
		 */
		public function CFConsole(width:Number, height:Number)
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
						
			_backdrop = CFPrimitives.filledBox(_tf.width, _tf.height, 0, .9);
		
			_channels.addItems([CHANNEL_DEFAULT, CHANNEL_INFO, CHANNEL_WARNINGS, CHANNEL_ERRORS]);
			
			enterControlMode(new CFConsoleControlMode(">", "_", processCommand));
			
			// setup console commands and functions
			
			importConsoleCommands(this);
			
			commands["fps"] = { help:"display frame rate", method:function():void
			{
				println("" + int(engine.fps));
			}};
			
			scriptingContext.print = println;
			
		}
				
		/**
		 * @private Main initialization method.
		 */	
		protected override function onEnter():void
		{
			if (_locked) return;
			
			addSprite(_backdrop, _tf.width / 2, _tf.height / 2);
			bg.addChild(_tf);
			
			bg.tabEnabled = false;
			bg.tabIndex = -1;
			
			_tf.tabEnabled = false;
			_tf.tabIndex = -1;
			
			backdrop.tabEnabled = false;
			backdrop.tabIndex = -1;
			
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
				if ((_tf.stage.focus != _tf) && (_tf.stage.focus != _tf.parent) && (_tf.stage.focus != _backdrop)) return;
				
				if (e.ctrlKey)
				{
					if (e.charCode == "z".charCodeAt(0))
					{
						exitControlMode();
					}
					return;
				}
				
				if ((e.charCode >= 32) && (e.charCode <= 255))
				{
					_input += (String.fromCharCode(e.charCode));
					_dirty = true;
				}
				else if (e.keyCode == Keyboard.ENTER)
				{
					activeControlMode.controlFunction(_input);
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
						_input = _history[CFMath.wrap(_historyIndex, _history.length)];
					}
					_dirty = true;
				}
				else if (e.keyCode == Keyboard.DOWN)
				{
					if (_history.length > 0)
					{
						++_historyIndex;
						_input = _history[CFMath.wrap(_historyIndex, _history.length)];
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
				if ((_tf.stage.focus == _tf) || (_tf.stage.focus == _tf.parent) || (_tf.stage.focus == _backdrop))
				{
					if (_tf.scrollV >= _bottomV)
					{
						_cursorVisible = !_cursorVisible;
						_dirty = true;
					}
				}
				else
				{
					_cursorVisible = false;
					_dirty = true;
				}
			}, .5, Number.MAX_VALUE);
												
		}
		
		public function resize(width:Number, height:Number):void
		{
			_tf.defaultTextFormat = new TextFormat("Courier New", 14, 0xA0A0A0);
			_tf.text = "X";
			_tf.width = width - width % _tf.textWidth;
			_tf.height = height - height % _tf.textHeight;
			_tf.text = "";
			
			if (_backdrop.parent != null)
			{
				_backdrop.parent.removeChild(_backdrop);
			}
			
			_backdrop = CFPrimitives.filledBox(_tf.width, _tf.height, 0, .5);
			addSprite(_backdrop, _tf.width / 2, _tf.height / 2);
			
			redraw();
		}
		
		public function enterControlMode(controlMode:CFConsoleControlMode):void
		{
			_controlStack.push(controlMode);
			prompt = activeControlMode.defaultPrompt;
			cursor = activeControlMode.defaultCursor;
		}
		
		public function exitControlMode():void
		{
			if (_controlStack.length > 1)
			{
				_controlStack.pop();
				prompt = activeControlMode.defaultPrompt;
				cursor = activeControlMode.defaultCursor;
			}
		}
						
		/**
		 * Force the console to process a command, script or expression.<br/>
		 * This is typically used internally by the console as input is submitted, but may be useful for other purposes.
		 * @param command Command, script or expression.
		 * 
		 */
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
						// if exactly 1 arg is expected, then ignore spaces for functions that may want to accept a string with spaces.
						var argc:int = (cmdo.method as Function).length;
						if (argc == 1)
						{
							args = [args.join(" ")];
						}
						
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
		
		/**
		 * Force an immediate redraw of all text in the console. View will instantly scroll to the prompt.<br/>
		 * This is typically used internally.
		 */
		public function redraw():void
		{
			_tf.text = _buffer + _prompt + (_cursorVisible ? _input + _cursor : _input + " ");
			_tf.scrollV = _tf.numLines - 1;
			_bottomV = _tf.scrollV;
		}
		
		/**
		 * Print text to the console without a new line. Optionally specify a channel for filtering purposes.
		 * Built-in channels include:<br/><listing>
		 * public static const CHANNEL_DEFAULT:String = "default";<br/>
		 * public static const CHANNEL_ERRORS:String = "errors";<br/>
		 * public static const CHANNEL_WARNINGS:String = "warnings";</listing>
		 * @param text Source text.
		 * @param channel Target channel.
		 * 
		 */
		public function print(text:Object="", channel:String=CFConsole.CHANNEL_DEFAULT):void
		{
			if (_channels.has(channel))
			{
				_buffer += String(text);
				_dirty = true;
			}
		}
		
		/**
		 * Print text to the console with a new line appended. Optionally specify a channel for filtering purposes.
		 * Built-in channels include:<br/><listing>
		 * public static const CHANNEL_DEFAULT:String = "default";<br/>
		 * public static const CHANNEL_ERRORS:String = "errors";<br/>
		 * public static const CHANNEL_WARNINGS:String = "warnings";</listing>
		 * @param text Source text.
		 * @param channel Target channel.
		 * 
		 */
		public function println(text:Object="", channel:String=CFConsole.CHANNEL_DEFAULT):void
		{
			print(String(text) + "\n", channel);
		}
		
		/**
		 * Lock console to prevent use in production environments. Alternatively, if used in stand-alone mode, just don't include it at all.<br/>
		 * This method is intended for framework use, where the console may be built-in.
		 */
		public function lock():void
		{
			_locked = true;
		}
		
		public function eval(...args):*
		{
			var head:Object = args[0];
			var tail:Array = (args.length < 2) ? null : args.slice(1);
			
			if (commands.hasOwnProperty(head))
			{
				return (commands[head].method as Function).apply(scriptingContext, tail);
			}
			else
			{
				try
				{
					var result:* = D.eval(args[0], scriptingContext, scriptingContext);
					if (result != null) return result;
				}
				catch(e:Error)
				{
					println(e.toString(), CFConsole.CHANNEL_ERRORS);
				}
			}
		}
		
		/**
		 * Auto-import console commands from any object using the <code>[ConsoleCommand(...)]</code> metatag.<br/>
		 * Any method using the <code>[ConsoleCommand(...)]</code> metatag will be imported and added to the help command.<br/>
		 * Help description and syntax attributes are optionally available and recommended for clarity.<p>
		 * Example:<br/>
		 * <listing>[ConsoleCommand(help="enable channels", syntax="enable &lt;channel1 [channel2 ...]&gt;")]<br/>
		 * public function enable(...channels):void { ... }<br/>
		 * </listing></p>
		 * @param source Any object providing the appropriate metadata.
		 * 
		 */
		public function importConsoleCommands(source:Object):void
		{
			var desc:XML = flash.utils.describeType(source);
			for each (var methodData:* in desc.method.(hasOwnProperty("metadata") && metadata.attribute("name").contains("ConsoleCommand")))
			{
				var methodName:String = methodData.@name;
				var helpText:String = "" + methodData.metadata.arg.(@key=="help").@value;
				var syntaxText:String = "" + methodData.metadata.arg.(@key=="syntax").@value;
				
				_commands[methodName] = {method:source[methodName]};
				
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
		/**
		 * Display a list of console commands providing name, help description and syntax as available.<br/>
		 * Note: Also a built-in console command.
		 */
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
			
			println("\n");
		}
		
		[ConsoleCommand(help="enable channels", syntax="enable <channel1 [channel2 ...]>")]
		/**
		 * Enable (or create) an output channel used by <code>print</code> and <code>println</code>.<br/>
		 * <code>print</code> and <code>println</code> will not output text if a specified channel doesn't exist or is disabled.<br/>
		 * Note: Also a built-in console command.
		 * @param channels Channel names.
		 * 
		 */
		public function enable(...channels):void
		{
			_channels.addItems(channels);
		}
		
		[ConsoleCommand(help="disable channels", syntax="disable <channel1 [channel2 ...]>")]
		/**
		 * Disable an existing output channel used by <code>print</code> and <code>println</code>.<br/>
		 * <code>print</code> and <code>println</code> will not output text if a specified channel doesn't exist or is disabled.<br/>
		 * Note: Also a built-in console command.
		 * @param channels Channel names.
		 * 
		 */
		public function disable(...channels):void
		{
			_channels.removeItems(channels);
		}
		
		[ConsoleCommand(help="toggle channels", syntax="toggle <channel1 [channel2 ...]>")]
		/**
		 * Enable channel if currently disabled or disable if currently enabled.<br/>
		 * The output channel is used by <code>print</code> and <code>println</code>.<br/>
		 * <code>print</code> and <code>println</code> will not output text if a specified channel doesn't exist or is disabled.<br/>
		 * Note: Also a built-in console command.
		 * @param channels Channel names.
		 * 
		 */
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
		/**
		 * Clear all text. Does not clear the command history.
		 * Note: Also a built-in console command.
		 */
		public function cls():void
		{
			_buffer = "";
			_dirty = true;
		}
		
		/**
		 * Show the console.
		 */
		public function show():void
		{
			engine.add(function():void
			{
				_tf.stage.focus = _tf;
			});
			_active = true;
			bg.visible = true;
			engine.resume(CFEngine.TAG_ALL);
		}
		
		[ConsoleCommand(help="hide console")]
		/**
		 * Hide the console. This also pauses the console and thus provides a small performance boost as well.
		 * Note: Also a built-in console command.
		 */
		public function hide():void
		{
			_active = false;
			bg.visible = false;
			engine.pause(CFEngine.TAG_ALL);
		}
						
	}
}