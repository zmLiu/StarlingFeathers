package starling.events
{
	import flash.utils.Dictionary;
	
	public class EnterFrameManager
	{
		
		private static var _listenersDictionary:Dictionary = new Dictionary();
		
		public static function addEventListener(target:EventDispatcher,listener:Function):void{
			var listeners:Vector.<Function> = _listenersDictionary[target];
			if(listeners == null){
				listeners = new Vector.<Function>();
			}
			listeners.push(listener);
			_listenersDictionary[target] = listeners;
		}
		
		public static function removeEventListener(target:EventDispatcher, listener:Function):void{
			var listeners:Vector.<Function> = _listenersDictionary[target];
			if(listeners == null) return;
			
			var count:int = listeners.length;
			for (var i:int = 0; i < count; i++) {
				if(listener == listeners[i]){
					listeners.splice(i,1);
					break;
				}
			}
			if(listeners.length == 0) delete _listenersDictionary[target];
		}
		
		public static function removeEventListeners(target:EventDispatcher):void{
			delete _listenersDictionary[target];
		}
		
		public static function advanceTime(e:Event):void{
			var target:*;
			var listeners:Vector.<Function>;
			var listener:Function;
			for (target in _listenersDictionary) {
				listeners = _listenersDictionary[target];
				for each (listener in listeners) {
					e.setTarget(target);
					e.setCurrentTarget(target);
					listener(e);
				}
			}
		}
		
	}
}