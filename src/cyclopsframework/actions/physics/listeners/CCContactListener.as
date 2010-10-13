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