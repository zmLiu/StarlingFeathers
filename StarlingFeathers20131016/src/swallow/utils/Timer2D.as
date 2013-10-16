package swallow.utils 
{
	import flash.utils.getTimer;
	import swallow.events.TimerEvent2D;
	/**
	 * 计时器对象
	 * @author TK
	 */
	public class Timer2D 
	{
		/**
		 * 延时
		 */
		public var delay:int
		
		/**
		 * 计时器运行次数
		 * @param	delay
		 */
		public var repeatCount:int=-1
		
		/**
		 * 内部计时变量
		 * @param	delay
		 */
		public var targetRepeatCount:int
		
		/**
		 * 内部计时变量
		 */
		private var _targetDelay:int
		
		/**
		 * 内部计时变量
		 */
		private var _currentDelay:int
		
		/**
		 * 计时器运行状态
		 */
		private var _start:Boolean;
		
		/**
		 * 线程函数
		 * @param	delay
		 */
		private var timerRunFunction:Function
		
		/**
		 * 计时器运行结束
		 * @param	delay
		 */
		private var timerEndFunction:Function
		
		/**
		 * 计时器被重置
		 * @param	delay
		 */
		private var timerResetFunction:Function
		
		/**
		 * 计时器重新开始
		 * @param	delay
		 */
		private var timerStartFunction:Function
		
		/**
		 * 计时器被停止
		 * @param	delay
		 */
		private var timerStopFunction:Function
		
		/**
		 * 计时器暂停时间
		 * @param	delay
		 */
		private var suspendValue:int
		
		/**
		 * 计时器暂停内部变量
		 * @param	delay
		 */
		private var _suspendValue:int
		
		/**
		 * 计时器暂停内部变量
		 * @param	delay
		 */
		private var _suspendValueEnd:int
		
		/**
		 * 计时器参数
		 * @param	delay
		 */
		private var timerEvent2D:TimerEvent2D
		/**
		 * 创建一个新的计时器
		 * @param	delay
		 */
		public function Timer2D(delay:int=10) 
		{
			TimerLists.target.addTimer(this);
			this.delay = delay;
			timerEvent2D = new TimerEvent2D();
			timerEvent2D.target = this;
		}
		
		/**
		 * 注册侦听器
		 * @param	event
		 * @param	fun
		 */
		public function addEventListener(event:String, fun:Function):void
		{
			switch(event)
			{
				case TimerEvent2D.TIMER:
					timerRunFunction = fun;
					break;
				case TimerEvent2D.TIMER_END:
					timerEndFunction = fun;
					break;
				case TimerEvent2D.TIMER_RESET:
					timerResetFunction = fun;
					break;
				case TimerEvent2D.TIMER_SRATR:
					timerStartFunction = fun;
					break;
				case TimerEvent2D.TIMER_STOP:
					timerStopFunction = fun;
					break;
			}
		}
		
		/**
		 * 删除侦听器
		 * @param	event
		 */
		public function removeEventListener(event:String):void
		{
			switch(event)
			{
				case TimerEvent2D.TIMER:
					timerRunFunction = null;
					break;
				case TimerEvent2D.TIMER_END:
					timerEndFunction = null;
					break;
				case TimerEvent2D.TIMER_RESET:
					timerResetFunction = null;
					break;
				case TimerEvent2D.TIMER_SRATR:
					timerStartFunction = null;
					break;
				case TimerEvent2D.TIMER_STOP:
					timerStopFunction = null;
					break;
			}
		}
		
		/**
		 * 开始计时器
		 */
		public function start():void
		{
			if (!_start)
			{
				_start = true;
				_targetDelay = getTimer();
				if (timerStartFunction != null)
				{
					timerStartFunction(timerEvent2D);
				}
			}
		}
		
		/**
		 * 停止计时器
		 */
		public function stop():void
		{
			_start = false;
			if (timerStopFunction != null)
			{
				timerStopFunction(timerEvent2D);
			}
		}
		/**
		 * 重置计时器
		 */
		public function reset():void
		{
			_targetDelay = getTimer();
			targetRepeatCount = 0;
			if (timerResetFunction != null)
			{
				timerResetFunction(timerEvent2D);
			}
		}
		
		/**
		 * 删除计时器
		 */
		public function dispose():void
		{
			TimerLists.target.removeTimer(this);
		}
		
		/**
		 * 暂停计时器
		 * @param	value
		 */
		public function suspend(value:int):void
		{
			if (_start)
			{
				suspendValue = value;
				_suspendValue = getTimer();
			}
		}
		
		/**
		 * 计时器
		 */
		public function run():void
		{
			if (suspendValue!=0)
			{
				_suspendValueEnd = getTimer();
				if (_suspendValueEnd-_suspendValue>=suspendValue)
				{
					suspendValue = 0;
				}else
				{
					return;
				}
			}
			if (_start)
			{
				_currentDelay = getTimer();
				if (_currentDelay - _targetDelay >= delay)
				{
					_targetDelay = getTimer();
					targetRepeatCount++;
					if (timerRunFunction != null)
					{
						timerEvent2D.targetRepeatCount = targetRepeatCount;
						timerEvent2D.repeatCount = repeatCount;
						timerRunFunction(timerEvent2D);
					}
					
					if (repeatCount!=-1&&targetRepeatCount >= repeatCount)
					{
						_start = false;
						if (timerEndFunction != null)
						{
							timerEndFunction(timerEvent2D);
						}
					}
				}
			}
		}
	}

}