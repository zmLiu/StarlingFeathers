package lzm.starling.entityComponent
{
	import starling.events.EventDispatcher;

	public class EntityComponent extends EventDispatcher
	{
		/**
		 * 组件属于哪一个Entity
		 * */
		internal var _entity:Entity;
		
		/**
		 * 组件的名称
		 * */
		public var name:String;
		
		public function EntityComponent()
		{
			
		}
		
		public function get entity():Entity{
			return _entity;
		}
		
		public function start():void{
			
		}
		
		public function update():void{
			
		}
		
		public function stop():void{
			
		}
		
		public function dispose():void{
			_entity = null;
			
			removeEventListeners();
		}
	}
}