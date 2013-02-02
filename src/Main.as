package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Main extends Sprite
	{
		private var _loader:URLLoader;
		private var _data:Object;
		private var _map:BitmapData;
		private const MAP_WIDTH:Number = 800;
		private const MAP_HEIGHT:Number = 600;
		private const MAP_ZOOM:Number = 2.3;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;

			_map = new BitmapData(MAP_WIDTH, MAP_HEIGHT, false, 0);
			var bmp:Bitmap = new Bitmap(_map);
			addChild(bmp);
			
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, onLoaded );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			
			_loader.load( new URLRequest( "https://lostinspace.lanemarknad.se:8000/api2/?session=deb6dcda-3330-44df-b622-d955215c6483&command=longrange" ) );
		}

		private function onError( event:IOErrorEvent ):void
		{
			trace( "Fail: "+ event.toString() );
		}

		private function onLoaded( event:Event ):void
		{
			_data = JSON.parse( _loader.data );


			_map.fillRect( new Rectangle( 0, 0, MAP_WIDTH, MAP_HEIGHT ), 0x000000 );
			for each( var starObject:Object in _data.stars )
			{
				var star = new Star( starObject );
				renderStar( star );
			}
		}

		private function renderStar( star:Star ):void
		{
			star.x *= MAP_ZOOM;
			star.y *= MAP_ZOOM;
			star.addEventListener( MouseEvent.CLICK, onClick );
			addChild( star );
//			_map.draw(tempHolder);
		}
		
		private function onClick( event:MouseEvent ):void
		{
			var star:Star = Star( event.target );
			trace( star.name );
		}
	}
}
