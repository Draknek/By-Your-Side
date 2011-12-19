package
{
	import net.flashpunk.*;
	
	import flash.net.*;
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static const TW:int = 16;
		public static const TILES_WIDE:int = 320/16;
		public static const TILES_HIGH:int = 240/16;
		
		public static var devMode:Boolean = false;
		
		public static const so:SharedObject = SharedObject.getLocal("draknek", "/");
		
		[Embed(source = 'fonts/88 Zen.ttf', embedAsCFF="false", fontFamily = 'custom')]
		private static var _FONT:Class;
		
		public function Main ()
		{
			super(320, 240, 60, true);
			
			FP.screen.scale = 2;
			
			FP.screen.color = 0x68a941;
			
			//FP.console.enable();
			
			Editor.init();
			
			FP.world = new Level(null, 1);
			
			Audio.init(this);
		}
		
		public override function init (): void
		{
			sitelock("draknek.org");
			
			super.init();
		}
		
		public function sitelock (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;
			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') return true;
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return true;
			}
			
			parent.removeChild(this);
			throw new Error("Error: this game is sitelocked");
			
			return false;
		}
	}
}

