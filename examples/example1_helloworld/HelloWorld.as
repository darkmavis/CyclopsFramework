package org.cyclopsframework.examples.example1_helloworld
{
	import org.cyclopsframework.actions.flow.CFFunction;
	import org.cyclopsframework.core.CFEngine;
	import org.cyclopsframework.game.CFGame;
	
	// note that CFGame and CFScene classes are not required to use the framework.
	// they just make it much easier and ensure that you're getting more than enough
	// heavy lifting for free.  CFEngine is the bare minimum required for proper use.
	// Even CFScene can be used without a CFGame in a stand-alone mode.
	
	[SWF(width="800", height="600", frameRate="30")]
	public class HelloWorld extends CFGame
	{
		public static const WIDTH:Number = 800;
		public static const HEIGHT:Number = 600;
		
		public function HelloWorld()
		{
			// All defaults: width=800, height=600, fillBackground=false
			super(WIDTH, HEIGHT, false);
		}
		
		protected override function bootstrap():void
		{
			// Print the 1st message to the console.
			console.println("Hello world of Cyclops Framework!");
			
			// Easy access to our engine.
			var engine:CFEngine = scene.engine;
			
			// Sequence two CFAction objects.
			// Note that the 1st is sugar for: new CFSleep(1)
			// The 2nd is a function that is auto-converted to a CFAction.
			engine
				.sugar.sleep(1)
				.add(function():void { console.println("Hello again world of Cyclops Framework!"); });
			
			// Although action sequences are usually used as seen above, if required, an array can be used as well.
			var actions:Array = [];
			
			var chars:Array = "Hello yet again world of Cyclops Framework!\n\n".split("");
			
			// Build a sequence of functions, each of which will print a character from our string to the console.
			// Note that when we added a function above, it was actually being converted to a CFFunction.
			// This CFFunction has a period of .1 seconds and 1 cycle, so we don't need to use CFSleep here.
			for each (var c:String in chars)
			{
				actions.push(new CFFunction(.1, 1, this, [c], console.print));
			}
			
			// Sleep 2 seconds.
			// Then add the head of the sequence to the engine and return the tail in case we need to add more goodies to it via the add(...) method.
			engine
				.sugar.sleep(2)
				.sugar.addSequenceReturnTail(actions)
				.add(function():void
				{
					console.help();
					console.println("\nNext tutorial:\nCFScenes, because even functionality of this type should really be encapsulated in it's own scene.\n");
				});
		}
	}
}