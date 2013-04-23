package lzm.starling.gestures
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 悬停手势 
	 * @author lzm
	 * 
	 */	
	public class HoverGestures extends Gestures
	{
		public function HoverGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			var touch:Touch = touches[0];
			if(touch.phase == TouchPhase.HOVER){
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