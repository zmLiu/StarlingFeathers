package lzm.starling.swf
{
	import flash.utils.getTimer;

	/**
	 * 当某个enterframe事件 需要用特定的帧率 而不是stage的帧率可以使用这个工具跳帧
	 * @author zmliu
	 * 
	 */	
	public class FPSUtil
	{
		
		private var _fps:int;
		private var _fpsTime:Number;
		private var _currentTime:Number;
		private var _lastFrameTimestamp:Number;
		
		public function FPSUtil(fps:int)
		{
			this.fps = fps;
		}
		
		public function get fps():int{
			return _fps;
		}
		
		public function set fps(value:int):void{
			_fps = value;
			_fpsTime = 1000 / _fps * 0.001;
			_currentTime = 0;
			_lastFrameTimestamp = getTimer() / 1000;
		}
		
		public function update():Boolean{
			var now:Number = getTimer() / 1000.0;
			var passedTime:Number = now - _lastFrameTimestamp;
			_lastFrameTimestamp = now;
			
			_currentTime += passedTime;
			if(_currentTime >= _fpsTime){
				_currentTime -= _fpsTime;
				if(_currentTime > _fpsTime){
					_currentTime = 0;
				}
				return true;
			}
			return false;
		}
		
	}
}