package lzm.starling.display
{
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	
	import lzm.starling.gestures.MoveOverGestures;
	import lzm.util.DoScale;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class ImageViewer extends ScrollContainer
	{
		private var _tempHorizontalPosition:Number = 0;
		private var _tempIndex:int = 0;
		
		public function ImageViewer(width:Number,height:Number)
		{
			super();
			this.width = width;
			this.height= height;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 0;
			
			this.layout = layout;
			this.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			new MoveOverGestures(this,stopMove);
		}
		
		private function stopMove():void{
			scroller.stopScrolling();
			if(_tempHorizontalPosition > horizontalScrollPosition){//往左边滑动了
				_tempIndex--;
			}else if(_tempHorizontalPosition < horizontalScrollPosition){//往右边滑动了
				_tempIndex++;
			}
			
			var maxIndex:int = int(maxHorizontalScrollPosition / width);
			_tempIndex = _tempIndex < 0 ? 0 : _tempIndex;
			_tempIndex = _tempIndex > maxIndex ? maxIndex : _tempIndex;
			
			_tempHorizontalPosition = _tempIndex * width;
			
			Starling.juggler.tween(this,0.1,{horizontalScrollPosition:_tempHorizontalPosition});
		}
		
		public function addImage(image:DisplayObject):void{
			var scObject:Object = DoScale.doScale(image.width,image.height,width,height);
			image.scaleX = scObject.sx;
			image.scaleY = scObject.sy;
			
			var item:ScrollContainerItem = new ScrollContainerItem();
			item.addChild(image);
			
			addScrollContainerItem(item);
		}
	}
}