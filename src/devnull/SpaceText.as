/**
 *
 * @author Tommy Salomonsson
 */
package devnull {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SpaceText extends TextField{

		public function SpaceText(str:String = "") {
			this.selectable = false;
			this.mouseEnabled = false;
			this.autoSize = TextFieldAutoSize.LEFT;
			
			var format:TextFormat = new TextFormat("verdana", 10, 0x00ff00, false);
			this.defaultTextFormat = format;
			
			this.text = str;
		}
	}
}
