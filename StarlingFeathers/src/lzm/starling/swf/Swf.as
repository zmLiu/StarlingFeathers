package lzm.starling.swf
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import feathers.textures.Scale9Textures;
	
	import lzm.starling.swf.blendmode.SwfBlendMode;
	import lzm.starling.swf.components.ComponentConfig;
	import lzm.starling.swf.components.ISwfComponent;
	import lzm.starling.swf.display.SwfButton;
	import lzm.starling.swf.display.SwfImage;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.display.SwfParticleSyetem;
	import lzm.starling.swf.display.SwfScale9Image;
	import lzm.starling.swf.display.SwfShapeImage;
	import lzm.starling.swf.display.SwfSprite;
	import lzm.starling.swf.filter.SwfFilter;
	import lzm.util.Clone;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
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
		public static const dataKey_ShapeImg:String = "shapeImg";
		public static const dataKey_Component:String = "comp";
		public static const dataKey_Particle:String = "particle";
		public static const dataKey_BDClip:String = "bdc";
		
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		public static var starlingRoot:Sprite;
		
		public var textureSmoothing:String = TextureSmoothing.BILINEAR;
		
		private static var _isInit:Boolean = false;//是否已经初始化
		public static function init(starlingRoot:Sprite):void{
			if(_isInit) return;

			_isInit = true;
			
			Swf.starlingRoot = starlingRoot;
		}
		
		private const createFuns:Object = {
			"img":createImage,
			"spr":createSprite,
			"mc":createMovieClip,
			"text":createTextField,
			"btn":createButton,
			"s9":createS9Image,
			"shapeImg":createShapeImage,
			"comp":createComponent,
			"particle":createParticle,
			"bdc":createMovieClip
		};
		
		private var _assets:AssetManager;
		private var _swfDatas:Object;
		private var _swfUpdateManager:SwfUpdateManager;
		private var _passedTime:Number;
		
		private var _particleXML:Object;
		
		public function Swf(swfData:ByteArray,assets:AssetManager,fps:int=24){
			if(!_isInit){
				throw new Error("要使用Swf，请先调用Swf.init");
			}
			var bytes:ByteArray = Clone.clone(swfData);
			bytes.uncompress();
			
			this._swfDatas = JSON.parse(new String(bytes));
			this._assets = assets;
			this._swfUpdateManager = new SwfUpdateManager(fps,starlingRoot);
			this._passedTime = 1000 / fps * 0.001;
			this._particleXML = {};
			
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
			_passedTime = 1000 / value * 0.001;
			_swfUpdateManager.fps = value;
		}
		
		public function get fps():int{
			return _swfUpdateManager.fps;
		}
		
		public function get passedTime():Number{
			return _passedTime;
		}
		
		/**
		 * 创建显示对象
		 * */
		public function createDisplayObject(name:String):DisplayObject{
			for(var k:String in createFuns){
				if(_swfDatas[k] && _swfDatas[k][name]){
					var fun:Function = createFuns[k];
					return fun(name);
				}
			}
			return null;
		}
		
		/**
		 * 是否有某个Sprite
		 * */
		public function hasSprite(name:String):Boolean{
			return _swfDatas[dataKey_Sprite][name] != null;
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
			var display:Object;
			var fun:Function;
			for (var i:int = 0; i < length; i++) {
				objData = sprData[i];
				
				fun = createFuns[objData[1]];
				if(fun == null) continue;
				display = fun(objData[0],objData);
				display.name = objData[9];
				if(display is DisplayObject){
					display.x = objData[2];
					display.y = objData[3];
					if(objData[1] != dataKey_Scale9 && objData[1] != dataKey_ShapeImg){
						display.scaleX = objData[4];
						display.scaleY = objData[5];
					}
					display.skewX = objData[6] * ANGLE_TO_RADIAN;
					display.skewY = objData[7] * ANGLE_TO_RADIAN;
					display.alpha = objData[8];
					if(display is ISwfComponent && objData[10] != null){
						display.editableProperties = objData[10];
					}
					sprite.addChild(display as DisplayObject);
				}else if(display is ISwfComponent){
					sprite.addComponent(display as ISwfComponent);
				}
			}
			
			if(data != null) {
				sprite.filter = SwfFilter.createFilter(data[10]);//滤镜
				SwfBlendMode.setBlendMode(sprite,data[11]);
			}
			
			sprite.data = data;
			sprite.spriteData = sprData;
			
			sprite.classLink = name;
			
			return sprite;
		}
		
		/**
		 * 是否有某个MovieClip
		 * */
		public function hasMovieClip(name:String):Boolean{
			if (_swfDatas[dataKey_MovieClip][name] != null)
				return true;

			return _swfDatas[dataKey_BDClip][name] != null;
		}
		
		/**
		 * 创建movieclip
		 * */
		public function createMovieClip(name:String,data:Array=null):SwfMovieClip{
			var movieClipData:Object = _swfDatas[dataKey_MovieClip][name];
			// TODO
			if (movieClipData == null)
				movieClipData = _swfDatas[dataKey_BDClip][name];
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
					if(fun == null) continue;
					displayObjectArray.push(fun(objName,null));
				}
				
				displayObjects[objName] = displayObjectArray;
			}
			
			var mc:SwfMovieClip = new SwfMovieClip(movieClipData["frames"],movieClipData["labels"],displayObjects,this,movieClipData["frameEvents"]);
			mc.loop = movieClipData["loop"];
			
			if(data != null) {
				mc.filter = SwfFilter.createFilter(data[10]);//滤镜
				SwfBlendMode.setBlendMode(mc,data[11]);
			}
			
			mc.classLink = name;
			
			return mc;
		}
		
		/**
		 * 是否有某个Image
		 * */
		public function hasImage(name:String):Boolean{
			return _swfDatas[dataKey_Image][name] != null;
		}
		
		/**
		 * 创建图片
		 * */
		public function createImage(name:String,data:Array=null):SwfImage{
			var texture:Texture = _assets.getTexture(name);
			if(texture == null)
				throw new Error("Texture \"" + name +"\" not exist");
			var imageData:Array = _swfDatas[dataKey_Image][name];
			var image:SwfImage = new SwfImage(texture);
			
			image.smoothing = textureSmoothing;
			
			image.pivotX = imageData[0];
			image.pivotY = imageData[1];
			
			if(data != null) {
				image.filter = SwfFilter.createFilter(data[10]);//滤镜
				SwfBlendMode.setBlendMode(image,data[11]);
			}
			
			image.classLink = name;
			
			return image;
		}
		
		/**
		 * 是否有某个Button
		 * */
		public function hasButton(name:String):Boolean{
			return _swfDatas[dataKey_Button][name] != null;
		}
		
		/**
		 * 创建按钮
		 * */
		public function createButton(name:String,data:Array=null):SwfButton{
			var sprData:Array = _swfDatas[dataKey_Button][name];
			var skin:Sprite = createSprite(null,null,sprData);
			var button:SwfButton = new SwfButton(skin);
			
			if(data != null) {
				button.filter = SwfFilter.createFilter(data[10]);//滤镜
				SwfBlendMode.setBlendMode(button,data[11]);
			}
			
			button.classLink = name;
			return button;
		}
		
		/**
		 * 是否有某个S9Image
		 * */
		public function hasS9Image(name:String):Boolean{
			return _swfDatas[dataKey_Scale9][name] != null;
		}
		
		/**
		 * 创建9宫格图片
		 * */
		public function createS9Image(name:String,data:Array=null):SwfScale9Image{
			var scale9Data:Array = _swfDatas[dataKey_Scale9][name];
			var texture:Texture = _assets.getTexture(name);
			var s9image:SwfScale9Image = new SwfScale9Image(texture,new Rectangle(scale9Data[0],scale9Data[1],scale9Data[2],scale9Data[3]));
			
			if(data != null){
				s9image.width = data[10];
				s9image.height = data[11];
				s9image.filter = SwfFilter.createFilter(data[12]);//滤镜
				SwfBlendMode.setBlendMode(s9image,data[13]);
			}
			
			s9image.classLink = name;
			
			return s9image;
		}
		
		/**
		 * 是否有某个S9Image
		 * */
		public function hasShapeImage(name:String):Boolean{
			return _swfDatas[dataKey_ShapeImg][name] != null;
		}
		
		/**
		 * 创建纹理填充图片
		 * */
		public function createShapeImage(name:String,data:Array=null):SwfShapeImage{
			var imageData:Array = _swfDatas[dataKey_ShapeImg][name];
			
			var shapeImage:SwfShapeImage = new SwfShapeImage(_assets.getTexture(name));
			
			if(data != null){
				shapeImage.setSize(data[10],data[11]);
				shapeImage.filter = SwfFilter.createFilter(data[12]);//滤镜
				SwfBlendMode.setBlendMode(shapeImage,data[13]);
			}
			
			shapeImage.classLink = name;
			
			return shapeImage;
		}
		
		public function createTextField(name:String,data:Array=null):TextField{
			var textfield:TextField = new TextField(2,2,"");
			var filters:Array;
			if(data != null){
				textfield.width = data[10];
				textfield.height = data[11];
				textfield.fontName = data[12];
				textfield.color = data[13];
				textfield.fontSize = data[14];
				textfield.hAlign = data[15];
				textfield.italic = data[16];
				textfield.bold = data[17];
				textfield.text = data[18];
				
				filters = SwfFilter.createTextFieldFilter(data[19]);
				if(filters) textfield.nativeFilters = filters;
				
				SwfBlendMode.setBlendMode(textfield,data[20]);
			}
			return textfield;
		}
		
		/**
		 * 是有有某个组件 
		 */		
		public function hasComponent(name:String):Boolean{
			return _swfDatas[dataKey_Component][name] != null;
		}
		
		public function createComponent(name:String,data:Array=null):*{
			var sprData:Array = _swfDatas[dataKey_Component][name];
			var conponentContnt:SwfSprite = createSprite(name,data,sprData);
			
			var componentClass:Class = ComponentConfig.getComponentClass(name);
			if(componentClass == null){
				return conponentContnt;
			}
			
			var component:ISwfComponent = new componentClass();
			component.initialization(conponentContnt);
			
			if(data != null){
				if(component is DisplayObject) {
					component["filter"] = SwfFilter.createFilter(data[11]);//滤镜
					SwfBlendMode.setBlendMode(component as DisplayObject,data[12]);
				}
			}
			return component;
		}
		
		/**
		 * 是否有某个粒子
		 * */
		public function hasParticle(name:String):Boolean{
			return _swfDatas[dataKey_Particle][name];
		}
		
		/** 
		 * 创建粒子
		 * */
		public function createParticle(name:String,data:Array=null):SwfParticleSyetem{
			var particleData:Array = _swfDatas[dataKey_Particle][name];
			
			var textureName:String = particleData[1];
			var texture:Texture = _assets.getTexture(textureName);
			if(texture == null)
				throw new Error("Texture \"" + name +"\" not exist");
			
			var xml:XML = _particleXML[name];
			if(xml == null){
				xml = new XML(particleData[0]);
				_particleXML[name] = xml;
			}
			
			var particle:SwfParticleSyetem = new SwfParticleSyetem(xml,texture,this);
			
			particle.classLink = name;
			
			return particle;
		}
		
		/**
		 * 合并swf数据 
		 * @param swfData	需要合并的数据
		 * 
		 */		
		public function mergerSwfData(swfData:Object):void{
			var typeKey:String;
			var typeData:Object;
			
			var objectKey:String;
			for(typeKey in swfData){
				typeData = swfData[typeKey];
				for(objectKey in typeData){
					this._swfDatas[typeKey][objectKey] = typeData[objectKey];
				}
			}
		}
		
		/**
		 * 合并swf数据 
		 * @param mergerSwfDataBytes	需要合并的数据
		 * 
		 */		
		public function mergerSwfDataBytes(swfDataBytes:ByteArray):void{
			var bytes:ByteArray = Clone.clone(swfDataBytes);
			bytes.uncompress();
			
			mergerSwfData(JSON.parse(new String(bytes)));
			
			bytes.clear();
		}
		
		public function dispose(disposeAssets:Boolean):void{
			_swfUpdateManager.dispose();
			
			if(disposeAssets){
				_assets.purge();
				_assets.clearRuntimeLoadTexture();
			}
			
			_assets = null;
			_swfDatas = null;
			_swfUpdateManager = null;
		}
		
	}
}