package lzm.starling.gestures
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class MoveOverGestures extends Gestures
	{
		private var _isMove:Boolean = false;
		
		public function MoveOverGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			var touch:Touch = touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				_isMove = false;
			}else if(touch.phase == TouchPhase.MOVED){
				_isMove = true;
			}else if(touch.phase == TouchPhase.ENDED){
				_isMove = false;
				if(_callBack){
					if(_callBack.length == 0){
						_callBack();
					}else{
						_callBack(touch);
					}
				}
			}
		}
	}
}