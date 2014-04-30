package lzm.util
{
	import flash.display.Stage;
	import flash.utils.getTimer;

	public class AutoSkip
	{
		private var lastTimer:int;
		private var deadLine:int;
		private var minContiguousFrames:int;
		private var maxContiguousSkips:int;
		private var framesRendered:int;
		private var framesSkipped:int;
		/**
		 *一种模仿PCSX2的跳帧策略
		 * @param deadLineRate 当两次调用之间时差高于标准值多少开始跳帧，推荐1.2以上
		 * @param minContiguousFrames  进行跳帧前最少连续渲染了多少帧，推荐1以上
		 * @param maxContiguousSkips  最多可以连续跳过的帧数，推荐1
		 * 
		 */
		public function AutoSkip(stage:Stage,deadLineRate:Number=1.20,minContiguousFrames:int=1,maxContiguousSkips:int=1){
			super();
			this.lastTimer=0;
			this.deadLine=Math.ceil((1000/stage.frameRate)*deadLineRate);
			this.minContiguousFrames=minContiguousFrames;
			this.maxContiguousSkips=maxContiguousSkips;
			framesRendered=0;
			framesSkipped=0;
		}//end of Function
		public function requestFrameSkip():Boolean{
			var rt:Boolean = false;
			var timer:int = getTimer();
			var dtTimer:int = timer-lastTimer;
			if(dtTimer>deadLine&&framesRendered>=minContiguousFrames&&framesSkipped<maxContiguousSkips){
				//如果满足一系列条件才能批准跳帧
				rt=true;
				framesRendered=0;
				framesSkipped+=1;
			}else {
				framesSkipped=0;
				framesRendered+=1;
			}//end if
			lastTimer=timer;
			return rt;
		}
	}
}