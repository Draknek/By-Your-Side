package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Trigger extends Entity
	{
		public var spoken:Boolean = false;
		
		public var text:Text;
		
		public function Trigger (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
		}
		
		private function get nearPlayer () :Boolean {
			var p:Player = world.classFirst(Player) as Player;
			
			var dx:Number = p.x - x;
			var dy:Number = p.y - y;
			
			if ((dx < -2 || dx > 2) && (dy < -2 || dy > 2)) return false;
			
			var dist:Number = dx + dy;
			
			var maxDist:Number = Main.TW + 2;
			
			if (dist < -maxDist || dist > maxDist) return false;
			
			return true;
		}
		
		public override function update (): void
		{
			var player:Player = world.classFirst(Player) as Player;
			
			if (text) {
				if (Input.pressed(Key.SPACE)) {
					text.visible = false;
					player.active = true;
				}
				return;
			}
			
			if (! spoken && nearPlayer) {
				spoken = true;
				
				player.active = false;
				
				text = new Text("...", FP.width*0.5, FP.height*0.5, {size: 32, color: 0xe6e4d5});
				
				text.centerOO();
				
				world.addGraphic(text, -10);
			}
		}
	}
}

