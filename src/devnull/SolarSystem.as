/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import devnull.events.NavigationEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SolarSystem extends Sprite {
		private var _vp:ViewPort;
		private var _map:BitmapData;
		private var _data:Object;

		private var _stars:Vector.<Star>;
		private var _planets:Vector.<Planet>;
		private var _edge:Edge;
		private var _selectedStar:Star;
		
		
		public function SolarSystem(vp:ViewPort) {
			_vp = vp;
			addChild(new StarBackground(_vp));
			
			_stars = new <Star>[];
			_planets = new <Planet>[];
			_edge = new Edge();
			_edge.addEventListener(MouseEvent.CLICK, onEdgeClicked);
			addChild(_edge);
		}

		

		public function draw(data:Object):void {
			_data = data;
			for each( var starObject:Object in _data.stars )
			{
				var star:Star = new Star( _vp, starObject );
				_stars.push(star);
				renderStar( star );
			}
		}

		private function renderStar( star:Star ):void
		{
			star.addEventListener( MouseEvent.CLICK, onStarClicked );
			addChild( star );
		}

		private function onStarClicked(event:MouseEvent):void {
			
			if (!(event.target is Star))
				return;
			
			destroyPlanets();
			var star:Star = Star( event.target );
			_selectedStar = star;

			var zoom:Number = Math.random() * 3 + 2;
			_vp.tweenToZoom(zoom, 2);
			_vp.tweenToCenterOnPoint(star.originalX, star.originalY, 2);
			
			dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_STAR, star.name));
		}

		public function drawPlanets( _planetMap:Object ):void
		{
			if( _planetMap.system != null )
			{
				trace( "At star: "+ _planetMap.system.name );
				
				for each( var planetData:Object in _planetMap.system.planetarray )
				{
					var planet:Planet = new Planet( _vp, planetData );
					planet.addEventListener(MouseEvent.CLICK, onPlanetClicked);
					addChild(planet);
					_planets.push(planet);
				}
				_vp.tweenToZoom( 40, 2 );
				
			}
			addChild(_edge);
			
		}

		private function onPlanetClicked(event:MouseEvent):void {
			var planet:Planet = event.target as Planet;
			if (planet != null) {
				_vp.tweenToCenterOnPoint(planet.originalX, planet.originalY, 1);
				_vp.tweenToZoom(65, 1);
				
				dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PLANET, planet.name));
			}
		}

		private function onEdgeClicked(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PLANET, _edge.name));
			
			if (_selectedStar != null)
			{
				_vp.tweenToCenterOnPoint(_selectedStar.originalX, _selectedStar.originalY, 2);
			}
			_vp.tweenToZoom(40, 2);
		}

		public function destroyPlanets():void {
			for each(var planet:Planet in _planets) {
				planet.removeEventListener(MouseEvent.CLICK, onPlanetClicked);
				removeChild(planet);
			}
			_planets = new <Planet>[];
			
			if (_edge.parent)
				removeChild(_edge);
		}
	}
}
