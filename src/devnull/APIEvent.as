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
		
		public function APIEvent( type:String, data:Object )
		{
			super( type, false, false );
			_data = data;
		}

		public function get data():Object
		{
			return _data;
		}
	}
}
