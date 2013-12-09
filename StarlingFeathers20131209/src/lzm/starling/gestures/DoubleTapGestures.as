package lzm.starling.gestures
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 双击收拾 
	 * @author lzm
	 * 
	 */	
	public class DoubleTapGestures extends Gestures
	{
		public function DoubleTapGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			for each(var touch:Touch in touches){
				if(touch.phase == TouchPhase.ENDED && touch.tapCount == 2){
					
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