package lzm.starling.gestures
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 长按收拾 
	 * @author zmliu
	 */	
	public class HoldGestures extends Gestures
	{
		private var _timer:Timer;
		private var _holdTime:int = 500;
		private var _callBackTime:int = 100;
		
		private var _holdEndCallBack:Function;
		
		public function HoldGestures(target:DisplayObject, callBack:Function=null,holdEndCallBack:Function=null)
		{
			super(target, callBack);
			_holdEndCallBack = holdEndCallBack;
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				if(_timer == null){
					_timer = new Timer(_holdTime);
					_timer.addEventListener(TimerEvent.TIMER,onTimer);
				}
				_timer.start();
			}else if(touch.phase == TouchPhase.MOVED){
				
			}else if(touch.phase == TouchPhase.ENDED){
				if(_holdEndCallBack && _timer.delay == _callBackTime) _holdEndCallBack();
				
				_timer.stop();
				_timer.reset();
				_timer.delay = _holdTime;
			}
		}
		
		private function onTimer(e:TimerEvent):void{
			if(_timer.delay == _holdTime) _timer.delay = _callBackTime;
			if(_callBack) _callBack();
		}
		
		public override function dispose():void{
			super.dispose();
			if(_timer){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer = null;
			}
			_holdEndCallBack = null;
		}
		
		
		
	}
}