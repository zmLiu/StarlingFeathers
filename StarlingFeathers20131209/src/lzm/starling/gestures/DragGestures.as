package lzm.starling.gestures
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		
		protected var _targetWidth:Number = NaN;
		protected var _targetHeight:Number = NaN;
		
		public var cacheTargetSize:Boolean = true;//是否缓存目标大小
		public var dragRect:Rectangle;//拖动范围
		
		public function DragGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				_downPoint = touch.getLocation(_target.stage);
			}else if(touch.phase == TouchPhase.MOVED){
				var movePoint:Point = touch.getLocation(_target.stage);
				_target.x += movePoint.x - _downPoint.x;
				_target.y += movePoint.y - _downPoint.y;
				_downPoint = movePoint;
				
				if(dragRect) checkTargetPosition();
				
				if(_callBack) _callBack();
			}else if(touch.phase == TouchPhase.ENDED){
				_downPoint = null;
			}
		}
		
		protected function checkTargetPosition():void{
			if(isNaN(_targetWidth) || isNaN(_targetHeight) || !cacheTargetSize){
				_targetWidth = _target.width;
				_targetHeight = _target.height;
			}
			
			if((_target.x - _target.pivotX*_target.scaleX) > dragRect.x) 
				_target.x = _target.pivotX*_target.scaleX + dragRect.x;
			
			if((_target.y - _target.pivotY*_target.scaleY) > dragRect.y) 
				_target.y = _target.pivotY*_target.scaleY + dragRect.y;
			
			if((_target.x - _target.pivotX*_target.scaleX) < (dragRect.width - _targetWidth*_target.scaleX - dragRect.x)) 
				_target.x = (dragRect.width - _targetWidth*_target.scaleX  - dragRect.x) + (_target.pivotX*_target.scaleX);
			
			if((_target.y - _target.pivotY*_target.scaleY) < (dragRect.height - _targetHeight*_target.scaleY - dragRect.y)) 
				_target.y = (dragRect.height - _targetHeight*_target.scaleY - dragRect.y) + (_target.pivotY*_target.scaleY);
			
		}
	}
}