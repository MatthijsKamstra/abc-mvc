/*
 * Edited by sakri june 23 07 to make button width dependent on label width
 */
package mvc.utils {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class EasyButton extends SimpleButton {

		private var label_str : String;
		private var _label_width : Number = 80;
		private var _label_height : Number = 22;
		private var _corner:int = 0;
		
		public var padding : uint = 5;
		

		/**
		 * @example		var eb : EasyButton = new EasyButton(_array[i].toString());
		 * 				addChild(eb);
		 * @param 	labelText		txt used for button
		 */
		public function EasyButton(labelText : String = "Submit") {
			label_str = labelText;
			useHandCursor = true;
			var sample_label : TextField = createLabel();
			var sample_holder : Sprite = new Sprite();
			sample_holder.addChild(sample_label);
			var bounds : Rectangle = sample_holder.getBounds(sample_label);
			_label_width = bounds.width;
			_label_height = bounds.height;
			upState = createUpState();
			overState = createOverState();
			downState = createDownState();
			hitTestState = createUpState();
		}

		private function createUpState() : Sprite {
			var state : Sprite = new Sprite();
			var upShape : Shape = new Shape();
			upShape.graphics.lineStyle(1, 0xAAAAAA, 1, true);
			upShape.graphics.beginFill(0xEFEFEF);
			upShape.graphics.drawRoundRect(0, 0, padding * 2 + _label_width, padding * 2 + _label_height, _corner, _corner);
			var label_txt : TextField = createLabel();
			positionLabel(label_txt, upShape);
			state.addChild(upShape);
			state.addChild(label_txt);
			return state;
		}

		private function createOverState() : Sprite {
			var overShape : Shape = new Shape();
			overShape.graphics.lineStyle(1, 0xBBCCAA, 1, true);
			overShape.graphics.beginFill(0xEFEFEF);
			overShape.graphics.drawRoundRect(0, 0, padding * 2 + _label_width, padding * 2 + _label_height, _corner, _corner);
			var label_txt : TextField = createLabel();
			label_txt.textColor = 0x778866;
			positionLabel(label_txt, overShape);
			var state : Sprite = new Sprite();
			state.addChild(overShape);
			state.addChild(label_txt);
			return state;
		}

		private function createDownState() : Sprite {
			var downShape : Shape = new Shape();
			downShape.graphics.lineStyle(1, 0xBBCCAA, 1, true);
			downShape.graphics.beginFill(0xDFEFCF);
			downShape.graphics.drawRoundRect(0, 0, padding * 2 + _label_width, padding * 2 + _label_height, _corner, _corner);
			var label_txt : TextField = createLabel();
			positionLabel(label_txt, downShape);
			var state : Sprite = new Sprite();
			state.addChild(downShape);
			state.addChild(label_txt);
			return state;
		}

		private function createLabel() : TextField {
			var label_txt : TextField = new TextField();
			label_txt.autoSize = TextFieldAutoSize.CENTER;
			label_txt.selectable = false;
			label_txt.text = label_str;
			var format : TextFormat = label_txt.getTextFormat();
			format.font = "_sans";
			format.align = TextFormatAlign.CENTER;
			label_txt.setTextFormat(format);
			return label_txt;
		}

		private function positionLabel(label : TextField, state : DisplayObject) : void {
			label.x = state.width / 2 - label.width / 2;
			label.y = state.height / 2 - label.height / 2;
		}
	}
}