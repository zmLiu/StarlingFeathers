package lzm.starling.display.ainmation.bone
{
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class BoneAnimationFactory
	{
		private var _imagesData:Object;
		private var _moviesData:Object;
		
		private var _assetManager:AssetManager;
		
		/**
		 * 动画工厂
		 * @param movies		动画数据
		 * @assetManager		资源库
		 */		
		public function BoneAnimationFactory(movies:Object,assetManager:AssetManager)
		{
			if(movies){
				_imagesData = movies["images"];
				_moviesData = movies["movies"];
			}
			
			_assetManager = assetManager;
		}
		
		/**设置/获取 数据*/		
		public function get movies():Object{
			return {images:_imagesData,movies:_moviesData};
		}
		public function set movies(value:Object):void{
			_imagesData = value["images"];
			_moviesData = value["movies"];
		}
		
		/**设置/获取 资源*/		
		public function get assetManager():AssetManager{
			return _assetManager;
		}
		public function set assetManager(value:AssetManager):void{
			_assetManager = value;
		}
		
		/**
		 * 创建动画 
		 * @param movieName		动画名字
		 * @param fps			帧数
		 * @return 
		 * 
		 */		
		public function createAnimation(movieName:String,fps:int = 24):BoneAnimation{
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
			
			var texture:Texture = _assetManager.getTexture(imageName);
			
			var image:Image = new Image(texture);
			image.pivotX = -imageData.pivotX;
			image.pivotY = -imageData.pivotY;
			
			return image;
		}
		
		/**
		 * @return 所有动画的名字
		 */		
		public function get movieNames():Array{
			var names:Array = [];
			for(var k:String in _moviesData){
				names.push(k);
			}
			return names;
		}
	}
}