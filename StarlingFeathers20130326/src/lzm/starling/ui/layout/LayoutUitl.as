package lzm.starling.ui.layout
{
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lzm.starling.display.Button;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.VAlign;

	/**
	 * 布局器,根据导出工具导出的数据格式 
	 * @author lzm
	 * 
	 */	
	public class LayoutUitl
	{
		
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		public var imagesData:Object;
		public var layoutsData:Object;
		public var asset:AssetManager;
		
		public function LayoutUitl(layoutData:Object,asset:AssetManager)
		{
			this.imagesData = layoutData["images"];
			this.layoutsData = layoutData["layout"];
			this.asset = asset;
		}
		
		/**
		 * 构建一个显示对象的布局
		 * */
		public function buildLayout(name:String,target:Sprite):void{
			var layout:Array = layoutsData[name];
			var data:Object;
			var display:DisplayObject;
			var length:int = layout.length;
			for (var i:int = 0; i < layout.length; i++) {
				data = layout[i];
				if(data.type == "sprite"){
					display = createSprite(data.cname);
				}else if(data.type == "image"){
					display = createImage(data.cname);
				}else if(data.type == "s9image"){
					display = createS9Image(data.cname);
				}else if(data.type == "batch"){
					display = createBatch(data.cname);
				}else if(data.type == "btn"){
					display = createButton(data.cname);
				}else if(data.type == "text"){
					display = createTextField(data);
				}
				display.x = data.x;
				display.y = data.y;
				if(data.type == "s9image"){
					display.width = data.w;
					display.height = data.h;
				}else{
					display.scaleX = data.sx;
					display.scaleY = data.sy;
				}
				display.skewX = data.skx * ANGLE_TO_RADIAN;
				display.skewY = data.sky * ANGLE_TO_RADIAN;
				if(data.name){
					display.name = data.name;
				}
				target.addChild(display);
			}
		}
		
		/**
		 * 创建sprite，一般为一个布局
		 * */
		public function createSprite(name:String):Sprite{
			var returnSprite:Sprite = new Sprite();
			var layout:Array = layoutsData[name];
			var data:Object;
			var display:DisplayObject;
			var length:int = layout.length;
			for (var i:int = 0; i < layout.length; i++) {
				data = layout[i];
				if(data.type == "sprite"){
					display = createSprite(data.cname);
				}else if(data.type == "image"){
					display = createImage(data.cname);
				}else if(data.type == "s9image"){
					display = createS9Image(data.cname);
				}else if(data.type == "batch"){
					display = createBatch(data.cname);
				}else if(data.type == "btn"){
					display = createButton(data.cname);
				}else if(data.type == "text"){
					display = createTextField(data);
				}
				display.x = data.x;
				display.y = data.y;
				if(data.type == "s9image"){
					display.width = data.w;
					display.height = data.h;
				}else{
					display.scaleX = data.sx;
					display.scaleY = data.sy;
				}
				display.skewX = data.skx * ANGLE_TO_RADIAN;
				display.skewY = data.sky * ANGLE_TO_RADIAN;
				if(data.name){
					display.name = data.name;
				}
				returnSprite.addChild(display);
			}
			return returnSprite;
		}
		
		/**
		 * 创建按钮
		 * */
		public function createButton(name:String):Button{
			var skin:Sprite = new Sprite();
			buildLayout(name,skin);
			return new Button(skin);
		}
		
		/**
		 * 创建批处理对象
		 * */
		public function createBatch(name:String):QuadBatch{
			var quadBatch:QuadBatch = new QuadBatch();
			var layout:Array = layoutsData[name];
			var image:Image;
			var data:Object;
			
			var length:int = layout.length;
			for (var i:int = 0; i < length; i++) {
				data = layout[i];
				image = createImage(data.cname);
				image.x = data.x;
				image.y = data.y;
//				image.width = data.w;
//				image.height = data.h;
				image.scaleX = data.sx;
				image.scaleY = data.sy;
				image.skewX = data.skx * ANGLE_TO_RADIAN;
				image.skewY = data.sky * ANGLE_TO_RADIAN;
				quadBatch.addImage(image);
			}
			return quadBatch;
		}
		
		/**
		 * 创建图片
		 * */
		public function createImage(name:String):Image{
			try
			{
				var imageData:Object = imagesData[name];
				var texture:Texture = asset.getTexture(name);
				
				var image:Image = new Image(texture);
				image.pivotX = -imageData.x;
				image.pivotY = -imageData.y;
				
				return image;
			} 
			catch(error:Error) 
			{
				trace(name);
			}
			return null;
		}
		
		/**
		 * 创建9宫格图片
		 * */
		public function createS9Image(name:String):Scale9Image{
			var imageData:Object = imagesData[name];
			var texture:Texture = asset.getTexture(name);
			
			var s9Texture:Scale9Textures = new Scale9Textures(texture,new Rectangle(imageData.s9gw,imageData.s9gw,1,1));
			var s9image:Scale9Image = new Scale9Image(s9Texture);
			
			return s9image;
		}
		
		public function createTextField(data:Object):TextField{
			var textfield:TextField = new TextField(data.w,data.h,data.text,data.font,data.size,data.color,data.bold);
			textfield.italic = data.italic;
			textfield.vAlign = VAlign.CENTER;
			textfield.hAlign = data.align;
			textfield.touchable = false;
//			textfield.nativeFilters = [new GlowFilter(0x000000,1,6,6,6)];
			return textfield;
		}
		
		
		/**
		 * 添加布局信息
		 * */
		public function addLayout(layoutData:Object):void{
			var imagesData:Object = layoutData["images"];
			var layoutsData:Object = layoutData["layout"];
			
			var k:String;
			for (k in imagesData) {
				this.imagesData[k] = imagesData[k];
			}
			
			for (k in layoutsData) {
				this.layoutsData[k] = layoutsData[k];
			}
			
		}
		
	}
}