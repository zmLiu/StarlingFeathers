package lzm.starling.display.ainmation.bone
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * 简易骨骼动画 
	 * @author lzm
	 */	
	public class BoneAnimation extends Sprite
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
		protected var _playing:Boolean = false;
		
		protected var _completeFunction:Function = null;//播放完毕的回调
		
		public function BoneAnimation(movieData:Object,images:Object,fps:int = 12){
			_images = images;
			
			_labels = [];
			_frameInfos = movieData["frameInfos"];
			for(var k:String in _frameInfos){
				_labels.push(k);
			}
			
			_fps = 1.0/fps;
		}
		
		public function update():void{
			var finalFrame:int = _numFrames - 1;
			
			if (!_playing) return;
			
			var previousFrame:int = _currentFrame;
			
			_currentFrame += 1;
			
			if(_currentFrame > finalFrame){
				if(!_loop) stop();
				if(_completeFunction) _completeFunction(this);
				_currentFrame = 0;
			}
			
			if(_currentFrame != previousFrame)
				currentFrame = _currentFrame;
		}
		
		/**
		 * 是否包含某个标签 
		 * @param key
		 * @return 
		 * 
		 */		
		public function hasLabel(key:String):Boolean{
			return !(_frameInfos[key] == null);
		}
		
		/**
		 * 跳到某个动画 
		 * @param key	动画标签
		 */
		public function goToMovie(key:String):void{
			if(_currentLabel == key) return;
			
			_currentLabel = key;
			_currentData =  _frameInfos[key];
			_numFrames = _currentData.length;
			_currentFrame = -1;
			
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
		}
		
		/**
		 * 停止
		 */
		public function stop():void{
			_playing = false;
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
		
		/**
		 * 返回当前状态
		 */		
		public function get currentLabel():String{
			return _currentLabel;
		}
		
		/**
		 *  
		 * @return 是否在播放 
		 * 
		 */		
		public function get playing():Boolean{
			return _playing;
		}
		
		public override function dispose():void{
			stop();
			removeFromParent();
			
			for each (var image:Image in _images) {
				image.removeFromParent();
				image.dispose();
			}
			
			_images = null;
			_frameInfos = null;
			
			super.dispose();
		}
		
		
	}
}