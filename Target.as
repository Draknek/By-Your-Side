package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Target extends Entity
	{
		public var filled:Boolean = false;
		
		public function Target (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			setHitbox(Main.TW, Main.TW);
		}
		
		public override function update (): void
		{
			var e:Entity = collide("solid", x, y);
			
			filled = (e != null && e.x == x && e.y == y);
		}
	}
}

