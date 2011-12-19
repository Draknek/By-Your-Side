package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Shadow extends Entity
	{
		public var _canMove:Boolean = false;
		
		public var isGhost:Boolean = false;
		
		public var sprite:Spritemap;
		public var coffin:Spritemap;
		
		public var moveX:int = 1;
		public var moveY:int = 1;
		
		public var moveTween:Tween;
		
		public function Shadow (_x:Number, _y:Number, options:Object)
		{
			x = _x;
			y = _y;
			
			if (options.mirror) {
				moveX = moveY = -1;
			}
			
			if (options.ghost) {
				isGhost = true;
			}
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Editor.EditTilesGfx, 16, 16);
			sprite.frame = 3;
			
			if (options.unwed) {
				sprite.frame = 6;
			}
			
			graphic = sprite;
			
			if (isGhost) {
				coffin = new Spritemap(Editor.EditTilesGfx, 16, 16);
				coffin.frame = 10;
				coffin.alpha = 0;
				
				graphic = new Graphiclist(coffin, sprite);
			}
		}
		
		public override function update (): void
		{
			if (! isGhost) return;
			
			var t:Number = sprite.alpha;
			
			t += ((nearPlayer ? 1 : 0) - t) * 0.3;
			
			sprite.alpha = t;
			coffin.alpha = 1 - t;
		}
		
		private function get nearPlayer () :Boolean {
			if (isGhost && moveTween && moveTween.active) return true;
			
			var p:Player = world.classFirst(Player) as Player;
			
			var dx:Number = p.x - x;
			var dy:Number = p.y - y;
			
			if ((dx < -2 || dx > 2) && (dy < -2 || dy > 2)) return false;
			
			var dist:Number = dx + dy;
			
			var maxDist:Number = Main.TW + 2;
			
			if (dist < -maxDist || dist > maxDist) return false;
			
			return true;
		}
		
		public function canMove (pdx:int, pdy:int): Boolean
		{
			var dx:int = pdx * moveX;
			var dy:int = pdy * moveY;
			
			var speed:int = Main.TW;
			
			var e:Entity = collide("solid", x+speed*dx, y+speed*dy);
			
			var s:Shadow;
			
			if (isGhost && ! nearPlayer) {
				return false;
			}
			
			var flippedMovement:Boolean = (dx * moveX != dx || dy * moveY != dy);
			
			if (e) {
				if (e is Shadow) {
					s = e as Shadow;
					
					return s.canMove(pdx, pdy);
				} else if (e is Player) {
					return ! flippedMovement;
				} else {
					return false;
				}
			}
			
			if (flippedMovement) {
				e = collide("solid", x+speed*dx*2, y+speed*dy*2);
				
				if (e && e is Player) return false;
			}
			
			return true;
		}
		
		public function doMovement (pdx:int, pdy:int): void
		{
			if (! _canMove) return;
			
			var dx:int = pdx * moveX;
			var dy:int = pdy * moveY;
			
			var speed:int = Main.TW;
			
			moveTween = FP.tween(this, {x: x + speed*dx, y: y + speed*dy}, Player.MOVE_TIME);
		}
	}
}

