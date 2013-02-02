/**
 *
 * @author Tommy Salomonsson
 */
package devnull.events {
	import flash.events.Event;

	public class StarEvent extends Event {
		public static const STAR_CLICKED:String = "starClicked";
		private var _star:Star;


		public function StarEvent(type:String, star:Star) {
			super(type);
			_star = star;
		}


		override public function clone():Event {
			return new StarEvent(type, _star);
		}

		public function get star():Star {
			return _star;
		}
	}
}
