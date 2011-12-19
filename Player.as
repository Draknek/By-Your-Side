package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		public var moveTween:Tween;
		
		public static const MOVE_TIME: Number = 16;
		
		public function Player (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
			
			var sprite:Spritemap = new Spritemap(Editor.EditTilesGfx, 16, 16);
			
			sprite.frame = 2;
			
			graphic = sprite;
		}
		
		public override function update (): void
		{
			if (moveTween && moveTween.active) {
				return;
			}
			
			var dx:int = int(Input.check(Key.RIGHT)) - int(Input.check(Key.LEFT));
			
			if (! dx) {
				var dy:int = int(Input.check(Key.DOWN)) - int(Input.check(Key.UP));
			}
			
			if (! dx && ! dy) return;
			
			var speed:int = Main.TW;
			
			var e:Entity = collide("solid", x+speed*dx, y+speed*dy);
			
			var s:Shadow;
			
			if (e) {
				if (e is Shadow) {
					s = e as Shadow;
					
					if (! s.canMove(dx, dy)) {
						return;
					}
				} else {
					return;
				}
			}
			
			array.length = 0;
			
			world.getClass(Shadow, array);
			
			for each (s in array) {
				s._canMove = s.canMove(dx, dy);
			}
			
			moveTween = FP.tween(this, {x: x + speed*dx, y: y + speed*dy}, MOVE_TIME, {tweener:FP.world});
			
			for each (s in array) {
				s.doMovement(dx, dy);
			}
			
			Audio.playNote();
		}
		
		private static var array:Array = [];
	}
}

