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
		
		
		
		public function Planet(vp:ViewPort, data:Object)
		{
			_vp = vp;
			_data = data;
			_vp.addEventListener(ViewPort.UPDATE, updateCoordinates);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			var planetRadius:Number = _data.radius / 1000;
			
			this.graphics.beginFill( Math.random()*0xffffff, .8 );
			this.graphics.drawCircle( 0, 0, 2 * planetRadius );
			this.graphics.endFill();

			var tf:SpaceText = new SpaceText(_data.planet_no);
			tf.x = -( tf.width * 0.5 );
			tf.y = 5 * 0.5 + 2;
			addChild(tf);
			
			updateCoordinates();
			
			useHandCursor = true;
			buttonMode = true;
		}

		private function updateCoordinates(event:Event=null):void {
			this.x = _vp.transformX(_data.x);
			this.y = _vp.transformY(_data.y);
		}

		private function destroy(event:Event):void {
			_vp.removeEventListener(ViewPort.UPDATE, updateCoordinates);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}

		public function get originalX():Number 		{ 	return _data.x;			}
		public function get originalY():Number 		{ 	return _data.y;			}
		override public function get name():String	{	return _data.planet_no;	}
	}
}
