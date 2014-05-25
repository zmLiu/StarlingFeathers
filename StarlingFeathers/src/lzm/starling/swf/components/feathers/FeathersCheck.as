package lzm.starling.swf.components.feathers
{
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.display.Scale9Image;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import lzm.starling.swf.components.ISwfComponent;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.Image;
	import starling.text.TextField;
	
	public class FeathersCheck extends Check implements ISwfComponent
	{
		public function FeathersCheck()
		{
			super();
		}
		
		public function initialization(componetContent:SwfSprite):void{
			var _defaultSkin:Scale9Image = componetContent.getScale9Image("_defaultSkin");
			var _defaultSelectedSkin:Image = componetContent.getImage("_defaultSelectedSkin");
			var _downSkin:Scale9Image = componetContent.getScale9Image("_downSkin");
			var _downSelectedSkin:Image = componetContent.getImage("_downSelectedSkin");
			var _disabledSkin:Scale9Image = componetContent.getScale9Image("_disabledSkin");
			var _disabledSelectedSkin:Image = componetContent.getImage("_disabledSelectedSkin");
			
			var _labelTextField:TextField = componetContent.getTextField("_labelTextField");
			
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = _defaultSkin.textures;
			iconSelector.defaultSelectedValue = _defaultSelectedSkin.texture;
			iconSelector.setValueForState(_downSkin.textures, Button.STATE_DOWN, false);
			iconSelector.setValueForState(_disabledSkin.textures, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(_downSelectedSkin.texture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(_disabledSelectedSkin.texture, Button.STATE_DISABLED, true);
			
			this.stateToIconFunction = iconSelector.updateValue;
			
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
				isSelected:isSelected
			};
		}
		
		public function set editableProperties(properties:Object):void{
			for(var key:String in properties){
				this[key] = properties[key];
			}
		}
	}
}