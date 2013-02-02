/**
 * User: Bob Dahlberg
 * Date: 2/2/13
 * Time: 11:23 AM
 */
package devnull
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class APIHelper extends EventDispatcher
	{
		private static const URL:String = "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483";
		private var _shipLoader:URLLoader;
		private var _update:Timer;
		private var _pos:Object
		private var _samePosCount:int;
		private var _starmapLoader:URLLoader;
		private var _starMap:Object;
		private var _solarSystem:SolarSystem;
		private var _planetLoader:URLLoader;
		private var _planetMap:Object;
		
		public function APIHelper( solarSystem:SolarSystem )
		{
			_solarSystem = solarSystem;
			_update = new Timer( 300 );
			_update.addEventListener( TimerEvent.TIMER, onTimer );
			_samePosCount = 0;
		}
		
		public function getLongRange():void
		{
			if( _starmapLoader == null )
			{
				_starmapLoader = new URLLoader();
			}
			_starmapLoader.addEventListener( Event.COMPLETE, onStarMapLoaded );
			_starmapLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			_starmapLoader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=longrange" ) );
		}

		private function onStarMapLoaded( event:Event ):void
		{
			_starMap = JSON.parse( _starmapLoader.data );
			_solarSystem.draw( _starMap );
			getShipPos();
		}
		
		public function getShortRange():void
		{
			if( _planetLoader == null )
			{
				_planetLoader = new URLLoader();
			}
			_planetLoader.addEventListener( Event.COMPLETE, onPlanetsLoaded );
			_planetLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			_planetLoader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=shortrange" ) );
		}

		private function onPlanetsLoaded( event:Event ):void
		{
			var cache:Object = _planetMap;
			_planetMap = JSON.parse( _planetLoader.data );
			trace( "Loaded planets" );
			
			try
			{
				if( cache == null || _planetMap["system"].name != cache["system"].name )
				{
					trace( "Parsed planets" );
					for( var i:int = 0; i < _planetMap.system.planetarray.length; i++ )
					{
						_planetMap.system.planetarray[i].x = (_planetMap.system.planetarray[i].x - 100) / Main.PLANET_RATIO; 
						_planetMap.system.planetarray[i].y = (_planetMap.system.planetarray[i].y - 100) / Main.PLANET_RATIO; 
					}
					_solarSystem.drawPlanets( _planetMap );
				}
			}
			catch( e:Error ){}
		}
		
		public function getShipPos():void
		{
			_shipLoader = new URLLoader();
			_shipLoader.addEventListener( Event.COMPLETE, onShipPos );
			_shipLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			_shipLoader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=ship&arg=show" ) );
		}

		private function onShipPos( e:Event ):void
		{
			try
			{
				var cache:Object = _pos;
				_pos = JSON.parse( _shipLoader.data );
				
				dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, _pos ) );
				
				var movingInUniverse:Boolean = ( _pos.unix != cache.unix || _pos.uniy != cache.uniy );
				var movingInSystem:Boolean = ( _pos.systemx != cache.systemx || _pos.systemy != cache.systemy );
				
				if( movingInSystem || movingInUniverse )
				{
					_samePosCount = 0;
					return;
				}

				_samePosCount++;
				if( _samePosCount > 5 )
				{
					trace( "Stopping counter" );

					if( _planetMap == null )
					{
						getShortRange();
					}
					
					_samePosCount = 0;
					_update.stop();
				}
			}
			catch( e:Error )
			{
				trace( "Error parsing json: "+ e.message );
			}
		}
		
		private function onTimer( event:TimerEvent ):void
		{
			getShipPos();
		}

		public function gotoStarsystem( name:String ):void
		{
			var selectLoader:URLLoader = new URLLoader();
			selectLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			selectLoader.load( new URLRequest( URL +"&command=ship&arg=setunidest&arg2="+ encodeURI( name ) ) );
			_planetMap = null;
			if( !_update.running )
				_update.start();
		}

		/*
		public function gotoPlanet( name:String ):void
		{
			var selectLoader:URLLoader = new URLLoader();
			selectLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			selectLoader.load( new URLRequest( URL +"&command=ship&arg=setunidest&arg2="+ encodeURI( name ) ) );
			if( !_update.running )
				_update.start();
		}
		*/

		private function onError( e:IOErrorEvent ):void
		{
			trace( "URL Request went wrong: "+ e );
		} 
	}
}
