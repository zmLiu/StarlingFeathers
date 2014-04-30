package lzm.starling.gestures
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 移动手势 
	 * @author lzm
	 * 
	 */	
	public class MovedGestures extends Gestures
	{
		public function MovedGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
			}else if(touch.phase == TouchPhase.MOVED){
				if(_callBack){
					if(_callBack.length == 0){
						_callBack();
					}else{
						_callBack(touch);
					}
				}
			}else if(touch.phase == TouchPhase.ENDED){
			}
		}
	}
}