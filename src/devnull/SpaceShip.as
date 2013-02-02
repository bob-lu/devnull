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
		private var _lastPos:Point;
		private var _cnt:int = 0;
		private var _vp:ViewPort;
		
		public function SpaceShip(vp:ViewPort) {
			_vp = vp;
			_vp.addEventListener(ViewPort.UPDATE, onVpUpdate);


			_fire = new <BitmapData>[];
			var shipBmp:Bitmap = new Ship();
			shipBmp.x = shipBmp.y = -32;
			addChild(shipBmp);
			
			_currentPos.x = 0;
			_currentPos.y = 0;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			addEventListener(Event.ENTER_FRAME, onEF);
			
			scaleX = scaleY = .5;
		}

		private function onVpUpdate(event:Event):void {
			this.x = _vp.transformX(_currentPos.x);
			this.y = _vp.transformY(_currentPos.y);
		}

		private function onEF(event:Event):void {
			if (++_cnt%4 == 0) {
				var rad:Number = (this.rotation+90) * Math.PI / 180;
				var cos:Number = Math.cos(rad);
				var sin:Number = Math.sin(rad);
				
				
				var fire:Fire = new Fire(this.x + (cos*30), this.y + (sin*16), cos*2, sin*2);
				parent.addChild(fire);
			}
		}


		public function setPosition(x:Number, y:Number):void {
			
			_currentPos.x = x;
			_currentPos.y = y;

			this.x = _vp.transformX(x);
			this.y = _vp.transformY(y);
			
			if (_lastPos == null) {
				_lastPos = new Point();
				return;
			}
			
			var rot:Number = Math.atan2(_lastPos.y - _currentPos.y, _lastPos.x - _currentPos.x);
			this.rotation = (rot/Math.PI * 180) - 90;
			_lastPos.x = x;
			_lastPos.y = y;
		}
		
	}
}
