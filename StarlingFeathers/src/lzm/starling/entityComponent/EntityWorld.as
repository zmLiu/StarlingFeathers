package lzm.starling.entityComponent
{
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	public class EntityWorld extends Entity
	{
		public function EntityWorld()
		{
			
		}
		
		protected function enterFrame(e:EnterFrameEvent):void{
			update();
		}
		
		/**
		 * 开始
		 * */
		public function start():void{
			addEventListener(Event.ENTER_FRAME,enterFrame);			
		}
		
		/**
		 * 停止
		 * */
		public function stop():void{
			removeEventListener(Event.ENTER_FRAME,enterFrame);
		}
		
		public override function dispose():void{
			stop();
			super.dispose();
		}
	}
}