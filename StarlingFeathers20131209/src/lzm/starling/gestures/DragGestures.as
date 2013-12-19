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
		
		protected var _dragRect:Rectangle;//拖动范围
		
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
				
				if(_dragRect) checkTargetPosition();
				
				if(_callBack) _callBack();
			}else if(touch.phase == TouchPhase.ENDED){
				_downPoint = null;
			}
		}
		
		protected function checkTargetPosition():void{
			if(_targetWidth * _target.scaleX > _dragRect.width){
				if((_target.x - _target.pivotX*_target.scaleX) > _dragRect.x) 
					_target.x = _target.pivotX*_target.scaleX + _dragRect.x;
				
				if((_target.x - _target.pivotX*_target.scaleX) < (_dragRect.width - _targetWidth*_target.scaleX - _dragRect.x)) 
					_target.x = (_dragRect.width - _targetWidth*_target.scaleX  - _dragRect.x) + (_target.pivotX*_target.scaleX);
			}else{
				if((_target.x - _target.pivotX*_target.scaleX) < _dragRect.x) 
					_target.x = _target.pivotX*_target.scaleX + _dragRect.x;
				
				if((_target.x - _target.pivotX*_target.scaleX) > (_dragRect.width - _targetWidth*_target.scaleX - _dragRect.x)) 
					_target.x = (_dragRect.width - _targetWidth*_target.scaleX  - _dragRect.x) + (_target.pivotX*_target.scaleX);
			}
			
			if(_targetHeight * _target.scaleY > _dragRect.height){
				if((_target.y - _target.pivotY*_target.scaleY) > _dragRect.y) 
					_target.y = _target.pivotY*_target.scaleY + _dragRect.y;
				
				if((_target.y - _target.pivotY*_target.scaleY) < (_dragRect.height - _targetHeight*_target.scaleY - _dragRect.y)) 
					_target.y = (_dragRect.height - _targetHeight*_target.scaleY - _dragRect.y) + (_target.pivotY*_target.scaleY);
			}else{
				if((_target.y - _target.pivotY*_target.scaleY) < _dragRect.y) 
					_target.y = _target.pivotY*_target.scaleY + _dragRect.y;
				
				if((_target.y - _target.pivotY*_target.scaleY) > (_dragRect.height - _targetHeight*_target.scaleY - _dragRect.y)) 
					_target.y = (_dragRect.height - _targetHeight*_target.scaleY - _dragRect.y) + (_target.pivotY*_target.scaleY);
			}
		}
		
		/**
		 * 设置拖动范围 
		 * @param dragRect		拖动范围
		 * @param targetWidth	拖动对象的宽
		 * @param targetHeight	拖动对象的高
		 */		
		public function setDragRectangle(dragRect:Rectangle,targetWidth:Number,targetHeight:Number):void{
			_dragRect = dragRect;
			_targetWidth = targetWidth;
			_targetHeight = targetHeight;
		}
	}
}