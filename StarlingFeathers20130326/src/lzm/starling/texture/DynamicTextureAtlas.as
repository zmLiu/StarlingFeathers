package lzm.starling.texture
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import lzm.starling.STLConstant;
	import lzm.util.MaxRectsBinPack;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	/**
	 * 动态纹理 
	 * @author zmLiu
	 * 
	 */	
	public class DynamicTextureAtlas extends RenderTexture
	{
		
		private var _maxRect:MaxRectsBinPack;
		
		private var _textureRegion:Dictionary;//纹理的位置以及大小
		
		public function DynamicTextureAtlas(width:int, height:int)
		{
			super(width, height, true, STLConstant.scale);
			_maxRect = new MaxRectsBinPack(512,512);
			_textureRegion = new Dictionary();
		}
		
		/**
		 * 添加一个纹理 
		 * @param name
		 * @param texture
		 * @return 
		 * 
		 */		
		public function addTexture(name:String,texture:Texture):Rectangle{
			var rect:Rectangle = _maxRect.insert(texture.width,texture.height,MaxRectsBinPack.BESTSHORTSIDEFIT);
			if(rect.width == 0 || rect.height == 0){//已经无法插入纹理了
				return null;
			}
			
			var image:Image = new Image(texture);
			image.x = rect.x;
			image.y = rect.y;
			
			_textureRegion[name] = rect;
			draw(image);
			
			return rect;
		}
		
		/**
		 * 获取一个纹理
		 * */
		public function getTexture(name:String):Texture{
			var frame:Rectangle = _textureRegion[name];
			if(frame == null) return null;
			return Texture.fromTexture(this,frame);
		}
		
		/**
		 *  获取一个纹理集合
		 */		
		public function getTextures(prefix:String):Vector.<Texture>{
			var textures:Vector.<Texture> = new Vector.<Texture>();
			var k:String;
			for(k in _textureRegion){
				if(k.indexOf(prefix) == 0){
					textures.push(getTexture(k));
				}
			}
			return textures;
		}
		
	}
}