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
		private var _goingToSystem:Boolean;
		private var _goingToPlanet:Boolean;
		private var _ftlLoaderLoader:URLLoader;
		private var _planetName:String;
		private var _systemName:String;
		
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
			_starmapLoader.load( new URLRequest( URL +"&command=longrange" ) );
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
			_planetLoader.load( new URLRequest( URL +"&command=shortrange" ) );
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
					var starX:Number = _planetMap.system.x;
					var starY:Number = _planetMap.system.y;
					
					trace( "Parsed planets" );
					for( var i:int = 0; i < _planetMap.system.planetarray.length; i++ )
					{
						_planetMap.system.planetarray[i].x = ( ( _planetMap.system.planetarray[i].x - 100) / Main.PLANET_RATIO ) + starX; 
						_planetMap.system.planetarray[i].y = ( ( _planetMap.system.planetarray[i].y - 100) / Main.PLANET_RATIO ) + starY; 
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
			_shipLoader.load( new URLRequest( URL +"&command=ship&arg=show" ) );
		}

		private function onShipPos( e:Event ):void
		{
			try
			{
				_pos = JSON.parse( _shipLoader.data );
				
				if( _goingToSystem )
				{
					dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, _pos.unix, _pos.uniy, false ) );
					if( _pos.currentsystem != _systemName )
					{
						// Moving
						trace( "moving in universe" );
					}
					else
					{
						// At star
						getShortRange();
						trace( "At Star - stopping counter" );
						_update.stop();
					}
				}
				else if( _goingToPlanet )
				{
					// Moving
					var x:Number = ( ( _pos.systemx - 100 ) / Main.PLANET_RATIO ) + _pos.unix;
					var y:Number = ( ( _pos.systemy - 100 ) / Main.PLANET_RATIO ) + _pos.uniy;
					dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, x, y, false ) );
					
					if( _pos.currentplanet != _planetName )
					{
						dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, x, y, false ) );
						trace( "moving in system" );
					}
					else
					{
						// At star
						trace( "At planet - stopping counter" );
						_update.stop();
					}
				}
				else
				{
					if( _update.running )
					{
						trace( "Only at start" );
						_update.stop();
					}
					dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, _pos.unix, _pos.uniy, false ) );
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
			_goingToPlanet = false;
			_goingToSystem = true;
			var selectLoader:URLLoader = new URLLoader();
			selectLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			selectLoader.load( new URLRequest( URL +"&command=ship&arg=setunidest&arg2="+ encodeURI( name ) ) );
			
			_planetMap = null;
			_systemName = name;

			_update.reset();
			_update.start();
		}
		
		public function gotoPlanet( name:String ):void
		{
			_goingToPlanet = true;
			_goingToSystem = false;
			var selectLoader:URLLoader = new URLLoader();
			selectLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			selectLoader.load( new URLRequest( URL +"&command=ship&arg=setsystemdest&arg2="+ encodeURI( name ) ) );

			_planetName = name;
			_update.reset();
			_update.start();
		}

		/*
		private function onFTLLoaded( e:Event ):void
		{
			try
			{
				var data:Object = JSON.parse( _ftlLoaderLoader.data );

				var starX:Number = _planetMap.system.x;
				var starY:Number = _planetMap.system.y;

				trace( "Parsed planets" );
				for( var i:int = 0; i < _planetMap.system.planetarray.length; i++ )
				{
					data.systemdest.x = ( ( data.systemdest.x - 100) / Main.PLANET_RATIO ) + starX;
					data.systemdest.y = ( ( data.systemdest.y - 100) / Main.PLANET_RATIO ) + starY;
				}
				
				dispatchEvent( new APIEvent( APIEvent.SHIP_MOVE, data.systemdest, _pos.uniy, true ) );
				_planetName = null;
			}
			catch( e:Error )
			{
				if( _planetName != null )
				{
					gotoPlanet( _planetName );
				}
			}
		}
		*/

		private function onError( e:IOErrorEvent ):void
		{
			trace( "URL Request went wrong: "+ e );
		} 
	}
}
