package lzm.starling.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import lzm.util.CollisionUtils;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ScrollContainer extends feathers.controls.ScrollContainer
	{
		protected var _scrolling:Boolean = false;//是否在滑动中
		protected var _scrolled:Boolean = false;//是否滚动过
		
		protected var _viewPort2:Rectangle;
		protected var _itemList:Vector.<ScrollContainerItem>;
		protected var _itemCount:int = 0;
		
		public function ScrollContainer()
		{
			super();
			_viewPort2 = new Rectangle();
			_itemList = new Vector.<ScrollContainerItem>();
			addEventListener(Event.SCROLL,onScroll);
			addEventListener(FeathersEventType.SCROLL_COMPLETE,onScrollComplete);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void{
			var touches:Vector.<Touch> = e.touches;
			var localPoint:Point;
			for each (var touch:Touch in touches) {
				localPoint = touch.getLocation(this);
				if(touch.phase == TouchPhase.BEGAN){
					_scrolled = false;
				}else if(touch.phase == TouchPhase.MOVED){
					if(_scrolled){
						_scrolling = true;
					}
				}else if(touch.phase == TouchPhase.ENDED){
				}
			}
		}
		
		private function onScroll(e:Event):void{
			_scrolled = true;
			updateShowItems();
		}
		
		private function onScrollComplete(e:Event):void{
			_scrolling = false;
		}
		
		/**
		 * 更新显示的对象
		 * */
		public function updateShowItems():void{
			_viewPort2.x = _horizontalScrollPosition;
			_viewPort2.y = _verticalScrollPosition;
			_viewPort2.width = width;
			_viewPort2.height = height;
			
			var itemViewPort:Rectangle;
			var item:ScrollContainerItem;
			for (var i:int = 0; i < _itemCount; i++) {
				item = _itemList[i];
				itemViewPort = item._viewPort;
				if(CollisionUtils.isIntersectingRect(_viewPort2,itemViewPort)){
					if(!item._isInView){
						item.inView();
					}
					item.visible = item._isInView = true;
				}else{
					if(item._isInView){
						item.outView();
					}
					item.visible = item._isInView = false;
				}
			}
			
//			var count:int = 0;
//			for (var i:int = 0; i < _itemCount; i++) {
//				if(_itemList[i]._isInView){
//					count ++;
//				}
//			}
//			trace("in:"+count);
		}
		
		public function addScrollContainerItem(item:ScrollContainerItem):void{
			addChild(item);
			_itemList.push(item);
			_itemCount ++;
			
			item._scrollContainer = this;
		}
		
		public function removeScrollContainerItem(item:ScrollContainerItem,dispose:Boolean = false):void{
			var index:int = _itemList.indexOf(item);
			if(index != -1){
				_itemList.splice(index,1);
				_itemCount --;
				
				item.removeFromParent(dispose);
				item._scrollContainer = null;
			}
		}
		
		public function reset(dispose:Boolean = false):void{
			while(_itemList.length != 0){
				removeScrollContainerItem(_itemList[0],dispose);
			}
		}
		
		/**
		 * 是否在滚动中
		 * */
		public function get scrolling():Boolean{
			return _scrolling;
		}
		
		/**
		 * 获取在显示的对象 
		 * @return 
		 * 
		 */		
		public function get inViewItem():Vector.<ScrollContainerItem>{
			var items:Vector.<ScrollContainerItem> = new Vector.<ScrollContainerItem>();
			for each (var item:ScrollContainerItem in _itemList) {
				if(item.visible){
					items.push(item);
				}
			}
			return items;
		}
		
		public function get items():Vector.<DisplayObject>{
			var list:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for (var i:int = 0; i < _itemCount; i++) {
				list.push(_itemList[i]);
			}
			
			return list;
		}
		
	}
}