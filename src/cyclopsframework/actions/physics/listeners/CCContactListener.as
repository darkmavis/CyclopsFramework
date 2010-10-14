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

package cyclopsframework.actions.physics.listeners
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	public class CCContactListener extends b2ContactListener
	{
		public var onBeginContact:Function;
		public var onEndContact:Function;
		public var onPreSolve:Function;
		public var onPostSolve:Function;
		
		public function CCContactListener()
		{
			super();
		}
		
		public override function BeginContact(contact:b2Contact):void
		{
			if (onBeginContact != null)	onBeginContact(contact);
		}
		
		public override function EndContact(contact:b2Contact):void
		{
			if (onEndContact != null) onEndContact(contact);
		}
		
		public override function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			if (onPreSolve != null)	onPreSolve(contact, oldManifold);
		}
		
		public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			if (onPostSolve != null) onPostSolve(contact, impulse);
		}
		
	}
}