package lzm.starling.gestures
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * @author 昀凡
	 */	
	public class SwipeGestures extends Gestures
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		private static const DISTIME:int = 300;
		private static const DIS:int = 50;
		private var _downPoint:Point;
		private var _downTime:int;
		public function SwipeGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				_downPoint = touch.getLocation(_target.stage);
				_downTime = getTimer();
			}else  if(touch.phase == TouchPhase.ENDED){
				var timeDis:int = getTimer() - _downTime;
				var releasePoint:Point = touch.getLocation(_target.stage);
				//trace("时间差：", timeDis);
				if(DISTIME <　timeDis)return;
				var xDis:int = releasePoint.x - _downPoint.x;
				var yDis:int = releasePoint.y - _downPoint.y;
				if(Math.abs(xDis) > Math.abs(yDis))
				{
					if(Math.abs(xDis)>DIS && _callBack != null)
						_callBack(xDis > 0 ? RIGHT : LEFT);
				}else
				{
					if(Math.abs(yDis)>DIS && _callBack != null)
						_callBack(yDis > 0 ? DOWN : UP);
				}
			}
		}
	}
}