package lzm.starling.gestures
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	/**
	 * 手势基类 
	 * @author lzm
	 * 
	 */	
	public class Gestures
	{
		protected var _target:DisplayObject;//目标
		protected var _callBack:Function;//回调
		
		public function Gestures(target:DisplayObject,callBack:Function=null){
			_target = target;
			_callBack = callBack;
			
			_target.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		public function set callBack(value:Function):void{
			_callBack = value;
		}
		
		public function get callBack():Function{
			return _callBack;
		}
		
		private function onTouch(e:TouchEvent):void{
			checkGestures(e.touches);
		}
		
		/**
		 * 检测手势
		 * */
		public function checkGestures(touches:Vector.<Touch>):void{
			
		}
		
		public function dispose():void{
			_target.removeEventListener(TouchEvent.TOUCH,onTouch);
			_target = null;
			_callBack = null;
		}
	}
}