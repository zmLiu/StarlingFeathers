package lzm.starling.display
{
	import flash.geom.Point;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 任意变形的控制器 
	 * @author lzm
	 * 
	 */	
	public class DistortImageContainer extends Sprite
	{
		
		/**
		 * 已经变形的数值
		 * */
		private var _distortPostions:Array;

		/**
		 * 需要变形的图片
		 * */
		private var _image:DistortImage;
		
		/**
		 * 拖动的图形
		 * */
		private var _quads:Vector.<Quad>;
		
		
		/**
		 * @param image	需要变形的图片
		 */		
		public function DistortImageContainer(image:DistortImage)
		{
			_image = image;
			addChild(_image);
			
			_distortPostions = [new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0)];
			
			init();
		}
		
		private function init():void{
			
			_quads = new Vector.<Quad>();
			var quad:Quad;
			for (var i:int = 0; i < 4; i++) 
			{
				quad = createQuad();
				quad.addEventListener(TouchEvent.TOUCH,distortFunction(i));
				addChild(quad);
				_quads.push(quad);
				switch(i){
					case 0:
						quad.x = -_image.pivotX;
						quad.y = -_image.pivotY;
						break;
					case 1:
						quad.x = _image.width - _image.pivotX;
						quad.y = -_image.pivotY;
						break;
					case 2:
						quad.x = -_image.pivotX;
						quad.y = _image.height - _image.pivotY;
						break;
					case 3:
						quad.x = _image.width - _image.pivotX;
						quad.y = _image.height - _image.pivotY;
						break;
				}
			}
		}
		
		private function distortFunction(vertexID:int):Function{
			var thisObject:DistortImageContainer = this;
			return function(e:TouchEvent):void{
				var touches:Vector.<Touch> = e.getTouches(thisObject, TouchPhase.MOVED);
				
				if (touches.length == 1)
				{
					var localPoint:Point = touches[0].getLocation(thisObject);
					var delta:Point = touches[0].getMovement(parent);
					var point:Point = _distortPostions[vertexID];
					point.x += delta.x;
					point.y += delta.y;
					(e.target as Quad).x = localPoint.x;
					(e.target as Quad).y = localPoint.y;
					_distortPostions[vertexID] = point;
					_image.setVertextDataPostion(vertexID,point.x,point.y);
				}  
			};
		}
		
		private function createQuad():Quad{
			var quad:Quad = new Quad(10,10,0x000000);
			quad.pivotX = quad.pivotY = 5;
			return quad;
		}
		
		/**
		 * 获取任意变形的值
		 * */
		public function get distortValues():Array{
			return _distortPostions;
		}
		
	}
}