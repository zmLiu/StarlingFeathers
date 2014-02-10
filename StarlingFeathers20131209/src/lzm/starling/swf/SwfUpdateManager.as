package lzm.starling.swf
{
	import lzm.starling.swf.display.SwfMovieClip;
	
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
		
		private var _movieClips:Vector.<SwfMovieClip>;
		
		public function SwfUpdateManager(fps:int,starlingRoot:Sprite){
			_fpsUtil = new FPSUtil(fps);
			_starlingRoot = starlingRoot;
			
			_movieClips = new Vector.<SwfMovieClip>();
		}
		
		public function addSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index == -1){
				_movieClips.push(movieClip);
				if(_movieClips.length == 1){
					_starlingRoot.addEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
		}
		
		public function removeSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index != -1){
				_movieClips.splice(index,1);
			}
			if(_movieClips.length == 0){
				_starlingRoot.removeEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}
		
		private function enterFrame(e:EnterFrameEvent):void{
			if(_fpsUtil &&_fpsUtil.update()){
				for each (var mc:SwfMovieClip in _movieClips) {
					if(mc.stage) mc.update();
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
			_movieClips = null;
		}
		
		
		
		
	}
}