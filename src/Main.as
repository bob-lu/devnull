package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

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
			drawMap( _data.stars, 0, 0 );
		}
		
		private function drawMap(listOfStars:Array, mapX:Number, mapY:Number):void {

			_map.fillRect( new Rectangle( 0, 0, MAP_WIDTH, MAP_HEIGHT ), 0x000000 );

			for each(var star:Object in listOfStars) {

				var sX:Number = (star.x - mapX) * MAP_ZOOM;
				var sY:Number = (star.y - mapY) * MAP_ZOOM;
				var sRadius:Number = 5 * MAP_ZOOM;

				var tempHolder:Sprite = new Sprite();
				tempHolder.graphics.beginFill(0xffff00, 0.6);
				tempHolder.graphics.drawCircle(sX, sY, sRadius);
				tempHolder.graphics.endFill();
				var tf:TextField = new TextField();
				tf.textColor = 0xffffff;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.text = star.name +" - "+star["class"] +" ("+ star.planets +")";
				tf.x = sX - tf.width * 0.5;
				tf.y = sY + sRadius * 0.5 + 2;
				tempHolder.addChild(tf);
				_map.draw(tempHolder);

			}

		}
	}
}
