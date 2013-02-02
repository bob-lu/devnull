package
{
	import devnull.SolarSystem;
	import devnull.SpaceShip;
	import devnull.ViewPort;
	import devnull.events.StarEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class Main extends Sprite
	{
		private var _loader:URLLoader;
		private var _data:Object;
		private var _timer:Timer;
		private var _shipLoader:URLLoader;
		private var _ship:SpaceShip;
		private var _vp:ViewPort;
		private var _solarSystem:SolarSystem;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, onLoaded );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			
			_vp = new ViewPort();
			_vp.zoom = 3;
			
			_solarSystem = new SolarSystem(_vp);
			_solarSystem.addEventListener(StarEvent.STAR_CLICKED, onStarClicked);
			_ship = new SpaceShip(_vp);
			addChild(_solarSystem);
			addChild( _ship );
			
			_loader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=longrange" ) );
		}

		private function onError( event:IOErrorEvent ):void
		{
			trace( "Fail: "+ event.toString() );
		}

		private function onLoaded( event:Event ):void
		{
			_data = JSON.parse( _loader.data );
			
			_solarSystem.draw(_data);
			_timer = new Timer( 400 );
			_timer.addEventListener( TimerEvent.TIMER, onTimerEvent );
			_timer.start();
		}

		private function onTimerEvent( event:TimerEvent ):void
		{
			_shipLoader = new URLLoader();
			_shipLoader.addEventListener( Event.COMPLETE, moveShip );
			_shipLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			_shipLoader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=ship&arg=show" ) );
		}

		private function moveShip( event:Event ):void
		{
			try
			{
				var data:Object = JSON.parse( _shipLoader.data );
				_ship.setPosition( data.unix, data.uniy );
			}
			catch( e:Error )
			{
				trace( "Error parsing json: "+ e.message );
			}
		}

		
		
		private function onStarClicked( event:StarEvent ):void
		{
			var starName:String = event.star.name;
			var selectLoader:URLLoader = new URLLoader();
			selectLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			selectLoader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=ship&arg=setunidest&arg2="+ encodeURI( starName ) ) );
		}
	}
}
