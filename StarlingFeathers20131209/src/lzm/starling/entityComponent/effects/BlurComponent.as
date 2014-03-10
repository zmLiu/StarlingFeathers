package lzm.starling.entityComponent.effects
{
	import lzm.starling.entityComponent.EntityComponent;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * 残影效果
	 * @author zmliu
	 */	
	public class BlurComponent extends EntityComponent
	{
		private var showObjects:Vector.<Sprite>;//当前显示的残影
		
		private var entityLastX:int;//实体最后所在的位置
		private var entityLastY:int;
		
		public var alphaSpeed:Number = 0.05;
		public var updateSpeed:int = 3;
		private var currentUpdateTime:int = 0;
		
		public function BlurComponent()
		{
			super();
		}
		
		public override function start():void{
			showObjects = new Vector.<Sprite>();
			
			entityLastX = entity.x;
			entityLastY = entity.y;
		}
		
		public override function update():void{
			var len:int = showObjects.length;
			var i:int;
			var sprite:Sprite;
			if(entity.parent == null){
				for (i = 0; i < len; i++) {
					sprite = showObjects.pop();
					sprite.removeFromParent(true);
				}
				return;
			}else{
				for each (sprite in showObjects) {
					sprite.alpha -= alphaSpeed;
				}
				
				for (i = 0; i < len; i++) {
					sprite = showObjects[i];
					if(sprite.alpha <= 0){
						sprite.removeFromParent(true);
						showObjects.splice(i,1);
						i--;
						len--;
					}
				}
				
				currentUpdateTime++;
				if(currentUpdateTime < updateSpeed){
					return;
				}
				currentUpdateTime = 0;
				
				sprite = cloneSprite(entity);
				sprite.alpha = 1;
				sprite.x = entityLastX;
				sprite.y = entityLastY;
				showObjects.push(sprite);
				
				var index:int = entity.parent.getChildIndex(entity);
				entity.parent.addQuiackChildAt(sprite,index);
				
				entityLastX = entity.x;
				entityLastY = entity.y;
			}
		}
		
		public override function stop():void{
			var len:int = showObjects.length;
			for (var i:int = 0; i < len; i++) {
				showObjects.pop().removeFromParent(true);
			}
		}
		
		public override function dispose():void{
			stop();
			super.dispose();
		}
		
		private function cloneSprite(target:Sprite):Sprite{
			var numChilds:Number = target.numChildren;
			var sprite:Sprite = new Sprite();
			var child:DisplayObject;
			for (var i:int = 0; i < numChilds; i++) {
				child = target.getChildAt(i);
				if(child is Sprite){
					sprite.addQuiackChild(cloneSprite(child as Sprite));
				}else if(child is Image){
					sprite.addQuiackChild(cloneImage(child as Image));
				}
			}
			sprite.transformationMatrix = target.transformationMatrix;
			return sprite;
		}
		
		private function cloneImage(target:Image):Image{
			var image:Image = new Image(target.texture);
			image.transformationMatrix = target.transformationMatrix;
			return image;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}