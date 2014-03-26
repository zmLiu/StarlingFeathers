package lzm.starling.swf
{
	import lzm.starling.swf.display.ISwfAnimation;
	
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class SwfUpdateManager
	{
		
		private var _starlingRoot:Sprite;
		private var _fpsUtil:FPSUtil;
		
		private var _animations:Vector.<ISwfAnimation>;
		
		public function SwfUpdateManager(fps:int,starlingRoot:Sprite){
			_fpsUtil = new FPSUtil(fps);
			_starlingRoot = starlingRoot;
			
			_animations = new Vector.<ISwfAnimation>();
		}
		
		public function addSwfAnimation(animation:ISwfAnimation):void{
			var index:int = _animations.indexOf(animation);
			if(index == -1){
				_animations.push(animation);
				if(_animations.length == 1){
					_starlingRoot.addEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
		}
		
		public function removeSwfAnimation(animation:ISwfAnimation):void{
			var index:int = _animations.indexOf(animation);
			if(index != -1){
				_animations.splice(index,1);
			}
			if(_animations.length == 0){
				_starlingRoot.removeEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}
		
		private function enterFrame(e:EnterFrameEvent):void{
			if(_fpsUtil &&_fpsUtil.update()){
				for each (var animation:ISwfAnimation in _animations) {
					if(animation.stage) animation.update();
				}
			}
		}
		
		public function set fps(value:int):void{
			_fpsUtil.fps = value;
		}
		
		public function get fps():int{
			return _fpsUtil.fps;
		}
		
		public function dispose():void{
			_starlingRoot.removeEventListener(Event.ENTER_FRAME,enterFrame);
			
			_starlingRoot = null;
			_fpsUtil = null;
			_animations = null;
		}
		
		
		
		
	}
}