/**
 * User: Bob Dahlberg
 * Date: 2/2/13
 * Time: 10:35 AM
 */
package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Star extends Sprite
	{
		private var _class:String;
		private var _planets:String;
		private var _name:String;
		
		public function Star( data:Object )
		{
			x = data.x;
			y = data.y;
			
			_class = data["class"];
			_planets = data["planets"];
			_name = data["name"];

			var tf:TextField = new TextField();
			tf.textColor = 0xffffff;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = _name +" - "+_class +" ("+ _planets +")";

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
			
			tf.x = -( tf.width * 0.5 );
			tf.y = 5 * 0.5 + 2;
			addChild(tf);
		}


		override public function get name():String
		{
			return _name;
		}
	}
}
