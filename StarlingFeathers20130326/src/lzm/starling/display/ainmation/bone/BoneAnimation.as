package lzm.starling.display.ainmation.bone
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * 简易骨骼动画 
	 * @author lzm
	 */	
	public class BoneAnimation extends Sprite implements IAnimatable
	{
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		private var _images:Object;
		private var _frameInfos:Object;
		
		protected var _labels:Array;//所有的标签
		protected var _currentLabel:String;//当前标签
		protected var _currentFrame:int;//当前在第几帧
		protected var _currentData:Array;
		
		protected var _numFrames:int;//总共有多少帧
		protected var _fps:Number;//帧频
		protected var _loop:Boolean = true;//是否循环
		protected var _totalTime:Number;//总时间
		protected var _currentTime:Number;//播放了多长时间
		protected var _playing:Boolean = false;
		
		protected var _completeFunction:Function = null;//播放完毕的回调
		
		public function BoneAnimation(movieData:Object,images:Object,fps:int = 12){
			_images = images;
			
			_labels = [];
			_frameInfos = movieData["frameInfos"]
			for(var k:String in _frameInfos){
				_labels.push(k);
			}
			
			_fps = 1.0/fps;
		}
		
		
		public function advanceTime(passedTime:Number):void{
			var finalFrame:int = _numFrames - 1;
			var previousFrame:int = _currentFrame;
			
			if (!_playing || passedTime == 0.0 || _currentTime >= _totalTime) return;
			
			_currentTime += passedTime;
			_currentFrame = int(_currentTime/_fps);
			
			if(_currentFrame > finalFrame){
				if(!_loop) stop();
				if(_completeFunction) _completeFunction(this);
				_currentTime = _currentFrame = 0;
			}
			
			if (_currentFrame != previousFrame)
				currentFrame = _currentFrame;
		}
		
		/**
		 * 跳到某个动画 
		 * @param key	动画标签
		 */
		public function goToMovie(key:String):void{
			if(_currentLabel == key) return;
			
			_currentData =  _frameInfos[key];
			_numFrames = _currentData.length;
			_currentFrame = -1;
			_currentTime = 0;
			_totalTime = _fps * _numFrames;
			
			currentFrame = 0;
		}
		
		/**
		 * 播放
		 */		
		public function play(loop:Boolean = true):void{
			if(_playing){return;}
			_playing = true;
			_loop = loop;
			
			if(_currentLabel == null){
				goToMovie(_labels[0]);
			}
			
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
		 * 设置播放完毕的回调
		 */		
		public function set completeFunction(value:Function):void{
			_completeFunction = value;
		}
		
		/**
		 * 设置/获取当前帧 
		 */		
		public function get currentFrame():int{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void{
			_currentFrame = value;
			clearChild();
			
			var frameData:Array = _currentData[_currentFrame];
			var length:int = frameData.length;
			var imageData:Array;
			var image:Image;
			for (var i:int = 0; i < length; i++) {
				imageData = frameData[i];
				image = _images[imageData[0]];
				image.x = imageData[1];
				image.y = imageData[2];
				image.scaleX = imageData[3];
				image.scaleY = imageData[4];
				image.skewX = imageData[5] * ANGLE_TO_RADIAN;
				image.skewY = imageData[6] * ANGLE_TO_RADIAN;
				addQuiackChild(image);
			}
		}
		
		/**
		 * 获取动画lables 
		 * @return 
		 * 
		 */		
		public function get labels():Array{
			return _labels;
		}
		
		
		
	}
}