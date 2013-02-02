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
		
		private var _spinCounter:int;
		
		public function SpaceShip(vp:ViewPort) {
			_vp = vp;
			_vp.addEventListener(ViewPort.UPDATE, onVpUpdate);


			_fire = new <BitmapData>[];
			var shipBmp:Bitmap = new Ship();
			shipBmp.scaleX = shipBmp.scaleY = .5;
			shipBmp.x = shipBmp.y = -shipBmp.width * .5;
			addChild(shipBmp);
			
			_currentPos.x = 0;
			_currentPos.y = 0;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			addEventListener(Event.ENTER_FRAME, onEF);
			
			
		}

		private function onVpUpdate(event:Event):void {
			this.x = _vp.transformX(_currentPos.x);
			this.y = _vp.transformY(_currentPos.y);
		}

		private function onEF(event:Event):void {
			
			if (--_spinCounter < 0) {
				this.rotation += 1;
			}
			
			if (++_cnt%4 == 0) {
				var rad:Number = (this.rotation+90) * Math.PI / 180;
				var cos:Number = Math.cos(rad);
				var sin:Number = Math.sin(rad);
				
				
				var fire:Fire = new Fire(this.x + (cos*16), this.y + (sin*16), cos*2, sin*2);
				parent.addChild(fire);
			}
		}


		public function setPosition(x:Number, y:Number):void {
			
			_spinCounter = 200;
			
			_currentPos.x = x;
			_currentPos.y = y;

			this.x = _vp.transformX(x);
			this.y = _vp.transformY(y);
			
			if (_lastPos == null) {
				_lastPos = new Point();
				return;
			}
			
			if (!_lastPos.equals(_currentPos)) {
				var rot:Number = Math.atan2(_lastPos.y - _currentPos.y, _lastPos.x - _currentPos.x);
				this.rotation = (rot/Math.PI * 180) - 90;
				_lastPos.x = x;
				_lastPos.y = y;
			}
		}
		
	}
}
