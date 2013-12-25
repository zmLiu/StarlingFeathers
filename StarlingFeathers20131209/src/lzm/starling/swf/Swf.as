package lzm.starling.swf
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lzm.starling.display.Button;
	import lzm.starling.swf.display.ShapeImage;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.display.SwfSprite;
	import lzm.util.Clone;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class Swf
	{
		public static const dataKey_Sprite:String = "spr";
		public static const dataKey_Image:String = "img";
		public static const dataKey_MovieClip:String = "mc";
		public static const dataKey_TextField:String = "text";
		public static const dataKey_Button:String = "btn";
		public static const dataKey_Scale9:String = "s9";
		public static const dataKey_ShapeImg:String = "shapeImg"
		
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		public static var stage:Stage;
		
		public static function init(stage:Stage):void{
			Swf.stage = stage;
		}
		
		private const createFuns:Object = {
			"img":createImage,
			"spr":createSprite,
			"mc":createMovieClip,
			"text":createTextField,
			"btn":createButton,
			"s9":createS9Image,
			"shapeImg":createShapeImage
		};
		
		private var _assets:AssetManager;
		private var _swfDatas:Object;
		private var _swfUpdateManager:SwfUpdateManager;
		
		public function Swf(swfData:ByteArray,assets:AssetManager,fps:int=24){
			var bytes:ByteArray = Clone.clone(swfData);
			bytes.uncompress();
			
			this._swfDatas = JSON.parse(new String(bytes));
			this._assets = assets;
			this._swfUpdateManager = new SwfUpdateManager(fps,stage);
			
			bytes.clear();
		}
		
		/**
		 * swf数据
		 * */
		public function get swfData():Object{
			return _swfDatas;
		}
		
		/**
		 * 获取资源
		 * */
		public function get assets():AssetManager{
			return _assets;
		}
		
		/**
		 * 更新器
		 * */
		public function get swfUpdateManager():SwfUpdateManager{
			return _swfUpdateManager;
		}
		
		
		/**
		 * 设置/获取 帧频率
		 * */
		public function set fps(value:int):void{
			_swfUpdateManager.fps = value;
		}
		
		public function get fps():int{
			return _swfUpdateManager.fps;
		}
		
		/**
		 * 创建sprite
		 * */
		public function createSprite(name:String,data:Array=null,sprData:Array=null):SwfSprite{
			if(sprData == null){
				sprData = _swfDatas[dataKey_Sprite][name];
			}
			
			var sprite:SwfSprite = new SwfSprite();
			var length:int = sprData.length;
			var objData:Array;
			var display:DisplayObject;
			var fun:Function;
			for (var i:int = 0; i < length; i++) {
				objData = sprData[i];
				
				fun = createFuns[objData[1]];
				display = fun(objData[0],objData);
					
				display.x = objData[2];
				display.y = objData[3];
				if(objData[1] != dataKey_Scale9 && objData[1] != dataKey_ShapeImg){
					display.scaleX = objData[4];
					display.scaleY = objData[5];
				}
				display.skewX = objData[6] * ANGLE_TO_RADIAN;
				display.skewY = objData[7] * ANGLE_TO_RADIAN;
				display.alpha = objData[8];
				display.name = objData[9];
				sprite.addChild(display);
			}
			
			return sprite;
		}
		
		/**
		 * 创建movieclip
		 * */
		public function createMovieClip(name:String,data:Array=null):SwfMovieClip{
			var movieClipData:Object = _swfDatas[dataKey_MovieClip][name];
			
			var objectCountData:Object = movieClipData["objCount"];
			var displayObjects:Object = {};
			var displayObjectArray:Array;
			var type:String;
			var count:int;
			var fun:Function;
			for(var objName:String in objectCountData){
				type = objectCountData[objName][0];
				count = objectCountData[objName][1];
				
				displayObjectArray = displayObjects[objName] == null ? [] : displayObjects[objName];
				
				for (var i:int = 0; i < count; i++) {
					fun = createFuns[type];
					displayObjectArray.push(fun(objName,null));
				}
				
				displayObjects[objName] = displayObjectArray;
			}
			
			var mc:SwfMovieClip = new SwfMovieClip(movieClipData["frames"],movieClipData["labels"],displayObjects,this);
			mc.loop = movieClipData["loop"];
			
			return mc;
		}
		
		/**
		 * 创建图片
		 * */
		public function createImage(name:String,data:Array=null):Image{
			var imageData:Array = _swfDatas[dataKey_Image][name];
			var image:Image = new Image(_assets.getTexture(name));
			
			image.pivotX = imageData[0];
			image.pivotY = imageData[1];
			
			return image;
		}
		
		/**
		 * 创建按钮
		 * */
		public function createButton(name:String,data:Array=null):Button{
			var sprData:Array = _swfDatas[dataKey_Button][name];
			var skin:Sprite = createSprite(null,null,sprData);
			return new Button(skin);
		}
		
		/**
		 * 创建9宫格图片
		 * */
		public function createS9Image(name:String,data:Array=null):Scale9Image{
			var scale9Data:Array = _swfDatas[dataKey_Scale9][name];
			var texture:Texture = _assets.getTexture(name);
			var s9Texture:Scale9Textures = new Scale9Textures(texture,new Rectangle(scale9Data[0],scale9Data[1],scale9Data[2],scale9Data[3]));
			var s9image:Scale9Image = new Scale9Image(s9Texture,_assets.scaleFactor);
			
			if(data){
				s9image.width = data[10];
				s9image.height = data[11];
			}
			
			return s9image;
		}
		
		/**
		 * 创建纹理填充图片
		 * */
		public function createShapeImage(name:String,data:Array=null):ShapeImage{
			var imageData:Array = _swfDatas[dataKey_ShapeImg][name];
			
			var shapeImage:ShapeImage = new ShapeImage(_assets.getTexture(name));
			
			if(data){
				shapeImage.setSize(data[10],data[11]);
			}
			
			return shapeImage;
		}
		
		public function createTextField(name:String,data:Array=null):TextField{
			var textfield:TextField = new TextField(2,2,"");
			if(data){
				textfield.width = data[10];
				textfield.height = data[11];
				textfield.fontName = data[12];
				textfield.color = data[13];
				textfield.fontSize = data[14];
				textfield.hAlign = data[15];
				textfield.italic = data[16];
				textfield.bold = data[17];
				textfield.text = data[18];
			}
			return textfield;
		}
		
		public function dispose(disposeAssets:Boolean):void{
			_swfUpdateManager.dispose();
			
			if(disposeAssets){
				_assets.purge();
				_assets.dispose();
			}
			
			_assets = null;
			_swfDatas = null;
			_swfUpdateManager = null;
		}
		
	}
}