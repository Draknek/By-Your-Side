package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="levels/start.lvl", mimeType="application/octet-stream")]
		public static const Room_start: Class;
		[Embed(source="levels/chase.lvl", mimeType="application/octet-stream")]
		public static const Room_chase: Class;
		[Embed(source="levels/meet.lvl", mimeType="application/octet-stream")]
		public static const Room_meet: Class;
		[Embed(source="levels/church.lvl", mimeType="application/octet-stream")]
		public static const Room_church: Class;
		[Embed(source="levels/homecoming.lvl", mimeType="application/octet-stream")]
		public static const Room_homecoming: Class;
		[Embed(source="levels/argue.lvl", mimeType="application/octet-stream")]
		public static const Room_argue: Class;
		[Embed(source="levels/accident.lvl", mimeType="application/octet-stream")]
		public static const Room_accident: Class;
		[Embed(source="levels/graveyard.lvl", mimeType="application/octet-stream")]
		public static const Room_graveyard: Class;
		[Embed(source="levels/ghost.lvl", mimeType="application/octet-stream")]
		public static const Room_ghost: Class;
		[Embed(source="levels/ghost2.lvl", mimeType="application/octet-stream")]
		public static const Room_ghost2: Class;
		[Embed(source="levels/end.lvl", mimeType="application/octet-stream")]
		public static const Room_end: Class;
		
		public var src:Tilemap;
		public var bg:Tilemap;
		
		public var levelID:int;
		
		public var params:Object;
		
		public var fadeTween:Tween;
		
		public static var levels:Array = [
			"start", {},
			"chase", {unwed:true},
			"meet", {unwed:true},
			"church", {},
			"homecoming", {},
			"argue", {mirror: true},
			"accident", {mirror: true, car:true},
			"graveyard", {},
			"ghost", {ghost:true},
			"ghost2", {ghost:true},
			"end", {gameover:true}
		];
		
		public function Level (src:Tilemap, i:int)
		{
			levelID = i;
			
			if (i) {
				src = new Tilemap(Editor.EditTilesGfx, FP.width, FP.height, Main.TW, Main.TW);
				
				var levelName:String = levels[i*2-2];
				
				var levelClass:Class = Level["Room_" + levelName];
				
				src.loadFromString(new levelClass);
				
				params = levels[i*2-1];
			}
			
			this.src = src;
			
			bg = src.getSubMap(0, 0, src.columns, src.rows);
			
			var bg2:Tilemap = src.getSubMap(0, 0, src.columns, src.rows);
			
			addGraphic(bg2);
			addGraphic(bg);
			
			function removeTile(i:int, j:int):void
			{
				bg.clearTile(i, j);
			}
			
			var floorTile:int = 0;
			
			for (var i:int = 0; i < src.columns; i++) {
				for (var j:int = 0; j < src.rows; j++) {
					var tile:uint = src.getTile(i, j);
					
					var x:Number = camera.x + i * src.tileWidth;
					var y:Number = camera.y + j * src.tileHeight;
					
					switch (tile) {
						case 4:
						case 7:
						case 8:
						case 14:
						case 17:
						case 19:
							add(new Wall(x,y));
						break;
						case 2:
							add(new Player(x,y));
							removeTile(i,j);
						break;
						case 3:
							add(new Shadow(x,y, params));
							removeTile(i,j);
						break;
						case 5:
						case 6:
							add(new Trigger(x,y));
						break;
						case 0:
							add(new Road(x,y));
						break;
						case 13:
							add(new Target(x,y));
						break;
						default:
							floorTile = tile;
						break;
					}
				}
			}
			
			bg2.setRect(0, 0, src.columns, src.rows, floorTile);
			
			var oldScreen:Image = new Image(FP.buffer.clone());
			
			addGraphic(oldScreen, -20);
			
			fadeTween = FP.tween(oldScreen, {alpha: 0}, 30, {ease:Ease.sineOut, tweener:FP.tweener});
			
			if (params.gameover) {
				active = false;
				
				var grey:Image = Image.createRect(FP.width, FP.height, 0x242525, 0);
				
				addGraphic(grey, -30);
				
				FP.tween(grey, {alpha: 1}, 30, {ease:Ease.sineOut, tweener:FP.tweener, delay: 90});
				
				var text:Text = new Text("Commiserations\n\nIt is over", FP.width*0.5, FP.height*0.5, {color: 0xe6e4d5, size: 32, alpha: 0, align: "center", font: "custom"});
				
				addGraphic(text, -30);
				
				text.centerOO();
				
				FP.tween(text, {alpha: 1}, 30, {ease:Ease.sineOut, tweener:FP.tweener, delay: 120});
			}
		}
		
		public override function update (): void
		{
			if (fadeTween.active) return;
			
			super.update();
			
			if (Input.pressed(Key.R)) {
				FP.world = new Level(src, levelID);
				return;
			}
			
			if (Main.devMode && Input.pressed(Key.N)) {
				FP.world = new Level(null, levelID + 1);
				return;
			}
			
			if (Main.devMode && Input.pressed(Key.E)) {
				FP.world = new Editor();
				return;
			}
			
			array.length = 0;
			
			getClass(Target, array);
			
			if (array.length == 0) return;
			
			var gameOver:Boolean = false;
			
			var allTargets:Boolean = true;
			
			for each (var e:Entity in array) {
				e.update();
				if (! Target(e).filled) {
					allTargets = false;
				}
			}
			
			if (allTargets) {
				gameOver = true;
			}
			
			if (params.car) {
				e = classFirst(Shadow);
				
				if (e.x >= FP.width - 1) {
					FP.world = new Level(null, levelID + 1);
				}
			}
			
			if (gameOver) {
				removeList(array);
				FP.alarm(30, function ():void {
					FP.world = new Level(null, levelID + 1);
				});
				
				e = classFirst(Player);
				
				e.active = false;
				
				e["moveTween"].cancel();
			}
		}
		
		public static var array:Array = [];
		
		public override function render (): void
		{
			super.render();
		}
	}
}

