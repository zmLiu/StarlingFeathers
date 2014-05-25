package swallow.events 
{
	import swallow.utils.Timer2D;
	/**
	 * 计时器对象
	 * @author 
	 */
	public class TimerEvent2D 
	{
		
		/**
		 * 计时器
		 */
		public static var TIMER:String = "EVENT2D_TIMER";
		
		/**
		 * 计时器执行结束
		 */
		public static var TIMER_END:String = "EVENT2D_END";
		
		/**
		 * 计时器重置
		 */
		public static var TIMER_RESET:String = "EVENT2D_TIMER_RESET";
		
		/**
		 * 计时器被启动
		 */
		public static var TIMER_SRATR:String = "EVENT2D_TIMER_SRATR";
		
		/**
		 * 计时器被停止
		 */
		public static var TIMER_STOP:String = "EVENT2D_TIMER_STOP";
		
		/**
		 * 当前执行次数
		 */
		public var targetRepeatCount:int
		
		/**
		 * 总运行次数
		 */
		public var repeatCount:int
		public var target:Timer2D
		public function TimerEvent2D() 
		{
			
		}
		
	}

}