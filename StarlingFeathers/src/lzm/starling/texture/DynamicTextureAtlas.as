package lzm.starling.texture
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import lzm.starling.STLConstant;
	import lzm.util.MaxRectsBinPack;
	
	import starling.display.DisplayObject;
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
		
		private var _textureRegionArray:Array;//纹理的位置以及大小
		private var _testureRegionDictionary:Dictionary;
		
		private var _padding:int = 1;
		
		/**
		 * 创建动态纹理 
		 * @param width		纹理宽
		 * @param height	纹理高
		 * @param padding	纹理间距
		 * 
		 */		
		public function DynamicTextureAtlas(width:int, height:int,padding:int = 1)
		{
			super(width, height, true, STLConstant.scale);
			_maxRect = new MaxRectsBinPack(512,512);
			_textureRegionArray = [];
			_testureRegionDictionary = new Dictionary();
			_padding = padding;
		}
		
		/**
		 * 添加一个纹理 
		 * @param name
		 * @param texture
		 * @return 
		 * 
		 */		
		public function addTexture(name:String,texture:Texture):Rectangle{
			var rect:Rectangle = _maxRect.insert(texture.width + _padding,texture.height + _padding,MaxRectsBinPack.BESTSHORTSIDEFIT);
			if(rect.width == 0 || rect.height == 0){//已经无法插入纹理了
				return null;
			}
			
			var image:Image = new Image(texture);
			image.x = rect.x;
			image.y = rect.y;
			
			rect.width -= _padding;
			rect.height -= _padding;
			
			_testureRegionDictionary[name] = rect;
			_textureRegionArray.push(name);
			draw(image);
			
			return rect;
		}
		
		/**
		 * 添加一个纹理 
		 * @param name
		 * @param displayObject
		 * @return 
		 * 
		 */		
		public function addTextureFromDisplayobject(name:String,displayObject:DisplayObject):Rectangle{
			var rect:Rectangle = _maxRect.insert(displayObject.width + _padding,displayObject.height + _padding,MaxRectsBinPack.BESTSHORTSIDEFIT);
			if(rect.width == 0 || rect.height == 0){//已经无法插入纹理了
				return null;
			}
			
			displayObject.x = rect.x;
			displayObject.y = rect.y;
			
			rect.width -= _padding;
			rect.height -= _padding;
			
			_testureRegionDictionary[name] = rect;
			_textureRegionArray.push(name);
			draw(displayObject);
			
			return rect;
		}
		
		/**
		 * 获取一个纹理
		 * */
		public function getTexture(name:String):Texture{
			var region:Rectangle = _testureRegionDictionary[name];
			if(region == null) return null;
			return Texture.fromTexture(this,region);
		}
		
		/**
		 *  获取一个纹理集合
		 */		
		public function getTextures(prefix:String):Vector.<Texture>{
			var textures:Vector.<Texture> = new Vector.<Texture>();
			var length:int = _textureRegionArray.length;
			var name:String;
			for (var i:int = 0; i < length; i++) {
				name = _textureRegionArray[i];
				if(name.indexOf(prefix) == 0){
					textures.push(getTexture(name));
				}
			}
			return textures;
		}
		
		/**
		 * 获取一个名字集合 
		 */		
		public function getNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
		{
			if (result == null) result = new <String>[];
			for each (var name:String in _textureRegionArray)
				if (name.indexOf(prefix) == 0)
					result.push(name);
			
			result.sort(Array.CASEINSENSITIVE);
			return result;
		}
		
	}
}