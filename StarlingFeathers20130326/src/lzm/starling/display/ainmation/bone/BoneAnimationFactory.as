package lzm.starling.display.ainmation.bone
{
	import lzm.starling.texture.DynamicTextureAtlas;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class BoneAnimationFactory
	{
		private var _imagesData:Object;
		private var _moviesData:Object;
		
		private var _textureAtals:TextureAtlas;
		private var _dynamicTextureAtals:DynamicTextureAtlas;
		
		/**
		 * 动画工程(textureAtals,dynamicTextureAtlas 任选其一即可)
		 * @param movies					动画数据
		 * @param textureAtals				纹理集
		 * @param dynamicTextureAtlas		动态纹理集
		 */		
		public function BoneAnimationFactory(movies:Object,textureAtals:TextureAtlas,dynamicTextureAtlas:DynamicTextureAtlas)
		{
			_imagesData = movies["images"];
			_moviesData = movies["movies"];
			
			_textureAtals = textureAtals;
			_dynamicTextureAtals = dynamicTextureAtlas;
		}
		
		/**
		 * 创建动画 
		 * @param movieName		动画名字
		 * @param fps			帧数
		 * @return 
		 * 
		 */		
		public function createAnimation(movieName:String,fps:int = 12):BoneAnimation{
			var movieData:Object = _moviesData[movieName];
			
			var movieImageNames:Array = movieData["images"];
			var movieImageCount:int = movieImageNames.length;
			var movieImages:Object  = new Object();
			for (var i:int = 0; i < movieImageCount; i++) {
				movieImages[movieImageNames[i]] = createImage(movieImageNames[i]);
			}
			return new BoneAnimation(movieData,movieImages,fps);
		}
		
		
		/**
		 * 创建一张图片 
		 * @param imageName
		 * @return
		 */		
		public function createImage(imageName:String):Image{
			var imageData:Object = _imagesData[imageName];
			
			var texture:Texture = _textureAtals == null ? _dynamicTextureAtals.getTexture(imageName) : _textureAtals.getTexture(imageName);
			
			var image:Image = new Image(texture);
			image.pivotX = -imageData.pivotX;
			image.pivotY = -imageData.pivotY;
			
			return image;
		}
	}
}