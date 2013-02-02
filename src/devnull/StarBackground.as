/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	public class StarBackground extends Sprite {
		private var _vp:ViewPort;
		private var _starBitmap:Bitmap;
		
		public function StarBackground(vp:ViewPort) {
			_vp = vp;
			_vp.addEventListener(ViewPort.UPDATE, onViewportUpdated);
			

			var w:Number = _vp.width * 3;
			var h:Number = _vp.height * 3;

			var bd:BitmapData = new BitmapData(w, h, false, 0x000000);
			for (var i:int = 0; i < 220; i++) {
				var alpha:Number = (Math.random() * 0xff);
				alpha = alpha << 24;
				var color:Number = (0x00ffff | alpha);

				bd.setPixel32(Math.random() * w, Math.random() * h, color);
			}

			_starBitmap = new Bitmap(bd, "auto", true);
			_starBitmap.x = -bd.width*0.5;
			_starBitmap.y = -bd.height*0.5;
			addChild(_starBitmap);
			this.x = _vp.width*0.5;
			this.y = _vp.height*0.5;
			
			onViewportUpdated();
		}

		private function onViewportUpdated(event:Event = null):void {
			this.scaleX = this.scaleY = ((1-_vp.zoom*0.01));
		}
	}
}
