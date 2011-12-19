package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Road extends Entity
	{
		public function Road (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			setHitbox(Main.TW, Main.TW);
		}
		
		public override function update (): void
		{
			var e:Entity = collide("solid", x, y);
			
			if (e) {
				var car:Spritemap = new Spritemap(Editor.EditTilesGfx, 16, 16);
				car.frame = 12;
				
				car.x = -width;
				car.y = y;
				
				FP.tween(car, {x: FP.width}, 30);
				
				FP.tween(e, {x: FP.width}, 13, {delay: 17});
				
				e.collidable = false;
				
				world.addGraphic(car, -10);
				
				world.remove(this);
				
				Audio.playCar();
			}
		}
	}
}

