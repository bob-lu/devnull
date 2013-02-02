/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.display.Sprite;
	import flash.events.Event;

	public class Planet extends Sprite{
		private var _vp:ViewPort;
		private var _data:Object;
		
		
		
		public function Planet(vp:ViewPort, data:Object) {
			_vp = vp;
			_data = data;
			_vp.addEventListener(ViewPort.UPDATE, updateCoordinates);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
			
			updateCoordinates();
		}

		private function updateCoordinates(event:Event=null):void {
			this.x = _vp.transformX(_data.x);
			this.y = _vp.transformY(_data.y);
		}

		private function destroy(event:Event):void {
			_vp.removeEventListener(ViewPort.UPDATE, updateCoordinates);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
	}
}
