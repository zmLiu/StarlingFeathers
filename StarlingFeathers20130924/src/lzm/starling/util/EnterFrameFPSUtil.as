package lzm.starling.util
{
	import starling.events.EnterFrameEvent;

	/**
	 * 当某个enterframe事件 需要用特定的帧率 而不是stage的帧率可以使用这个工具跳帧
	 * @author zmliu
	 * 
	 */	
	public class EnterFrameFPSUtil
	{
		
		private var fps:int;
		private var fpsTime:Number;
		private var currentTime:Number;
		
		public function EnterFrameFPSUtil(fps:int)
		{
			this.fps = fps;
			this.fpsTime = 1000 / this.fps * 0.001;
			this.currentTime = 0;
		}
		
		public function update(e:EnterFrameEvent):Boolean{
			this.currentTime += e.passedTime;
			if(this.currentTime >= this.fpsTime){
				this.currentTime -= this.fpsTime;
				if(this.currentTime > this.fpsTime){
					this.currentTime = 0;
				}
				return true;
			}
			return false;
		}
		
	}
}