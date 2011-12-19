package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Wall extends Entity
	{
		public function Wall (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			//graphic = Image.createRect(Main.TW, Main.TW, 0x0);
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
		}
		
		public override function update (): void
		{
		}
	}
}

