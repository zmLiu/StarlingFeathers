package lzm.starling.swf.components.feathers
{
	import feathers.controls.ProgressBar;
	
	import lzm.starling.swf.components.ISwfComponent;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	
	public class FeathersProgressBar extends ProgressBar implements ISwfComponent
	{
		public function FeathersProgressBar()
		{
			super();
		}
		
		public function initialization(componetContent:SwfSprite):void{
			var _backgroundSkin:DisplayObject = componetContent.getChildByName("_backgroundSkin");
			var _backgroundDisabledSkin:DisplayObject = componetContent.getChildByName("_backgroundDisabledSkin");
			var _fillSkin:DisplayObject = componetContent.getChildByName("_fillSkin");
			var _fillDisabledSkin:DisplayObject = componetContent.getChildByName("_fillDisabledSkin");
			
			addChild(_backgroundSkin);
			addChild(_backgroundDisabledSkin);
			addChild(_fillSkin);
			addChild(_fillDisabledSkin);
			
			this.backgroundSkin = _backgroundSkin;
			this.backgroundDisabledSkin = _backgroundDisabledSkin;
			this.fillSkin = _fillSkin;
			this.fillDisabledSkin = _fillDisabledSkin;
			
			this.minimum = 0;
			this.maximum = 1;
			this.value = 0.3;
			
			componetContent.removeFromParent(true);
		}
		
		public function get editableProperties():Object{
			return {
				isEnabled:isEnabled,
				minimum:minimum,
				maximum:maximum,
				value:value
			};
		}
		
		public function set editableProperties(properties:Object):void{
			for(var key:String in properties){
				this[key] = properties[key];
			}
		}
	}
}