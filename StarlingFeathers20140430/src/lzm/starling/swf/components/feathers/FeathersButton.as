package lzm.starling.swf.components.feathers
{
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	
	import lzm.starling.swf.components.ISwfComponent;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;

	public class FeathersButton extends Button implements ISwfComponent
	{
		
		public function initialization(componetContent:SwfSprite):void{
			var _upSkin:DisplayObject = componetContent.getChildByName("_upSkin");
			var _selectUpSkin:DisplayObject = componetContent.getChildByName("_selectUpSkin");
			var _downSkin:DisplayObject = componetContent.getChildByName("_downSkin");
			var _disabledSkin:DisplayObject = componetContent.getChildByName("_disabledSkin");
			var _selectDisabledSkin:DisplayObject = componetContent.getChildByName("_selectDisabledSkin");
			
			var _labelTextField:TextField = componetContent.getTextField("_labelTextField");
			
			this.defaultSkin = _upSkin;
			if(_selectUpSkin) this.defaultSelectedSkin = _selectUpSkin;
			if(_downSkin) this.downSkin = _downSkin;
			if(_disabledSkin) this.disabledSkin = _disabledSkin;
			if(_selectDisabledSkin) this.selectedDisabledSkin = _selectDisabledSkin;
			
			if(_labelTextField){
				var textFormat:TextFormat = new TextFormat();
				textFormat.font = _labelTextField.fontName;
				textFormat.size = _labelTextField.fontSize;
				textFormat.color = _labelTextField.color;
				textFormat.bold = _labelTextField.bold;
				textFormat.italic = _labelTextField.italic;
				
				this.defaultLabelProperties.textFormat = textFormat;
				this.label = _labelTextField.text;
			}
			
			componetContent.removeFromParent(true);
		}
		
		public function get editableProperties():Object{
			return {
				label:label,
				isEnabled:isEnabled
			};
		}
		
		public function set editableProperties(properties:Object):void{
			for(var key:String in properties){
				this[key] = properties[key];
			}
		}
		
	}
}