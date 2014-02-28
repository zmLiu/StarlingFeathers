package lzm.game.entityComponent
{
	public class EntityComponent
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
		}
	}
}