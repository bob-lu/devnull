/**
 * User: Bob Dahlberg
 * Date: 2/2/13
 * Time: 11:49 AM
 */
package devnull
{
	import flash.events.Event;

	public class APIEvent extends Event
	{
		public static const SHIP_MOVE:String = "ship_move";
		private var _data:Object;
		private var _ftl:Boolean;
		private var _y:Number;
		private var _x:Number;
		
		public function APIEvent( type:String, x:Number, y:Number, ftl:Boolean )
		{
			super( type, false, false );
			_ftl = ftl;
			_x = x;
			_y = y;
		}

		public function get ftl():Boolean
		{
			return _ftl;
		}

		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}
	}
}
