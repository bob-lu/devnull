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
		private var _life:Number = 10;
		public function Fire(x:Number, y:Number, xspeed:Number, yspeed:Number) {
			
			_xspeed = xspeed;
			_yspeed = yspeed;
			this.graphics.drawRect(-2,-2,4,4);
			
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
				this.parent.removeChild(this);
			}
		}
	}
}
