package lzm.starling.entityComponent
{
	import starling.display.Sprite;

	public class Entity extends Sprite
	{
		
		private var _parentEntity:Entity;
		
		private var _childEntitys:Vector.<Entity>;
		private var _components:Vector.<EntityComponent>;
		
		public function Entity()
		{
			_components = new Vector.<EntityComponent>();
			_childEntitys = new Vector.<Entity>();
		}
		
		
		
		
		
		/**
		 * 更新方法
		 * */
		public function update():void{
			for each (var component:EntityComponent in _components) {
				component.update();
			}
			for each (var entity:Entity in _childEntitys) {
				if(entity.visible) entity.update();
			}
		}
		
		/**
		 * 添加子实体
		 * */
		public function addChildEntity(entity:Entity):Entity{
			addChildEntityAt(entity,numChildren);
			return entity;
		}
		
		/**
		 * 添加子实体
		 * */
		public function addChildEntityAt(entity:Entity,index:int):Entity{
			if(entity._parentEntity){
				if(entity._parentEntity == this){
					return entity;
				}
				entity._parentEntity.removeChildEntity(entity);
			}
			entity._parentEntity = this;
			_childEntitys.push(entity);
			
			addChildAt(entity,index);
			
			entity.onAddToParentEntity();
			
			return entity;
		}
		
		/** 被添加到父级实体 的 回掉函数 */
		public function onAddToParentEntity():void{}
		
		/**
		 * 删除子实体
		 * */
		public function removeChildEntity(entity:Entity):Entity{
			if(entity._parentEntity != this) return entity;
			
			entity._parentEntity = null;
			
			var index:int = _childEntitys.indexOf(entity);
			_childEntitys.splice(index,1);

			removeChild(entity);
			
			entity.onRemoveFromParentEntity();
			
			return entity;
		}
		
		/** 父级实体移除 的 回掉函数 */
		public function onRemoveFromParentEntity():void{}
		
		/**
		 * 从父实体删除
		 * */
		public function removeFromParentEntity():Entity{
			if(_parentEntity) _parentEntity.removeChildEntity(this);
			return this;
		}
		
		/**
		 * 根据类添加组件
		 * @param 	componentType	组件的类
		 * @param	componentParams	组件初始化参数
		 */		
		public function addComponentByType(componentType:Class,componentParams:* = null):EntityComponent{
			var component:EntityComponent = componentParams == null ? new componentType() : new componentType(componentParams);
			return addComponent(component);
		}
		
		/**
		 * 添加组件
		 * */
		public function addComponent(component:EntityComponent):EntityComponent{
			if(component._entity) throw Error("组件已经被赋予了实体");
			if(component._entity == this) return component;
			
			_components.push(component);
			
			component._entity = this;
			component.start();
			
			return component;
		}
		
		/**
		 * 删除组件 
		 * @param component	组件
		 */		
		public function removeComponent(component:EntityComponent):EntityComponent{
			var index:int = _components.indexOf(component);
			if(index != -1){
				component.stop();
				_components.splice(index,1);
			}
			component._entity = null;
			return component;
		}
		
		/**
		 * 清理所有组件
		 * */
		public function clearComponent():void{
			var len:int = _components.length;
			var component:EntityComponent;
			for (var i:int = 0; i < len; i++) {
				component = _components.pop();
				component.stop();
				component.dispose();
			}
		}
		
		/**
		 * 根据组件类型查找组件
		 * */
		public function getComponentByType(componentType:Class):EntityComponent{
			var component:EntityComponent = null;
			var filteredComponents:Vector.<EntityComponent> = getComponentsByType(componentType);
			if (filteredComponents.length != 0) {
				component =  filteredComponents[0];
			}
			return component;
		}
		
		/**
		 * 根据组件类型查找组件列表
		 * */
		public function getComponentsByType(componentType:Class):Vector.<EntityComponent>{
			var filteredComponents:Vector.<EntityComponent> = _components.filter(function(item:EntityComponent, index:int, vector:Vector.<EntityComponent>):Boolean{
				return item is componentType;
			});
			return filteredComponents;
		}
		
		/**
		 * 根据组件名字查找组件
		 * */
		public function getComponentByName(name:String):EntityComponent{
			var component : EntityComponent = null;
			var filteredComponents:Vector.<EntityComponent> = _components.filter(function(item:EntityComponent, index:int, vector:Vector.<EntityComponent>):Boolean{
				return item.name == name;
			});
			if (filteredComponents.length != 0) {
				component =  filteredComponents[0];
			}
			return component;
		}
		
		/**
		 * 获取父级实体
		 * */
		public function get parentEntity():Entity{
			return _parentEntity;
		}
		
		/**
		 * 获取子实体
		 * */
		public function get childEntitys():Vector.<Entity>{
			return _childEntitys;
		}
		
		public override function dispose():void{
			for each (var component:EntityComponent in _components) {
				removeComponent(component).dispose();
			}
			_components = null;
			
			for each (var entity:Entity in _childEntitys) {
				entity.removeFromParentEntity();
				entity.dispose();
			}
			_childEntitys = null;
			
			removeFromParentEntity();
			
			super.dispose();
		}
	}
}