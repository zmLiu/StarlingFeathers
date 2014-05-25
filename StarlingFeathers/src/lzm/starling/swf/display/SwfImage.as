package lzm.starling.swf.display
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class SwfImage extends Image
	{
		/** 导出的链接名 */
		public var classLink:String;
		
		public function SwfImage(texture:Texture)
		{
			super(texture);
		}
	}
}