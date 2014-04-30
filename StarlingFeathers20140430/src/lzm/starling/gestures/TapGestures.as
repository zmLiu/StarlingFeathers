package lzm.starling.gestures
{
	import flash.geom.Point;
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
		private var startPoint:Point;
		
		private var _tempX:Number;
		private var _tempY:Number;
		private var _tempScaleX:Number;
		private var _tempScaleY:Number;
		private var _needEffect:Boolean = false;//点击的时候时候需要一个效果
		private var _maxDragDist:int = 24;//允许滑动的弹性范围
		
		public function TapGestures(target:DisplayObject,callBack:Function=null,needTapEffect:Boolean=false)
		{
			super(target,callBack);
			_needEffect = needTapEffect;
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				startPoint = new Point(touch.globalX,touch.globalY);
				if(_needEffect){
					_tempX = _target.x;
					_tempY = _target.y;
					_tempScaleX = _target.scaleX;
					_tempScaleY = _target.scaleY;
					
					_target.scaleX = _tempScaleX*0.9;
					_target.scaleY = _tempScaleY*0.9;
					
					_target.x += (1.0 - _tempScaleX*0.9) / 2.0 * _target.width;
					_target.y += (1.0 - _tempScaleY*0.9) / 2.0 * _target.width;
				}
			}else if(touch.phase == TouchPhase.MOVED){
				
			}else if(touch.phase == TouchPhase.ENDED){
				if(startPoint == null){
					return;
				}
				if(_needEffect){
					resetTarget();
				}
				var endPoint:Point = new Point(touch.globalX,touch.globalY);
				if(Point.distance(startPoint,endPoint) >= _maxDragDist){
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
		
		protected function resetTarget():void{
			_target.x = _tempX;
			_target.y = _tempY;
			_target.scaleX = _tempScaleX;
			_target.scaleY = _tempScaleY;
		}
		
		public function get maxDragDist():int{
			return _maxDragDist;
		}
		
		public function set maxDragDist(value:int):void{
			value = _maxDragDist;
		}
		
	}
}