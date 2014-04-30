package lzm.starling.display.ainmation
{
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 支持多个动画的MovieClip
	 * 默认中心点在中央
	 * @author lzm
	 */	
	public class MutiStateMovieClip extends Image implements IAnimatable
	{
		
		private var _textures:Vector.<Texture>;//当前的动画序列
		
		private var _numFrames:int;//总共有多少帧
		private var _currentFrame:int;//当前在第几帧
		private var _fps:Number;//帧频
		private var _loop:Boolean = true;//是否循环
		private var _totalTime:Number;//总事件
		private var _currentTime:Number;//播放了多长时间
		
		private var _playing:Boolean = false;
		
		private var _completeFunction:Function = null;//播放完毕的回调
		
		private var _currentKey:String;//当前播放的哪一个动画
		private var _moviesDictionary:Dictionary = new Dictionary();
		
		public function MutiStateMovieClip(textures:Vector.<Texture>,key:String,fps:Number=12)
		{
			super(textures[0]);
			
			_textures = textures;
			_currentKey = key;
			_moviesDictionary[key] = _textures;
			
			_fps = 1.0/fps;
			_numFrames = textures.length;
			_currentFrame = 0;
			_currentTime = 0;
			_totalTime = _fps * _numFrames;
			
			this.pivotX = pivotX;
			this.pivotY = pivotY;
		}
		
		public function advanceTime(passedTime:Number):void{
			var finalFrame:int = _numFrames - 1;
			var previousFrame:int = _currentFrame;
			
			if (!_playing || passedTime == 0.0 || _currentTime >= _totalTime) return;
			
			_currentTime += passedTime;
			_currentFrame = int(_currentTime/_fps);
			
			if(_currentFrame > finalFrame && _completeFunction != null){
				_completeFunction(this);
			}
			
			if (_loop && _currentTime >= _totalTime) {_currentTime = _currentFrame = 0; }
			
			if (_currentFrame != previousFrame)
				texture = _textures[_currentFrame];
		}
		
		/**
		 * 总共有多少帧
		 */		
		public function get numFrames():int{
			return _numFrames;
		}
		
		/**
		 * 设置/获取 当前帧
		 */		
		public function get currentFrame():int{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void{
			if(_currentFrame >= (_numFrames-1)){
				throw new Error("你妹，帧超出范围了");
			}
			_currentFrame = value;
			_currentTime = _currentFrame * _fps;
		}
		
		/**
		 * 设置/获取 帧频率
		 */
		public function get fps():Number{
			return 1.0/_fps;
		}
		public function set fps(value:Number):void{
			_fps = 1.0/value;
		}
		
		/**
		 * 设置/获取 是否循环
		 */		
		public function get loop():Boolean{
			return _loop;
		}
		public function set loop(value:Boolean):void{
			_loop = loop;
		}
		
		/**
		 * 设置播放完毕的回调
		 */		
		public function set completeFunction(value:Function):void{
			_completeFunction = value;
		}
		
		//当前播放的动画
		public function get currentKey():String{
			return _currentKey;
		}
		
		/**
		 * 播放
		 */		
		public function play():void{
			if(_playing){return;}
			_playing = true;
			Starling.juggler.add(this);
		}
		
		/**
		 * 停止
		 */
		public function stop():void{
			_playing = false;
			Starling.juggler.remove(this);
		}
		
		
		/**
		 * 添加一个动画
		 */
		public function addMovie(key:String,textures:Vector.<Texture>):void{
			_moviesDictionary[key] = textures;
		}
		
		/**
		 * 播放某个动画
		 */		
		public function goToMovie(key:String):void{
			if(_currentKey == key){return;}
			if(_moviesDictionary[key] == null){return;}
			
			_textures = _moviesDictionary[key];
			_currentKey = key;
			
			_numFrames = _textures.length;
			_currentFrame = 0;
			_currentTime = 0;
			_totalTime = _fps * _numFrames;
			
			texture = _textures[0];
			readjustSize();
		}
		
		/**
		 * 删除动画
		 */
		public function removeMovie(key:String):void{
			if(_currentKey == key){
				throw new Error("你妹，动画正在播放不能删除！！");
			}
			
			delete _moviesDictionary[key];
		}
		
		public override function dispose():void{
			super.dispose();
			Starling.juggler.remove(this);
		}
	}
}