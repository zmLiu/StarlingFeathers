package lzm.starling.swf.display
{
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	public class SwfScale9Image extends Scale9Image
	{
		/** 导出的链接名 */
		public var classLink:String;
		
		public function SwfScale9Image(textures:Scale9Textures, textureScale:Number=1)
		{
			super(textures, textureScale);
		}
	}
}