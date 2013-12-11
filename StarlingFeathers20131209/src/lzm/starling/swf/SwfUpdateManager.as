package lzm.starling.swf
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import lzm.starling.swf.display.SwfMovieClip;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class SwfUpdateManager
	{
		
		private var _stage:Stage;
		private var _fpsUtil:FPSUtil;
		
		private var _movieClips:Vector.<SwfMovieClip>;
		
		public function SwfUpdateManager(fps:int,stage:Stage){
			_fpsUtil = new FPSUtil(fps);
			_stage = stage;
			
			_movieClips = new Vector.<SwfMovieClip>();
		}
		
		
		public function init(stage:Stage):void{
			_stage = stage;
			
		}
		
		public function addSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index == -1){
				_movieClips.push(movieClip);
				if(_movieClips.length == 1){
					_stage.addEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
		}
		
		public function removeSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index != -1){
				_movieClips.splice(index,1);
			}
			if(_movieClips.length == 0){
				_stage.removeEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}
		
		private function enterFrame(e:Event):void{
			if(_fpsUtil.update()){
				for each (var mc:SwfMovieClip in _movieClips) {
					if(mc.parent) mc.update();
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
			_stage.removeEventListener(Event.ENTER_FRAME,enterFrame);
			
			_stage = null;
			_fpsUtil = null;
			_movieClips = null;
		}
		
		
		
		
	}
}