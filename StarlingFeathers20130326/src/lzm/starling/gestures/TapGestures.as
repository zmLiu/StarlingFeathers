package lzm.starling.gestures
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;

	/**
	 * 单机手势 
	 * @author lzm
	 * 
	 */	
	public class TapGestures extends Gestures
	{
		private var isMoved:Boolean = false;
		
		public function TapGestures(target:DisplayObject,callBack:Function=null)
		{
			super(target,callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			for each(var touch:Touch in touches){
				if(touch.phase == TouchPhase.MOVED){
					isMoved = true;
				}else if(touch.phase == TouchPhase.ENDED){
					if(isMoved){
						isMoved = false;
						return;
					}
					var buttonRect:Rectangle = _target.getBounds(_target.stage);
					if (touch.globalX < buttonRect.x ||
						touch.globalY < buttonRect.y ||
						touch.globalX > buttonRect.x + buttonRect.width ||
						touch.globalY > buttonRect.y+ buttonRect.height ){
						return;
					}
					
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
}