package lzm.starling.display
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ScrollContainerItem extends Sprite
	{
		internal var _viewPort:Rectangle;
		internal var _isInView:Boolean = false;//是否在显示范围内部
		internal var _scrollContainer:ScrollContainer;//容器
		
		public function ScrollContainerItem()
		{
			super();
			_viewPort = new Rectangle();
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		protected function addToStage(e:Event):void{
			var temp:Rectangle = getBounds(parent);
			_viewPort.width = temp.width;
			_viewPort.height = temp.height;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject{
			super.addChildAt(child,index);
			if(parent) addToStage(null);
			return child;
		}
		
		public override function removeChildAt(index:int, dispose:Boolean=false):DisplayObject{
			var child:DisplayObject = super.removeChildAt(index,dispose);
			if(parent) addToStage(null);
			return child;
		}
		
		public override function set x(value:Number):void{
			super.x = value;
			_viewPort.x = value;
		}
		
		public override function set y(value:Number):void{
			super.y = value;
			_viewPort.y = value;
		}
		
		/**
		 * 进入显示区域
		 * */
		public function inView():void{
			
		}
		
		/**
		 * 离开显示区域
		 * */
		public function outView():void{
			
		}
		
		public function get isInView():Boolean{
			return _isInView;
		}
		
		public function get scrollContainer():ScrollContainer{
			return _scrollContainer;
		}
		
		public override function dispose():void{
			_scrollContainer = null;
			super.dispose();
		}
	}
}