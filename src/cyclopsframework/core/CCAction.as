package cyclopsframework.core
{
	import cyclopsframework.actions.flow.CCFunction;
	import cyclopsframework.actions.flow.CCSleep;
	import cyclopsframework.core.easing.CCBias;
	import cyclopsframework.utils.collections.CCStringHashSet;

	public class CCAction implements ICCPausable, ICCTaggable
	{
		public static const TAGS_UNDEFINED:String = "@__undefined__";
		
		private var _bias:Function;
		private var _cycle:Number = 0;
		private var _cycles:Number = 1;
		
		private var _period:Number = 0;
		public function get period():Number { return _period; }
		
		private var _position:Number = 0;
		public function get cycle():Number { return _cycle; }
		
		private var _speed:Number = 1;
		public function get cycles():Number { return _cycles; }
		
		public function get position():Number { return ((_position - _cycle) >= 1) ? 1 : (_position - _cycle);}
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void { _speed = value; }
		
		private var _dataPipe:Array = [];
		public function get dataPipe():Array { return _dataPipe; }
		
		private var _tags:CCStringHashSet = new CCStringHashSet();
		public function get tags():CCStringHashSet { return _tags; }
		
		private var _paused:Boolean = false;
		public function get paused():Boolean { return _paused; }
		public function set paused(value:Boolean):void { _paused = value; }
		
		private var _children:Array = [];
		public function get children():Array { return _children; }
		
		private var _active:Boolean = true;
		public function get isActive():Boolean { return _active; }
		
		private var _engine:CCEngine;
		public function get engine():CCEngine { return _engine; }
		public function set engine(value:CCEngine):void { _engine = value; }
		
		public function CCAction(period:Number=0, cycles:Number=1, bias:Function=null, tags:Array=null)
		{
			_cycles = cycles;
			_period = period;
			_bias = (bias == null) ? CCBias.linear : bias;
			if (tags == null)
			{
				addTags([CCAction.TAGS_UNDEFINED]);
			}
			else
			{
				addTags(tags);
			}
		}
		
		public function removeChildren():void
		{
			_children = [];
		}
		
		public function add(child:CCAction, tags:Array=null):CCAction
		{
			child.addTags(tags);
			_children.push(child);
			
			return child;
		}
		
		public function addf(f:Function, thisObject:Object=null, data:Array=null):CCAction
		{
			return add(new CCFunction(0, 1, thisObject, data, f));
		}
		
		public function loop(f:Function):CCAction
		{
			return add(new CCFunction(0, Number.MAX_VALUE, null, null, f));
		}
		
		public function nop():CCAction
		{
			return add(new CCAction());
		}
		
		public function sleep(period:Number):CCAction
		{
			return add(new CCSleep(period));
		}
		
		// todo: add syntactic sugar... heaps of it.
		
		protected function safeset(target:Object, propertyName:String, value:Object):void
		{
			if (target is String)
			{
				//for each (var o:Object in engine.query(target as String).)
				engine.query(target as String).forEach(function(o:Object):void
				{
					if (o.hasOwnProperty(propertyName))
					{
						o[propertyName] = value;
					}
				});
			}
			else if (target.hasOwnProperty(propertyName))
			{
				target[propertyName] = value;
			}
		}
		
		public function addTag(tag:String):void
		{
			_tags.addItem(tag);
		}
		
		public function addTags(tags:Array):ICCTaggable
		{
			if (tags != null)
			{
				_tags.addItems(tags);			
			}
			return this;
		}
		
		public function stop(callLastFrame:Boolean=true, callExit:Boolean=true):void
		{
			if (_active)
			{
				_active = false;
				if (callLastFrame) onLastFrame();
				if (callExit) onExit();
			}
			
			_active = false;
		}
		
		public function jumpTo(pos:Number):void
		{
			_position = pos;
		}
		
		public function update(delta:Number):Boolean
		{
			if (!_active) return false;
			
			if (_position == 0)
			{
				if(_cycle == 0)
				{
					onEnter();
				}
				onFirstFrame();
			}
			
			//if (_cycle >= _cycles)
			if (_position >= _cycles)
			{
				stop();
				return _active;
			}
						
			if(_period > 0)
			{
				_position += (delta * _speed) / _period;
			}
			else
			{
				++_position;
			}
			
			// unlike _position, position is always normalized.
			onFrame(_bias(position));
			
			if ((_position - _cycle) >= 1)
			{
				if (_cycle < (_cycles - 1))
				{
					onLastFrame();
					++_cycle;
					
					if (_cycle >= _cycles)
					{
						stop(false, true);
						return _active;
					}
					
					onFirstFrame();
				}
				else
				{
					stop();
				}
			}
			
			return _active;
		}
		
		protected function onEnter():void { }
		protected function onFirstFrame():void { }
		protected function onFrame(t:Number):void { }
		protected function onLastFrame():void { }
		protected function onExit():void { }
	}
}