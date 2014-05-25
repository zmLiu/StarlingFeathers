package lzm.starling.gestures
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 旋转收拾
	 * @author lzm
	 * 
	 */	
	public class RotationGestures extends Gestures
	{
		public function RotationGestures(target:DisplayObject, callBack:Function=null)
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
			
			_target.rotation += deltaAngle;
		}
		
	}
}