/**
 * Cyclops Framework
 * 
 * Copyright 2012 Mark Davis Licensed under the Apache License, Version 2.0 (the "License");
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

package org.cyclopsframework.core
{
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.actions.flow.CFSleep;
	import org.cyclopsframework.actions.flow.CFWaitForEvent;
	import org.cyclopsframework.actions.flow.CFWaitForMessage;
	import org.cyclopsframework.actions.flow.CFWaitUntil;
	import org.cyclopsframework.actions.interpolation.CFInterpolate;
	import org.cyclopsframework.utils.logging.CFLog;
	
	/**
	 * <p>The purpose of <code>CFSugar</code> is to provide common syntactic sugar methods to both
	 * <code>CFEngine</code> and <code>CFAction</code>.
	 * These are sequencing methods and can be used to build complex sequence trees.
	 * In earlier versions of the framework,
	 * these methods were duplicated, and cluttered up the classes they resided in.
	 * Hopefully this will make it clearer to beginners that the framework is built upon
	 * solid core elements and that these methods use actions underneath.
	 * If extra functionality is required, take a look at the underlying actions for an answer.</p>
	 */	
	public class CFSugar
	{
		/**
		 * The parent is the hosting container for instances of this class.
		 * At the time of this writing, only two classes contain <code>CFSugar</code> instances.
		 * Those are <code>CFEngine</code> and <code>CFAction</code>.
		 */		
		private var _parent:Object;
		
		/**
		 * This is the engine to be used as needed by methods in this class.
		 */		
		private var _engine:CFEngine;
		
		/**
		 * <p>The purpose of <code>CFSugar</code> is to provide common syntactic sugar methods to both
		 * <code>CFEngine</code> and <code>CFAction</code>.
		 * These are sequencing methods and can be used to build complex sequence trees.
		 * In earlier versions of the framework,
		 * these methods were duplicated, and cluttered up the classes they resided in.
		 * Hopefully this will make it clearer to beginners that the framework is built upon
		 * solid core elements and that these methods use actions underneath.
		 * If extra functionality is required, take a look at the underlying actions for an answer.</p>
		 * 
		 * @param parent
		 * This is the host object that will contain an instance of CFSugar.
		 * At the time of this writing, only two classes contain <code>CFSugar</code> instances.
		 * Those are <code>CFEngine</code> and <code>CFAction</code>.
		 */		
		public function CFSugar(parent:Object)
		{
			_parent = parent;
			_engine = ((_parent is CFEngine) ? _parent : _parent.engine) as CFEngine;
			if (_engine == null) throw new Error("Parent object must be either a CFEngine or a ICFHasEngine." +
				"\nParent is actually a: " + flash.utils.getQualifiedClassName(_parent));
		}
		
		/**
		 * This will add a sequence of actions stored in an array.
		 * The first or last action in the sequence will be returned depending on the value of <code>returnHead</code>.
		 * 
		 * @param actions
		 * This should be an array of either <code>CFAction</code> or <code>Function</code> objects.
		 * 
		 * @param returnHead
		 * Set this to true to return the first element or false to return the last element.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		private function addSequence(actions:Array, returnHead:Boolean):CFAction
		{
			var head:Object;
			var tail:Object;
			var tmpTail:Object;
			
			for each (var o:Object in actions)
			{
				if (head == null)
				{
					head = tail = _parent.add(o);
				}
				else
				{
					tmpTail = tail.add(o);
					if (tmpTail != null) tail = tmpTail;
				}
			}
			
			return ((returnHead ? head : tail) as CFAction);
		}
		
		/**
		 * Use this to add a sequence of actions stored in an array.
		 * The first action in the sequence will be returned.
		 *  
		 * @param actions
		 * This should be an array of either <code>CFAction</code> or <code>Function</code> objects.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */
		public function addSequenceReturnHead(actions:Array):CFAction
		{
			return addSequence(actions, true);
		}
		
		/**
		 * Use this to add a sequence of actions stored in an array.
		 * The last action in the sequence will be returned.
		 *  
		 * @param actions
		 * This should be an array of either <code>CFAction</code> or <code>Function</code> objects.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */
		public function addSequenceReturnTail(actions:Array):CFAction
		{
			return addSequence(actions, false);
		}
		
		/**
		 * <p>Use this to add a function as an action with more control than that provided by the <code>add</code> method.
		 * This method is capable of starting a sequence.</p>  
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFFunction</code>.</p>
		 * 
		 * @param f
		 * Provide a function that will be wrapped as a <code>CFFunction</code> internally.
		 * 
		 * @param thisObject
		 * The <code>thisObject</code> provides a <code>this</code> context to the function in case
		 * <code>this</code> is referenced from within the function.
		 * 
		 * @param data
		 * These are the arguments to pass to the function if it requires arguments.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function addf(f:Function, thisObject:Object=null, data:Array=null):CFAction
		{
			return _parent.add(new CFFunction(0, 1, thisObject, data, f));
		}
		
		/**
		 * <p>Use this to loop a function for a given number of cycles with a given period.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFFunction</code>.</p>
		 * 
		 * @param f
		 * Provide a function that will be wrapped as a <code>CFFunction</code> internally.
		 * 
		 * @param period
		 * This is the length of a cycle and is specified in seconds.
		 * 
		 * @param cycles
		 * This is the number of times to repeat this action.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function loop(f:Function, period:Number=0, cycles:Number=Number.MAX_VALUE):CFAction
		{
			return _parent.add(new CFFunction(period, cycles, null, null, f));
		}
		
		/**
		 * <p>Use this "No OPeration" method to add a default CFAction that will do nothing other than run for a single frame. 
		 * There's very little reason for calling this method as a one off. It should be used to start a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFAction</code>.</p>
		 * 
		 * @param tag
		 * For convenience, a tag may be specified here.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 * 
		 */		
		public function nop(tag:String=null):CFAction
		{
			return _parent.add(tag, new CFAction());
		}
		
		/**
		 * <p>Use this to sleep for a period of time measured in seconds.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFSleep</code>.</p>
		 * 
		 * @param period
		 * This is the length of a cycle and is specified in seconds.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function sleep(period:Number):CFAction
		{
			return _parent.add(new CFSleep(period));
		}
		
		/**
		 * <p>Use this to interpolate an object's property from one value to another.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFInterpolate</code>.</p>
		 * 
		 * @param target
		 * This is the target object which contains a property of interest.
		 * 
		 * @param propertyName
		 * This is the target property that will be interpolated.
		 * 
		 * @param a
		 * This is the value to interpolate from.
		 * 
		 * @param b
		 * This is the value to interpolate to.
		 * 
		 * @param period
		 * This is the length of a cycle and is specified in seconds.
		 * 
		 * @param cycles
		 * This is the number of times to repeat this action.
		 * 
		 * @param bias
		 * This is the f(t) function used to bias (aka ease) the interpolated value.
		 * 
		 * @param mapFunc
		 * This is the f(o) function used to map the interpolated numerical value to any other type or value.
		 * 
		 * @return
		 * The returned action can be used to build a sequence tree of actions.
		 * 
		 */		
		public function tween(target:Object, propertyName:String, a:Number, b:Number,
							  period:Number=0, cycles:Number=1, bias:Function=null, mapFunc:Function=null):CFAction
		{
			return _parent.add(new CFInterpolate(target, propertyName, a, b, period, cycles, bias, mapFunc));
		}
		
		/**
		 * <p>Use this to wait for an event before continuing to process a sequence tree of actions.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFWaitForEvent</code>.</p>
		 * 
		 * @param target
		 * The target is the event dispatcher.
		 * 
		 * @param eventType
		 * This can be an event type such as ENTER_FRAME.
		 * 
		 * @param timeout
		 * Period in seconds to wait before timing out and continuing the sequence tree.
		 * 
		 * @param cycles
		 * This is the number of times to repeat this action.
		 * 
		 * @param listener
		 * An event listener function f(e) can be added that will execute immediately after the event is received.
		 * 
		 * @return
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function waitForEvent(target:*, eventType:String, timeout:Number=Number.MAX_VALUE,
									 cycles:Number=1, listener:Function=null):CFAction
		{
			return _parent.add(new CFWaitForEvent(target, eventType, timeout, cycles, listener));
		}
		
		/**
		 * <p>Use this to wait for a message within a sequence tree before continuing.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFWaitForMessage</code>.</p>
		 * 
		 * @param receiverTag
		 * The message will be delivered to all tagged objects that were registered with this tag.
		 * 
		 * @param messageName
		 * In many cases, the message name is the name of a method that will be called on a tagged object
		 * if the method exists.  If it doesn't exist, the message will be ignored.
		 * If the tagged object is an <code>ICFMessageInterceptor</code> then a named method is not required;
		 * the message will be delivered and processed.
		 * 
		 * @param timeout
		 * Period in seconds to wait before timing out and continuing the sequence tree.
		 * 
		 * @param cycles
		 * This is the number of times to repeat this action.
		 * 
		 * @param messageListener
		 * This is a function <code>f(msg:CFMessage)</code> that will be called if and when the message is received.
		 * It's similar to an event listener, except that it processes a message instead.
		 * 
		 * @param timeoutListener
		 * This is a function <code>f()</code> that will be called if and when the action times out before receiving a message.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function waitForMessage(receiverTag:String, messageName:String, timeout:Number=Number.MAX_VALUE,
									   cycles:Number=1, messageListener:Function=null, timeoutListener:Function=null):CFAction
		{
			return _parent.add(receiverTag, new CFWaitForMessage(messageName, timeout, cycles, messageListener, timeoutListener));
		}
		
		/**
		 * <p>Use this to wait for a predicate to return true from within a sequence tree.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFWaitUntil</code>.</p>
		 * 
		 * @param predicate
		 * The predicate is a function <code>f():Boolean</code>.
		 * If and when it returns <code>true</code>, the action will stop and subsequent actions will start.
		 * 
		 * @param timeout
		 * Period in seconds to wait before timing out and continuing the sequence tree.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function waitUntil(predicate:Function, timeout:Number=Number.MAX_VALUE, listener:Function=null):CFAction
		{
			return _parent.add(new CFWaitUntil(predicate, timeout, listener));
		}
		
		/**
		 * <p>Use this to listen indefinitely for a message before continuing in a sequence tree.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFWaitForMessage</code>.
		 * It can also be achieved by using <code>waitForMessage</code> from a <code>CFSugar</code> instance.</p>
		 * 
		 * @param receiverTag
		 * The tag "channel" to listen on.
		 * 
		 * @param messageName
		 * This is the name of the message to listen for. 
		 * 
		 * @param messageListener
		 * This is a function <code>f(msg:CFMessage)</code> that will be called if and when the message is received.
		 * It's similar to an event listener, except that it processes a message instead.
		 * 
		 * @return 
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function listen(receiverTag:String, messageName:String, messageListener:Function=null):CFAction
		{
			return waitForMessage(receiverTag, messageName, Number.MAX_VALUE, Number.MAX_VALUE, messageListener);
		}
		
		/**
		 * <p>Use this to send a message from within a sequence tree.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFFunction</code>.</p>
		 * 
		 * @param receiverTag
		 * The message will be delivered to all tagged objects registered with this tag.
		 * 
		 * @param messageName
		 * In many cases, the message name is the name of a method that will be called on a tagged object
		 * if the method exists.  If it doesn't exist, the message will be ignored.
		 * If the tagged object is an <code>ICFMessageInterceptor</code> then a named method is not required;
		 * the message will be delivered and processed.
		 * 
		 * @param data
		 * If the message is delivered in the form of a method call, then the data items will be treated as parameters.
		 * If the message is delivered in the form of a <code>CFMessage</code>, then the data will be packaged in an array.
		 * 
		 * @return
		 * The returned action can be used to build a sequence tree of actions.
		 */		
		public function send(receiverTag:String, messageName:String, ...data):CFAction
		{
			return _parent.sugar.addf(function():void { _engine.send(receiverTag, messageName, data); });
		}
		
		/**
		 * <p>Use this to add a log entry from within a sequence tree.
		 * This method is capable of starting a sequence.</p>
		 * <p>Note: This is a syntactic sugar method.
		 * This action can be achieved manually by using <code>CFFunction</code>.</p>
		 * 
		 * @param text
		 * This text will be written to the active log if the channel is enabled.
		 * 
		 * @param channel
		 * This is the channel to write this text to. Text will only be written if the channel is enabled.
		 * <p>Common channels include:</p>
		 * <l>
		 * <li><code>CFLog.CHANNEL_DEFAULT</code></li>
		 * <li><code>CFLog.CHANNEL_INFO</code></li>
		 * <li><code>CFLog.CHANNEL_WARNINGS</code></li>
		 * <li><code>CFLog.CHANNEL_ERRORS</code></li>
		 * </l>
		 * <p>Respectively, these are:
		 * <code>"default"</code>, <code>"info"</code>, <code>"warnings"</code>, and <code>"errors"</code>.</p>
		 * <p>Any channel name is acceptable, and you use as many channels as you like.</p>
		 * @return The returned action can be used to build a sequence tree of actions.
		 */		
		public function addLogEntry(text:Object, channel:String="default"):CFAction
		{
			return (_parent.add(function():void { CFLog.println(text, channel); }));
		}
		
	}
}