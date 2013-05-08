package lzm.starling.display.ainmation
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;

	public class GroupMovieClip extends Sprite implements IAnimatable
	{
		
		protected var _data:Object;
		protected var _images:Object;
		protected var _textureAtlas:TextureAtlas;
		
		protected var _currentLabel:String;
		protected var _currentFrame:int;//当前在第几帧
		protected var _currentData:Array;
		
		protected var _numFrames:int;//总共有多少帧
		protected var _fps:Number;//帧频
		protected var _loop:Boolean = true;//是否循环
		protected var _totalTime:Number;//总事件
		protected var _currentTime:Number;//播放了多长时间
		protected var _playing:Boolean = false;
		
		protected var _completeFunction:Function = null;//播放完毕的回调
		
		public function GroupMovieClip(data:Object,textureAtlas:TextureAtlas,fps:int = 12)
		{
			_data = data;
			_images = new Object();
			_textureAtlas = textureAtlas;
			
			_fps = 1.0/fps;
			
			init();
			
//			_id = mcids + "";
//			allMc[_id] = this;
//			mcids ++;
		}
		
		private function init():void{
			try
			{
				name = _data["name"];
				
				var pivot:Array;
				
				var combinantion:Object = _data["combinantion"];
				var k:String;
				var comData:Object;
				var image:Image;
				for(k in combinantion){
					comData = combinantion[k];
					pivot = comData["pivot"];
					
					image = new Image(_textureAtlas.getTexture(name+"_"+k));
					image.pivotX = pivot[0];
					image.pivotY = pivot[1];
					_images[k] = image;
				}
			} 
			catch(error:Error) 
			{
				trace(123123);
			}
			
		}
		
		public function advanceTime(passedTime:Number):void{
			var finalFrame:int = _numFrames - 1;
			var previousFrame:int = _currentFrame;
			
			if (!_playing || passedTime == 0.0 || _currentTime >= _totalTime) return;
			
			_currentTime += passedTime;
			_currentFrame = int(_currentTime/_fps);
			
//			if(_completeFunction != null){
//				trace(_currentFrame,finalFrame);
//			}
			
			if(_currentFrame > finalFrame && _completeFunction != null){
				_completeFunction(this);
			}
			
			if (_loop && _currentFrame > finalFrame) {_currentTime = _currentFrame = 0; }
			
			if (_currentFrame != previousFrame)
				currentFrame = _currentFrame;
		}
		
		/**
		 * 跳到某个动画 
		 * @param key	动画标签
		 */		
		public function goToMovie(key:String):void{
			if(_currentLabel == key) return;
			
			var tempData:Array = _data["framesInfo"][key];
			if(tempData == null) return;
			
			_currentData = tempData;
			_numFrames = _currentData.length;
			_currentFrame = -1;
			_currentTime = 0;
			_totalTime = _fps * _numFrames;
			
			currentFrame = 0;
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
		 * 设置播放完毕的回调
		 */		
		public function set completeFunction(value:Function):void{
			_completeFunction = value;
		}
		
		public function set currentFrame(value:int):void{
			_currentFrame = value;
			
			clearChild();
			
			var tempImage:Image;
			var tempData:Array = _currentData[_currentFrame];
			var tempLength:int = tempData.length;
			var k:String;
			var data:Array;
			
			for(var i:int=0;i<tempLength;i++){
				data = tempData[i];
				tempImage = _images[data[0]];
				tempImage.mX = data[1];
				tempImage.mY = data[2];
				tempImage.mRotation = deg2rad(data[3]);
				tempImage.mOrientationChanged = true;
				addQuiackChild(tempImage);
			}
		}
		
		public function get currentFrame():int{
			return _currentFrame;
		}
		
		public function get data():Object{
			return _data;
		}
		
		/**
		 * 获取总共有多少帧 
		 * @return 
		 * 
		 */		
		public function get numFrames():int{
			return _numFrames;
		}

		public override function dispose():void{
			stop();
			_data = null;
			
			var image:Image;
			var k:String;
			for(k in _images){
				image = _images[k];
				image.removeFromParent();
				image.dispose();
			}
			_images = null;
			
			_textureAtlas = null;
			_completeFunction = null;
			super.dispose();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}