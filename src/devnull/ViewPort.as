/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import com.eclecticdesignstudio.motion.Actuate;

	import devnull.ViewPort;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ViewPort extends EventDispatcher {
		public static const UPDATE:String = "updateViewPort";

		public var width:Number = 800;
		public var height:Number = 600;
		public var x:Number = 100;
		public var y:Number = 100;
		private var _zoom:Number = 3;

		public function transformX(x:Number):Number {
			return (x * _zoom) - (this.x*_zoom) + width * 0.5;
		}

		public function transformY(y:Number):Number {
			var transY:Number = (y * _zoom) - (this.y*_zoom) + height * 0.5;
			return transY;
		}


		public function updateViewPort():void {
			dispatchEvent(new Event(ViewPort.UPDATE));
		}

		public function centerOnPoint(x:Number, y:Number, zoom:Number = -1):void {
			if(zoom >-1)
				_zoom = zoom;

			this.x = x;
			this.y = y;
			updateViewPort();
		}

		public function restore():void {
			Actuate.stop(this);
			this.x = 100;
			this.y = 100;
			_zoom = 3;
			updateViewPort();
		}

		public function get zoom():Number {
			return _zoom;
		}

		public function set zoom(value:Number):void {
			_zoom = value;
			updateViewPort();
		}


		public function tweenToZoom(value:Number, dur:Number):void {
			Actuate.tween(this, dur, {zoom:value});
		}

		public function tweenToCenterOnPoint(toX:Number, toY:Number, duration:Number):void {
			Actuate.tween(this, duration, {x:toX, y:toY}).onUpdate(updateViewPort);
		}
	}
}
