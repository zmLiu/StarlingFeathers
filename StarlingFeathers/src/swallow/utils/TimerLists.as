package swallow.utils 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.core.Starling;
	/**
	 * 计时器容器数组
	 * @author TK
	 */
	public class TimerLists 
	{
		/**
		 * 单例对象
		 */
		private static var _target:TimerLists
		
		private static var timerLists:Vector.<Timer2D>;
		
		private var tiemr:Timer
		private var index:int
		/**
		 * 创建一个计时器容器池
		 */
		public function TimerLists() 
		{
			timerLists = new Vector.<Timer2D>();
			
			Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME,run)
		}
		
		private function run(e:Event):void
		{
			index++
			if (index > 100000)
			{
				tiemr.reset();
				tiemr.start();
			}
			TimerLists.run()
		}
		
		/**
		 * 返回容器对象
		 */
		public static function get target():TimerLists
		{
			if (_target == null)
			{
				_target = new TimerLists();
			}
			return _target;
		}
		
		/**
		 * 暂停
		 * @param	value
		 */
		public function suspend(value:int):void
		{
			for (var i:int = 0; i < timerLists.length; i++)
			{
				timerLists[i].suspend(value);
			}
		}
		
		/**
		 * 添加计时器
		 * @param	timer
		 */
		public function addTimer(timer:Timer2D):void
		{
			timerLists.push(timer);
		}
		
		/**
		 * 删除计时器
		 * @param	timer
		 */
		public function removeTimer(timer:Timer2D):void
		{
			timerLists.splice(timerLists.indexOf(timer), 1);
		}
		
		/**
		 * 线程
		 */
		public static function run():void
		{
			var len:int = timerLists.length;
			for (var i:int = 0; i <len;i++)
			{
				timerLists[i].run();
			}
		}
		
	}

}