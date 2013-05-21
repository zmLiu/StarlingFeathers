package lzm.starling.display
{
	import lzm.starling.gestures.TapGestures;
	
	/**
	 * 可在listitem下面显示一个内容区域的list组建 
	 * @author lzm
	 * 
	 */	
	public class ContentList extends ScrollContainer
	{
		
		private var _items:Vector.<ContentListItem>;
		private var __itemCount:int = 0;
		
		private var _contentTitleHeight:int;//每个标题的高度
		private var _contentHeight:int;//每个标题内容的高度
		
		private var _currentIndex:int = -1;//当前显示的容器
		
		/**
		 * @param width					容器宽度
		 * @param height				容器高度
		 * @param contentTitleHeight	每个标题的高度
		 * @param contentHeight			每个标题内容的高度
		 */		
		public function ContentList(width:int,height:int,contentTitleHeight:int,contentHeight:int)
		{
			super();
			this.width = width;
			this.height = height;
			
			_contentTitleHeight = contentTitleHeight;
			_contentHeight = contentHeight;
			_items = new Vector.<ContentListItem>();
		}
		
		public function addContentListItem(item:ContentListItem):void{
			item.index = __itemCount;
			item.normalY = __itemCount * (_contentTitleHeight + 3);
			item.otherOpenY = item.normalY + this._contentHeight;
			item.content.width = this.width;
			item.content.height = this._contentHeight;
			new TapGestures(item,change(item.index));
			if(_currentIndex != -1 && _currentIndex > __itemCount){
				item.y = item.otherOpenY;
			}else{
				item.y = item.normalY;
			}
			addChild(item);
			_items.push(item);
			__itemCount++;
		}
		
		public function set currentIndex(value:int):void{
			if(_currentIndex != -1){
				_items[_currentIndex].content.removeFromParent();
			}
			_currentIndex = value == _currentIndex ? -1 : value;
			var count:int = _items.length;
			var item:ContentListItem;
			for (var i:int = 0; i < __itemCount; i++) {
				item = _items[i];
				if(_currentIndex == -1){
					item.y = item.normalY;
				}else if(i < _currentIndex){
					item.y = item.normalY;
				}else if(i > _currentIndex){
					item.y = item.otherOpenY;
				}else{
					item.y = item.normalY;
					item.content.alpha = 1;
					item.content.y = item.y + _contentTitleHeight;
					addChildAt(item.content,0);
				}
			}
		}
		
		private function change(index:int):Function{
			return function():void{
				currentIndex = index;
			}
		}
		
		public function get currentIndex():int{
			return _currentIndex;
		}
	}
}