/**
 *
 * @author Tommy Salomonsson
 */
package devnull.events {
	import flash.events.Event;

	public class NavigationEvent extends Event {
		public static const NAVIGATE_TO_STAR:String = "navigateToStar";
		public static const NAVIGATE_TO_PLANET:String = "navigateToPlanet";
		private var _name:String;


		public function NavigationEvent(type:String, name:String) {
			super(type);
			_name = name;
		}


		override public function clone():Event {
			return new NavigationEvent(type, _name);
		}


		public function get name():String {
			return _name;
		}
	}
}
