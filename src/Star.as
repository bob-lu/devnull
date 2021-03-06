/**
 * User: Bob Dahlberg
 * Date: 2/2/13
 * Time: 10:35 AM
 */
package
{
	import devnull.SpaceText;
	import devnull.ViewPort;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Star extends Sprite
	{
		private var _data:Object;
		private var _class:String;
		private var _planets:String;
		private var _name:String;
		private var _vp:ViewPort;
		
		public function Star(vp:ViewPort, data:Object)
		{
			_data = data;
			
			_vp = vp;
			_vp.addEventListener(ViewPort.UPDATE, updatePosition);
			updatePosition();
			
			_class = data["class"];
			_planets = data["planets"];
			_name = data["name"];
			
			graphics.beginFill( 0xffff00, 0.3 );
			graphics.drawCircle( 0, 0, 2 );
			graphics.endFill();
			graphics.beginFill( 0xffff00, 0.3 );
			graphics.drawCircle( 0, 0, 4 );
			graphics.endFill();
			graphics.beginFill( 0xffff00, 0.3 );
			graphics.drawCircle( 0, 0, 5 );
			graphics.endFill();
			graphics.beginFill( 0xffff00, 0.3 );
			graphics.drawCircle( 0, 0, 7 );
			graphics.endFill();
			
			useHandCursor = true;
			buttonMode = true;

			var tf:SpaceText = new SpaceText(_name +" - "+_class +" ("+ _planets +")");
			tf.x = -( tf.width * 0.5 );
			tf.y = 5 * 0.5 + 4;
			addChild(tf);
		}

		private function updatePosition(e:Event=null):void {
			this.x = _vp.transformX(_data.x);
			this.y = _vp.transformY(_data.y);
		}
		
		public function get originalX():Number {
			return _data.x;
		}
		public function get originalY():Number {
			return _data.y;
		}

		override public function get name():String
		{
			return _name;
		}
	}
}
