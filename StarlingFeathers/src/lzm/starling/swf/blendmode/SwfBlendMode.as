package lzm.starling.swf.blendmode
{
	import starling.display.DisplayObject;

	public class SwfBlendMode
	{
		
		public static const modes:Object = {
			"auto":true,
			"none":true,
			"normal":true,
			"add":true,
			"multiply":true,
			"screen":true,
			"erase":true,
			"below":true
		}
			
		public static function setBlendMode(display:DisplayObject,blendMode:String):void{
			if(modes[blendMode]){
				display.blendMode = blendMode;
			}
		}
		
	}
}