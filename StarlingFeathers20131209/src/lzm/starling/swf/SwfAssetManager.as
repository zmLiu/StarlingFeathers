package lzm.starling.swf
{
	import flash.utils.Dictionary;
	
	import feathers.display.Scale9Image;
	
	import lzm.starling.display.Button;
	import lzm.starling.swf.display.ShapeImage;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.Image;
	import starling.utils.AssetManager;

	/**
	 * Swf资源集中管理工具 
	 * @author zmliu
	 * 
	 */	
	public class SwfAssetManager
	{
		
		private var _verbose:Boolean = false;
		
		private var _loadQueue:Array;
		private var _isLoading:Boolean;
		
		private var _swfs:Dictionary;
		
		private var _scaleFactor:Number;
		private var _useMipmaps:Boolean;
		
		public function SwfAssetManager(scaleFactor:Number=1, useMipmaps:Boolean=false)
		{
			_loadQueue = [];
			_isLoading = false;
			
			_swfs = new Dictionary();
			
			_scaleFactor = scaleFactor;
			_useMipmaps = useMipmaps;
		}
		
		/**
		 * 添加一个swf到队列中 
		 * @param name		swf名字
		 * @param resource	swf所需的资源集合
		 */		
		public function enqueue(name:String,resource:Array):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			if(getSwf(name) != null){
				log("Swf已经存在");
			}else{
				_loadQueue.push([name,resource]);
			}
		}
		
		/**
		 * 批量添加swf到加载队列 
		 * @param swfs	[[swf名字1,[swf资源1,swf资源2]],[swf名字1,[swf资源1,swf资源2]]]
		 */		
		public function enqueueWithArray(swfs:Array):void{
			var len:int = swfs.length;
			var swfAsset:Array;
			for (var i:int = 0; i < len; i++) {
				swfAsset = swfs[i];
				enqueue(swfAsset[0],swfAsset[1]);
			}
		}
		
		/**
		 * 开始加载队列 
		 */		
		public function loadQueue(onProgress:Function):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			
			var swfAsset:Array;
			var numSwfAsset:int = _loadQueue.length;
			var currentRatio:Number = 0;
			var avgRatio:Number = 1 / numSwfAsset;
			
			if(numSwfAsset == 0){
				log("没有需要加载的Swf");
				onProgress(1);
				return;
			}
			
			_isLoading = true;
			
			loadNext();
			
			function loadNext():void{
				swfAsset = _loadQueue.shift();
				if(getSwf(swfAsset[0]) != null){
					loadNext();
				}else{
					load();
				}
			}
			
			function load():void{
				var swfName:String = swfAsset[0];
				var swfResource:Array = swfAsset[1];
				var assetManager:AssetManager = new AssetManager(_scaleFactor,_useMipmaps);
				
				assetManager.verbose = verbose;
				
				for each (var assetObject:Object in swfResource) {
					assetManager.enqueue(assetObject);
				}
				
				assetManager.loadQueue(function(ratio:Number):void{
					if(ratio == 1){
						addSwf(swfName,new Swf(assetManager.getByteArray(swfName),assetManager));
						loadComplete();
					}else{
						onProgress(currentRatio + avgRatio*ratio);
					}
				});
			}
			
			function loadComplete():void{
				currentRatio = _loadQueue.length ? 1.0 - (_loadQueue.length / numSwfAsset) : 1.0;
				
				onProgress(currentRatio);
				
				if(currentRatio == 1){
					_isLoading = false;
				}else{
					loadNext();
				}
			}
		}
		
		/**
		 * @param name	swf名字
		 * @return swf
		 */		
		public function getSwf(name:String):Swf{
			return _swfs[name];
		}
		
		/** 添加一个swf */
		public function addSwf(name:String,swf:Swf):Boolean{
			if(getSwf(name) != null){
				log("Swf已经存在");
				return false;
			}else{
				log("添加Swf:"+name);
				_swfs[name] = swf;
			}
			return true;
		}
		
		/** 删除一个swf */
		public function removeSwf(name:String,dispose:Boolean=false):void{
			var swf:Swf = getSwf(name);
			if(swf){
				if(dispose){
					swf.dispose(dispose);
				}
				delete _swfs[name];
			}
		}
		
		/** 清除所有swf */
		public function clearSwf():void{
			for each (var swf:Swf in _swfs) {
				swf.dispose(true);
			}
			_swfs = new Dictionary();
		}
		
		/** 创建Sprite */
		public function createSprite(name:String):SwfSprite{
			for each (var swf:Swf in _swfs) if(swf.hasSprite(name)) return swf.createSprite(name);
			return null;
		}
		/** 创建MovieClip */
		public function createMovieClip(name:String):SwfMovieClip{
			for each (var swf:Swf in _swfs) if(swf.hasMovieClip(name)) return swf.createMovieClip(name);
			return null;
		}
		/** 创建Image */
		public function createImage(name:String):Image{
			for each (var swf:Swf in _swfs) if(swf.hasImage(name)) return swf.createImage(name);
			return null;
		}
		/** 创建Button */
		public function createButton(name:String):Button{
			for each (var swf:Swf in _swfs) if(swf.hasButton(name)) return swf.createButton(name);
			return null;
		}
		/** 创建S9Image */
		public function createS9Image(name:String):Scale9Image{
			for each (var swf:Swf in _swfs) if(swf.hasS9Image(name)) return swf.createS9Image(name);
			return null;
		}
		/** 创建ShapeImage */
		public function createShapeImage(name:String):ShapeImage{
			for each (var swf:Swf in _swfs) if(swf.hasShapeImage(name)) return swf.createShapeImage(name);
			return null;
		}
		/** 创建Component */
		public function createComponent(name:String):*{
			for each (var swf:Swf in _swfs) if(swf.hasComponent(name)) return swf.createComponent(name);
			return null;
		}
		
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(value:Boolean):void { _verbose = value; }
		private function log(message:String):void{
			if(_verbose){
				trace("SwfAssetManager:"+message);
			}
		}
		
	}
}