package lzm.starling.entityComponent.gestures 
{
	import lzm.starling.entityComponent.EntityComponent;
	import lzm.starling.gestures.DragGestures;
	
	/**
	 * 拖拽手势 
	 * @author lingjing
	 */	
	public class DragGesturesComponent extends EntityComponent
	{
		
		private var _dragGestures:DragGestures;
		
		public function DragGesturesComponent()
		{
			super();
		}
		
		public override function start():void{
			_dragGestures = new DragGestures(entity);
		}
		
		public override function stop():void{
			_dragGestures.dispose();
			_dragGestures = null;
		}
		
		public override function dispose():void{
			if(_dragGestures){
				_dragGestures.dispose();
			}
			super.dispose();
		}
		
		public function get gestures():DragGestures{
			return _dragGestures;
		}
		
	}
}