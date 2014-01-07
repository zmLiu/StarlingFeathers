package lzm.starling.swf.components.feathers
{
	import feathers.controls.Button;
	
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	import lzm.starling.swf.components.ISwfComponent;

	public class FeathersButton extends Button implements ISwfComponent
	{
		
		public function initialization(componetContent:SwfSprite):void{
			var defaultSkin:DisplayObject = componetContent.getChildByName("_defaultSkin");
			var upSkin:DisplayObject = componetContent.getChildByName("_upSkin");
			var downSkin:DisplayObject = componetContent.getChildByName("_downSkin");
			
			defaultSkin.removeFromParent();
			upSkin.removeFromParent();
			downSkin.removeFromParent();
			
			this.defaultSkin = defaultSkin;
			this.upSkin = upSkin;
			this.downSkin = downSkin;
			
			componetContent.removeFromParent(true);
		}
	}
}