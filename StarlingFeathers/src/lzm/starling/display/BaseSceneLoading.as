package lzm.starling.display
{
	import starling.core.Starling;
	import starling.display.Sprite;
	
	import swallow.filters.MosaicFilter;

	public class BaseSceneLoading extends Sprite
	{
		/**
		 * 将要被替换掉的场景 
		 */		
		protected var _replaceScene:BaseScene;
		
		/**
		 * 将要被显示的场景 
		 */		
		protected var _targetScene:BaseScene;
		
		public function BaseSceneLoading()
		{
			
		}
		
		public function show(callBack:Function):void{
			var filter:MosaicFilter = new MosaicFilter(0.1,0.1);
			_replaceScene.filter = filter;
			Starling.juggler.tween(filter,0.3,{thresholdX:12,thresholdY:12,onComplete:function():void{
				_replaceScene.filter = null;
				filter.dispose();
				callBack();
			}});
		}
		
		public function hide(callBack:Function):void{
			var filter:MosaicFilter = new MosaicFilter(12,12);
			_targetScene.filter = filter;
			Starling.juggler.tween(filter,0.3,{thresholdX:0.1,thresholdY:0.1,onComplete:function():void{
				_targetScene.filter = null;
				filter.dispose();
				callBack();
			}});
		}
		
		internal function set replaceScene(value:BaseScene):void{
			_replaceScene = value;
		}
		
		internal function get replaceScene():BaseScene{
			return _replaceScene;
		}
		
		internal function set targetScene(value:BaseScene):void{
			_targetScene = value;
		}
		
		internal function get targetScene():BaseScene{
			return _targetScene;
		}
	}
}