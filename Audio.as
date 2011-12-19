package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import net.flashpunk.utils.Key;
	import net.flashpunk.*;
	
	import flash.media.*;
	import flash.utils.*;
	
	public class Audio
	{
		[Embed(source="audio/notes.mp3")]
		public static var NoteSfx:Class;
		
		private static var _mute:Boolean = false;
		private static var so:SharedObject;
		private static var menuItem:ContextMenuItem;
		
		private static var carString:String = "3,,0.8,0.46,0.36,0.15,,-0.099,-0.079,,,0.439,0.18,,,0.564,0.219,,0.83,-0.02,,,,0.5";
		
		private static var car:SfxrSynth;
		
		public static function init (o:InteractiveObject):void
		{
			// Setup
			
			so = SharedObject.getLocal("audio");
			
			_mute = so.data.mute;
			
			addContextMenu(o);
			
			if (o.stage) {
				addKeyListener(o.stage);
			} else {
				o.addEventListener(Event.ADDED_TO_STAGE, stageAdd);
			}
			
			// Create sounds
			
			car = new SfxrSynth();
			car.setSettingsString(carString);
			car.cacheSound();
		}
		
		private static var prev:Sfx;
		private static var prevN:int;
		
		private static var sounds:Array = [];
		private static var tweens:Array = [];
		
		public static function playNote () : void
		{
			if (prev && prev.playing) {
				if (! tweens[prevN] || ! tweens[prevN].active) {
					tweens[prevN] = FP.tween(prev, {volume: 0}, 15);
				}
			}
			
			if (! mute)
			{
				var i : int = prevN = (Math.random() * 6);
				
				if (sounds[i]) {
					prev = sounds[i];
				} else {
					prev = sounds[i] = new Sfx(NoteSfx);
				}
				
				if (tweens[prevN] && tweens[prevN].active) {
					tweens[prevN].cancel();
				}
				
				prev.play(1, 0, i * 4000);
				
				var myPrev:Sfx = prev;
				
				FP.alarm(80, function ():void {
					if (! prev || prev != myPrev) return;
					tweens[prevN] = FP.tween(prev, {volume: 0}, 30);
					prev = null;
				});
			}
		}
		
		public static function playCar () : void
		{
			if (! _mute) {
				car.playCached();
			}
		}
		
		// Getter and setter for mute property
		
		public static function get mute (): Boolean { return _mute; }
		
		public static function set mute (newValue:Boolean): void
		{
			if (_mute == newValue) return;
			
			_mute = newValue;
			
			menuItem.caption = _mute ? "Unmute" : "Mute";
			
			so.data.mute = _mute;
			so.flush();
		}
		
		// Implementation details
		
		private static function stageAdd (e:Event):void
		{
			addKeyListener(e.target.stage);
		}
		
		private static function addContextMenu (o:InteractiveObject):void
		{
			var menu:ContextMenu = o.contextMenu || new ContextMenu;
			
			menu.hideBuiltInItems();
			
			menuItem = new ContextMenuItem(_mute ? "Unmute" : "Mute");
			
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuListener);
			
			menu.customItems.push(menuItem);
			
			o.contextMenu = menu;
		}
		
		private static function addKeyListener (stage:Stage):void
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
		}
		
		private static function keyListener (e:KeyboardEvent):void
		{
			if (e.keyCode == Key.M) {
				mute = ! mute;
			}
		}
		
		private static function menuListener (e:ContextMenuEvent):void
		{
			mute = ! mute;
		}
	}
}

