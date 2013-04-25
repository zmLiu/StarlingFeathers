package lzm.starling.display
{
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import lzm.starling.display.Button;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 公用场景
	 * @author lzm
	 */	
	public class BaseScene extends Sprite
	{
		public static const EVENT_BULIDERCOMPLETE:String = "EVENT_BULIDERCOMPLETE";
		
		public static var currentScene:BaseScene;
		
		private static var _backBtnTexture:Texture;//返回按钮的纹理
		private static var _sceneLoading:BaseSceneLoading;//场景loading
		
		private static var sceneClassNameQueue:Array = [];
		private static var sceneParamsQueue:Array = [];
		private static var sceneNumberQueue:int = 0;
		
		protected var _backButton:Button;
		private var _sceneNumber:int = 0;//在场景列表列表里面的第几个
		private var _addToStageType:int;//被显示时候的类型。 0 - 作为一个新的场景替换调之前的场景，1 - 作为另外一个场景的子场景
		private var _parentScene:BaseScene;//父场景
		private var _childScene:BaseScene;//子场景---目前只支持一个
		
		protected var _params:Array;
		
		/**
		 * 初始化场景的一些参数 
		 * @param backBtnTexture	返回按钮的纹理
		 * @param sceneLoading		场景loading
		 * 
		 */		
		public static function initBaseScene(backBtnTexture:Texture,sceneLoading:BaseSceneLoading):void{
			_backBtnTexture = backBtnTexture;
			_sceneLoading = sceneLoading;
		}
		
		public function BaseScene(params:Array)
		{
			_params = params;
			if(currentScene == null){
				currentScene = this;
			}
		}
		
		
		protected function addBackFunction():void{
			if(_backButton == null){
				_backButton = new Button(new Image(_backBtnTexture));
				_backButton.x = 14;
				_backButton.y = 7.5;
				addChild(_backButton);
			}
			_backButton.removeEventListeners(Event.TRIGGERED);
			if(_addToStageType == 0){
				_backButton.addEventListener(Event.TRIGGERED,backFunction);
			}else if(_addToStageType == 1){
				_backButton.addEventListener(Event.TRIGGERED,backToParentScene);
			}
		}
		
		/**
		 * 回到上一层
		 * */
		protected function backFunction(e:Event):void{
			sceneNumberQueue--;
			
			var clazz:Class = sceneClassNameQueue.pop();
			replaceClass(clazz,sceneParamsQueue.pop() as Array);
		}
		
		/**
		 * 返回到父级场景
		 */		
		protected function backToParentScene(e:Event):void{
			_parentScene.popScene();
		}
		
		/**
		 * 添加子场景，目前只支持一个子场景
		 * @param	scene		需要添加的场景
		 * @param	hideSelf	是否隐藏本身
		 * */
		public function pushScene(scene:BaseScene,hideSelf:Boolean = true):void{
			if(_childScene) return;
			
			scene._parentScene = this;
			_childScene = scene;
			_childScene._addToStageType = 1;
			_childScene.addBackFunction();
			parent.addChild(_childScene);
			if(hideSelf) this.visible = false;
		}
		
		/**
		 * 删除子场景
		 */		
		public function popScene():void{
			if(_childScene == null) return;
			
			_childScene._parentScene = null;
			_childScene.removeFromParent(true);
			this._childScene = null;
			this.visible = true;
		}
		
		/**
		 * 把该场景替换位另外一个场景
		 * @param sceneClass	需要切换的场景类
		 * @param params		场景构造需要的参数
		 * @param callBack		场景创建完毕的回调
		 */
		public function replaceClass(sceneClass:Class,params:Array,callBack:Function=null):void{
			this.touchable = false;
			var tempParent:DisplayObjectContainer = this.parent;
			if(tempParent == null){
				throw new Error("没有父级，不能替换");
			}
			_sceneLoading.replaceScene = this;
			_sceneLoading.show(function():void{
				_sceneLoading.replaceScene = null;
				if(sceneNumberQueue == _sceneNumber){
					sceneClassNameQueue.push(getSelfClass());
					sceneParamsQueue.push(_params);
					sceneNumberQueue ++;
				}
				
				var scene:BaseScene = new sceneClass(params);
				_sceneLoading.targetScene = scene;
				scene._sceneNumber = sceneNumberQueue;
				scene._addToStageType = 0;
				scene.addEventListener(EVENT_BULIDERCOMPLETE,buliderCompleteFunc);
				
				function buliderCompleteFunc(e:Event):void{
					scene.removeEventListener(EVENT_BULIDERCOMPLETE,buliderCompleteFunc);
					if(scene._sceneNumber > _sceneNumber || sceneClassNameQueue.length > 0){
						scene.addBackFunction();
					}
					
					currentScene = scene;
					tempParent.addChild(scene);
					
					if(callBack) callBack(scene);
					_sceneLoading.hide(function():void{
						replaceTweenOver(tempParent);
						_sceneLoading.targetScene = null;
					});
				}
			});
		}
		
		/**
		 * 把该场景替换位另外一个场景并且把替换的场景作为root场景
		 * @param sceneClass	需要切换的场景类
		 * @param params		场景构造需要的参数
		 * @param callBack		场景创建完毕的回调
		 */
		public function replaceClassBeRoot(sceneClass:Class,params:Array,callBack:Function=null):void{
			this.touchable = false;
			var tempParent:DisplayObjectContainer = this.parent;
			if(tempParent == null){
				throw new Error("没有父级，不能替换");
			}
			_sceneLoading.replaceScene = this;
			_sceneLoading.show(function():void{
				_sceneLoading.replaceScene = null;
				sceneClassNameQueue = [];
				sceneParamsQueue = [];
				sceneNumberQueue = 0;
				
				
				var scene:BaseScene = new sceneClass(params);
				_sceneLoading.targetScene = scene;
				scene._sceneNumber = sceneNumberQueue;
				scene._addToStageType = 0;
				scene.addEventListener(EVENT_BULIDERCOMPLETE,buliderCompleteFunc);
				
				
				function buliderCompleteFunc(e:Event):void{
					scene.removeEventListener(EVENT_BULIDERCOMPLETE,buliderCompleteFunc);
					
					currentScene = scene;
					tempParent.addChild(scene);
					
					if(callBack) callBack(scene);
					
					_sceneLoading.hide(function():void{
						replaceTweenOver(tempParent);
						_sceneLoading.targetScene = null;
					});
				}
			});
		}
		
		
		/**
		 * 派发场景构建完成的事件 
		 */		
		public function dispatchBuliderComplete():void{
			setTimeout(function():void{
				dispatchEventWith(EVENT_BULIDERCOMPLETE);
				removeEventListeners(EVENT_BULIDERCOMPLETE);
			},1);
		}
		
		protected function replaceTweenOver(parent:DisplayObjectContainer):void{
			parent.removeChild(this,true);
		}
		
		protected function getSelfClass():Class{
			var clazz:String = getQualifiedClassName(this);
			return getDefinitionByName(clazz) as Class;
		}
		
		/**
		 * 释放一个显示对象
		 */		
		public function disposeDisplayObject(display:DisplayObject):void{
			if(display){
				display.removeFromParent();
				display.dispose();
				display = null;
			}
		}
		
		/**
		 *  
		 * @return 父级场景，没有返回null 
		 * 
		 */		
		public function get parentScene():BaseScene{
			return _parentScene;
		}
		
		/**
		 * 
		 * @return 子场景，没有返回null 
		 * 
		 */		
		public function get childScene():BaseScene{
			return _childScene;
		}
		
		public override function dispose():void{
			if(_backButton){
				_backButton.removeFromParent();
				_backButton.dispose();
			}
			System.pauseForGCIfCollectionImminent(1);
			super.dispose();
		}
	}
}


