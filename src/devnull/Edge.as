/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.display.Sprite;

	public class Edge extends Sprite {
		
		public function Edge() {

			this.x = 2;
			this.y = 2;
			
			useHandCursor = true;
			buttonMode = true;
			
			var tf:SpaceText = new SpaceText("-->Go to the EdGE!<--");
			addChild(tf);
			
			this.graphics.beginFill(0xffffff, 0.2);
			this.graphics.drawRect(0,0,tf.width,tf.height);
			this.graphics.endFill();
			
		}


		override public function get name():String {
			return "edge";
		}
	}
}
