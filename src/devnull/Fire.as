/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.display.Sprite;
	import flash.events.Event;

	public class Fire extends Sprite{
		private var _xspeed:Number;
		private var _yspeed:Number;
		private var _life:Number = 30;
		public function Fire(x:Number, y:Number, xspeed:Number, yspeed:Number) {
			
			_xspeed = xspeed;
			_yspeed = yspeed;
			this.graphics.beginFill(0xff0000, 0.5);
			this.graphics.drawRect(-5,-5,10,10);
			this.graphics.endFill();
			
			this.x = x;
			this.y = y;
			
			addEventListener(Event.ENTER_FRAME, onEF);
		}

		private function onEF(event:Event):void {
			_life--;
			this.x += _xspeed;
			this.y += _yspeed;
			if (_life <= 0) {
				addEventListener(Event.ENTER_FRAME, onEF);
				if (parent)
					this.parent.removeChild(this);
			}
		}
	}
}
