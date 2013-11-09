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
		
		private static var _stage:Stage;
		
		private static var _movieClips:Vector.<SwfMovieClip>;
		
		
		public static function init(stage:Stage):void{
			_stage = stage;
			_movieClips = new Vector.<SwfMovieClip>();
		}
		
		public static function addSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index == -1){
				_movieClips.push(movieClip);
				if(_movieClips.length == 1){
					_stage.addEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
		}
		
		public static function removeSwfMovieClip(movieClip:SwfMovieClip):void{
			var index:int = _movieClips.indexOf(movieClip);
			if(index != -1){
				_movieClips.splice(index,1);
			}
			if(_movieClips.length == 0){
				_stage.removeEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}
		
		private static function enterFrame(e:Event):void{
			for each (var mc:SwfMovieClip in _movieClips) {
				mc.update();
			}
		}
		
		
		
		
		
		
	}
}