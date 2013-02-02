/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class SpaceShip extends Sprite {

		[Embed(source='ship.png')]
		public var Ship:Class;
		
		private var _fire:Vector.<BitmapData>;
		
		private var _currentPos:Point = new Point();
		private var _lastPos:Point = new Point();
		
		public function SpaceShip() {
			
			
			_fire = new <BitmapData>[];
			var shipBmp:Bitmap = new Ship();
			shipBmp.x = shipBmp.y = -32;
			
			_currentPos.x = 0;
			_currentPos.y = 0;
			
			addEventListener(Event.ENTER_FRAME, onEF);
		}

		private function onEF(event:Event):void {
			
		}

		
		
		
		

		
		
	}
}
