package lzm.starling.display
{
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class Button extends DisplayObjectContainer
	{
		protected static const MAX_DRAG_DIST:Number = 0;

		private var _enabled:Boolean = true;
		protected var _skin:DisplayObject;
		protected var _disabledSkin:DisplayObject;
		protected var _content:Sprite;
		protected var _textfield:TextField;
		protected var _textFont:String;
		
		protected var _isDown:Boolean;
		
		protected var _w:Number;
		protected var _h:Number;
		
		
		public function Button(skin:DisplayObject,text:String=null,textFont:String=null){
			_content = new Sprite();
			addChild(_content);
			
			_skin = skin;
			_content.addChild(_skin);
			
			_w = _skin.width;
			_h = _skin.height;
			
			if(text != null){
				this.text = text;
			}
			this._textFont = textFont;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		protected function resetContents():void{
			_isDown = false;
			_content.x = _content.y = 0;
			_content.scaleX = _content.scaleY = 1.0;
		}
		
		protected function onTouch(event:TouchEvent):void{
			var touch:Touch = event.getTouch(this);
			if (!enabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !_isDown){
				_content.scaleX = _content.scaleY = 0.9;
				_content.x = (1.0 - 0.9) / 2.0 * _w;
				_content.y = (1.0 - 0.9) / 2.0 * _h;
				_isDown = true;
			}else if (touch.phase == TouchPhase.MOVED && _isDown){
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST){
					resetContents();
				}
			}else if (touch.phase == TouchPhase.ENDED && _isDown){
				resetContents();
				dispatchEventWith(Event.TRIGGERED, true);
			}
		}
		
		protected function createTextfield():void{
			if(_textfield == null){
				_textfield = new TextField(_w,_h,"",_textFont==null?"Verdana":_textFont,12);
				_textfield.vAlign = VAlign.CENTER;
				_textfield.hAlign = HAlign.CENTER;
				_textfield.touchable = false;
				_textfield.color = Color.YELLOW;
				_textfield.nativeFilters = [new GlowFilter(0x000000,1,6,6,6)];
				_content.addChild(_textfield);
			}
			_textfield.width  = _w;
			_textfield.height = _h;
			layoutTextField();
		}
		
		private function layoutTextField():void
		{
			if(_textfield)
			{
				_textfield.x =( _w -_textfield.width)>>1 ;
				_textfield.y = (_h - _textfield.height)>>1;
			}
		}
		
		public function set text(value:String):void{
			createTextfield();
			_textfield.text = value;
		}
		
		public function get text():String{
			if(_textfield){
				return _textfield.text;
			}
			return null;
		}
		
		public function get textField():TextField{
			return _textfield;
		}
		
		public function set textFont(value:String):void{
			_textFont = value;
			if(_textfield){
				_textfield.fontName = _textFont;
			}
		}
		
		public function get content():Sprite{
			return _content;
		}
		public function get skin():DisplayObject{
			return _skin;
		}
		public function set disabledSkin(value:DisplayObject):void
		{
			_disabledSkin = value;
		}
			
		public override function dispose():void{
			if(_textfield){
				_textfield.removeFromParent();
				_textfield.dispose();
				_textfield = null;
			}
			
			_skin.removeFromParent();
			_skin.dispose();
			_skin = null;
			if(_disabledSkin)
			{
				_disabledSkin.removeFromParent();
				_disabledSkin.dispose();
				_disabledSkin = null;
			}
			super.dispose();
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)return;
			_content.removeChildAt(0);
			_enabled = value;
			var setSkin:DisplayObject = _enabled == true ? _skin : _disabledSkin ? _disabledSkin : _skin;
			_content.addChildAt(setSkin, 0);
			_w = setSkin.width;
			_h = setSkin.height;
			layoutTextField();
		}

		
	}
}