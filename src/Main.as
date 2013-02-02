package
{
	import com.eclecticdesignstudio.motion.Actuate;

	import devnull.APIEvent;
	import devnull.APIHelper;
	import devnull.SolarSystem;
	import devnull.SpaceShip;
	import devnull.ViewPort;
	import devnull.events.NavigationEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Main extends Sprite
	{
		private var _api:APIHelper;
		
		private var _ship:SpaceShip;
		private var _vp:ViewPort;
		private var _solarSystem:SolarSystem;
		public static const PLANET_RATIO:Number = 15;
		
		[SWF(width=800,height=600)]
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			
			_vp = new ViewPort();
			
			_solarSystem = new SolarSystem(_vp);
			_solarSystem.addEventListener(NavigationEvent.NAVIGATE_TO_STAR, onNavigateToStar);
			_solarSystem.addEventListener(NavigationEvent.NAVIGATE_TO_PLANET, onNavigateToPlanet);
			
			_ship = new SpaceShip(_vp);
			addChild(_solarSystem);
			addChild( _ship );

			_api = new APIHelper( _solarSystem );
			_api.addEventListener( APIEvent.SHIP_MOVE, onShipMove );
			_api.getLongRange();
		}

		

		private function onKeyUp(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A) {
				_vp.tweenToZoom(_vp.zoom - 1, 0.5);
			}
			if (event.keyCode == Keyboard.S) {
				_vp.tweenToZoom(_vp.zoom + 1, 0.5);
			}
			if (event.keyCode == Keyboard.SPACE) {
				_vp.restore();
			}
		}

		private function onShipMove( event:APIEvent ):void
		{
			var sx:Number = ( event.data["systemx"] - 100 ) / PLANET_RATIO;
			var sy:Number = ( event.data["systemy"] - 100 ) / PLANET_RATIO;
			var x:Number = event.data["unix"] + sx;
			var y:Number = event.data["uniy"] + sy;
			
			_ship.setPosition( x-sx, y-sy );
		}
		
		private function onNavigateToStar( event:NavigationEvent ):void
		{
			_api.gotoStarsystem( event.name );
		}

		private function onNavigateToPlanet(event:NavigationEvent):void {
			_api.gotoPlanet(event.name);
		}
	}
}
