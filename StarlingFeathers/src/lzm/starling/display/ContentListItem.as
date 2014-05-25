package lzm.starling.display
{
	import starling.display.Sprite;
	
	public class ContentListItem extends Sprite
	{
		
		private var _content:ScrollContainer;
		
		internal var index:int;
		internal var otherOpenY:Number;//其他item打开后y所在的位置
		internal var normalY:Number//没有其他item打开的时候所在的y的位置
		
		public function ContentListItem()
		{
			super();
			_content = new ScrollContainer();
		}
		
		public function get content():ScrollContainer{
			return _content;
		}
		
	}
}