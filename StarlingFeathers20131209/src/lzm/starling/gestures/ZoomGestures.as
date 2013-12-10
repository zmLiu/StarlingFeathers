package lzm.starling.gestures
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 缩放手势 
	 * @author lzm
	 * 
	 */	
	public class ZoomGestures extends Gestures
	{
		public var minScale:Number = NaN;//可以缩放的最小值
		public var maxScale:Number = NaN;//可以缩放的最大值
		
		public function ZoomGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGesturesByTouches(touches:Vector.<Touch>):void{
			if(touches.length != 2) return;
			
			var touchA:Touch = touches[0];
			var touchB:Touch = touches[1];
			
			if(touchA.phase != TouchPhase.MOVED || touchB.phase != TouchPhase.MOVED) return;
			
			var currentPosA:Point  = touchA.getLocation(_target.parent);
			var previousPosA:Point = touchA.getPreviousLocation(_target.parent);
			var currentPosB:Point  = touchB.getLocation(_target.parent);
			var previousPosB:Point = touchB.getPreviousLocation(_target.parent);
			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number = currentAngle - previousAngle;
			
			var previousLocalA:Point  = touchA.getPreviousLocation(_target);
			var previousLocalB:Point  = touchB.getPreviousLocation(_target);
			_target.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
			_target.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
			_target.x = (currentPosA.x + currentPosB.x) * 0.5;
			_target.y = (currentPosA.y + currentPosB.y) * 0.5;
			
			var sizeDiff:Number = currentVector.length / previousVector.length;
			_target.scaleX *= sizeDiff;
			_target.scaleY *= sizeDiff;
			
			if(!isNaN(minScale)){
				if(_target.scaleX < minScale) _target.scaleX = minScale;
				if(_target.scaleY < minScale) _target.scaleY = minScale;
			}
			
			if(!isNaN(maxScale)){
				if(_target.scaleX > maxScale) _target.scaleX = maxScale;
				if(_target.scaleY > maxScale) _target.scaleY = maxScale;
			}
			
		}
		
	}
}