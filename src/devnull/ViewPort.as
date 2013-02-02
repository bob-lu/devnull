/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import devnull.ViewPort;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ViewPort extends EventDispatcher{
		public static const UPDATE:String = "updateViewPort";
		
		public var width:Number = 800;
		public var height:Number = 600;
		public var x:Number = 0;
		public var y:Number = 0;
		public var zoom:Number = 1;

		public function transformX(x:Number):Number {
			return (x * zoom) - this.x;
		}

		public function transformY(y:Number):Number {
			return (y * zoom) - this.y;
		}


		public function updateViewPort():void {
			dispatchEvent(new Event(ViewPort.UPDATE));
		}
		
	}
}
