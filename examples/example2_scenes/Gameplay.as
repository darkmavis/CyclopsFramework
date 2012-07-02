package org.cyclopsframework.examples.example2_scenes
{
	import flash.display.Sprite;
	
	import org.cyclopsframework.actions.animation.CFFadeTo;
	import org.cyclopsframework.actions.animation.CFScaleTo;
	import org.cyclopsframework.actions.animation.CFTranslateTo;
	import org.cyclopsframework.core.easing.CFBias;
	import org.cyclopsframework.game.CFScene;
	import org.cyclopsframework.utils.primitives.CFPrimitives;
	
	public class Gameplay extends CFScene
	{
		// Tag by which this scene can be queried via a direct parent or parent further up the tree.
		// Note that this tag does not require an @ symbol prefix because it's not part of a sequence and as such,
		// there's no reason to be concerned about this tag cascading. 
		public static const TAG:String = "Gameplay";
		
		override public function Gameplay()
		{
			super(TAG);
		}
		
		// Use this function to begin any work required by this scene.
		// In some cases, virtually everything can be setup here, due to the functional nature of the framework.
		protected override function onEnter():void
		{
			// Create a filled circle and add it to our bg (background) Sprite.
			// Every scene has a bg (background) Sprite.
			var circle:Sprite = CFPrimitives.filledCircle(32, 0xFF0000);
			circle.x = HelloScenes.WIDTH / 2 - 100;
			circle.y = HelloScenes.HEIGHT / 2;
			circle.alpha = 0;
			bg.addChild(circle);
			
			// Every scene also has an engine like the one found in the first example.
			// Here, after sleeping for a second and then fading in over 2 seconds,
			// we're translating the circle from one point to another over a period of 5 seconds,
			// with the maximum number of countable cycles and using a SINE_WAVE biasing curve... aka easing.
			engine
				.sugar.sleep(1)
				.add(new CFFadeTo(circle, 1, 2, 1, CFBias.EASE_OUT))
				.add(new CFTranslateTo(circle, circle.x + 200, circle.y, 5, Number.MAX_VALUE, CFBias.SINE_WAVE));
			
			// One way to loop things.
			var bounce:Function = function():void
			{
				engine
					.add("boing", new CFScaleTo(circle, 2, 1, 1, 1, CFBias.SINE_WAVE))
					.add(new CFScaleTo(circle, 1, 2, 1, 2, CFBias.SINE_WAVE))
					.add(bounce);
			};
			
			// Loop this bugger forever.
			bounce();
			
			// Well not quite forever, because we're going to shut it down in this next sequence by using a tag.
			// And then let's wait a bit and bring it back.
			engine
				.sugar.sleep(8)
				.add(function():void { engine.remove("boing"); })
				.sugar.sleep(4)
				.add(bounce);
			
			// So you may be wondering what's up with the "boing" tag.  it's a cascading tag that cascades from
			// from an action into all that action's child actions and so on... eventually many future actions
			// could carry this tag.  it's a useful way to control whole branches of a sequence tree.
			// Note: tree, because while it is a chain in this instance, it could be linked up as a tree where
			// after one action finishes, several more follow.
			//
			// If you didn't want the tag to cascade, you could prefix it with an: @  like: "@boing"
			// "@boing" would not cascade and then your only window to shut the sequence down would be while
			// the very first action was running.
			//
			// You may notice that most of the built-in actions (perhaps all), contain an @ symbol and will not
			// cascade.  cascading a CFSleep.TAG or a CFTranslate.TAG into another action would likely just
			// get in the way.
			
			// Next up: messaging
			
		}
		
	}
}