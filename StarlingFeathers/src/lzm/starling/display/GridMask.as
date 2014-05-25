package lzm.starling.display
{
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	
	/**
	 * 某个位置一个镂空矩形的遮罩层 
	 * @author lzm
	 * 
	 */	
	public class GridMask extends Sprite
	{
		
		private var _quads:Vector.<Quad>;
		private var _borderShape:Shape;
		
		private var _color:uint;//遮罩颜色
		private var _alpha:Number;
		private var _border:Boolean;//遮罩中间镂空的矩形是否需要边框
		private var _borderColor:uint;//边框颜色
		
		/**
		 *  
		 * @param color			遮罩颜色
		 * @param alpha			透明度
		 * @param border		遮罩中间镂空的矩形是否需要边框	
		 * @param borderColor	边框颜色
		 * 
		 */		
		public function GridMask(color:uint,alpha:Number,border:Boolean,borderColor:uint)
		{
			super();
			_color = color;
			_alpha = alpha;
			_border = border;
			_borderColor = borderColor;
		}
		
		private function createQuads():void{
			_quads = new Vector.<Quad>();
			
			var quad:Quad;
			for (var i:int = 0; i < 4; i++) {
				quad = new Quad(10,10,_color);
				quad.alpha = _alpha;
				
				addChild(quad);
				
				_quads.push(quad);
			}
			
			_borderShape = new Shape();
			_borderShape.touchable = false;
			addChild(_borderShape);
		}
		
		private function drawGridRect(gridRect:Rectangle):void{
			_borderShape.graphics.clear();
			if(_border){
				_borderShape.graphics.lineStyle(1,_borderColor);
				_borderShape.graphics.moveTo(gridRect.x,gridRect.y);
				_borderShape.graphics.lineTo(gridRect.x + gridRect.width,gridRect.y);
				_borderShape.graphics.lineTo(gridRect.x + gridRect.width,gridRect.y + gridRect.height);
				_borderShape.graphics.lineTo(gridRect.x,gridRect.y + gridRect.height);
				_borderShape.graphics.lineTo(gridRect.x,gridRect.y);
				_borderShape.graphics.endFill();
			}
		}
		
		private function tweenQuads(gridRect:Rectangle):void{
			var tmpX:Number = _quads[0].x;
			var tmpY:Number = _quads[0].y;
			_quads[0].y = - _quads[0].height;
			Starling.current.juggler.tween(_quads[0],0.3,{x:tmpX,y:tmpY,transition:Transitions.EASE_IN_OUT});
			
			tmpX = _quads[1].x;
			tmpY = _quads[1].y;
			_quads[1].x = - _quads[1].width;
			Starling.current.juggler.tween(_quads[1],0.3,{x:tmpX,y:tmpY,transition:Transitions.EASE_IN_OUT});
			
			tmpX = _quads[2].x;
			tmpY = _quads[2].y;
			_quads[2].x = _quads[2].x + _quads[2].width;
			Starling.current.juggler.tween(_quads[2],0.3,{x:tmpX,y:tmpY,transition:Transitions.EASE_IN_OUT});
			
			tmpX = _quads[3].x;
			tmpY = _quads[3].y;
			_quads[3].y = _quads[3].y + _quads[3].height;
			Starling.current.juggler.tween(_quads[3],0.3,{x:tmpX,y:tmpY,transition:Transitions.EASE_IN_OUT,onComplete:function():void{
				drawGridRect(gridRect);
			}});
			
		}
		
		public function show(parent:DisplayObjectContainer,parentRect:Rectangle,gridRect:Rectangle,tween:Boolean):void{
			if(_quads == null) createQuads();
			
			_borderShape.graphics.clear();
			
			_quads[0].x = 0;
			_quads[0].y = 0;
			_quads[0].width = parentRect.width;
			_quads[0].height = gridRect.y;
			
			_quads[1].x = 0;
			_quads[1].y = gridRect.y;
			_quads[1].width = gridRect.x;
			_quads[1].height = parentRect.height - gridRect.y;
			
			_quads[2].x = gridRect.x;
			_quads[2].y = gridRect.y + gridRect.height;
			_quads[2].width = parentRect.width - gridRect.x;
			_quads[2].height = parentRect.height - (gridRect.y + gridRect.height);
			
			_quads[3].x = gridRect.x + gridRect.width;
			_quads[3].y = gridRect.y;
			_quads[3].width = parentRect.width - (gridRect.x + gridRect.width);
			_quads[3].height = gridRect.height;
			
			if(tween){
				tweenQuads(gridRect);
			}else{
				drawGridRect(gridRect);
			}
			
			parent.addChild(this);
		}
		
		
		
		
		
	}
}