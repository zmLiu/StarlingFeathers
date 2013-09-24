package lzm.starling.gestures
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 拖拽手势 
	 * @author lzm
	 * 
	 */	
	public class DragGestures extends Gestures
	{
		protected var _downPoint:Point = null;//点击在target的什么位置
		
		public function DragGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			var touch:Touch = touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				_downPoint = touch.getLocation(_target.stage);
			}else if(touch.phase == TouchPhase.MOVED){
				var movePoint:Point = touch.getLocation(_target.stage);
				_target.x += movePoint.x - _downPoint.x;
				_target.y += movePoint.y - _downPoint.y;
				_downPoint = movePoint;
			}else if(touch.phase == TouchPhase.ENDED){
				_downPoint = null;
			}
		}
	}
}