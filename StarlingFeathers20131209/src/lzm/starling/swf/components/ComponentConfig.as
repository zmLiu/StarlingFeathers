package lzm.starling.swf.components
{
	import lzm.starling.swf.components.feathers.FeathersButton;
	import lzm.starling.swf.components.feathers.FeathersCheck;
	import lzm.starling.swf.components.feathers.FeathersProgressBar;
	import lzm.starling.swf.components.feathers.FeathersTextInput;

	public class ComponentConfig
	{
		
		private static var componentClass:Object = {
			"comp_feathers_button":FeathersButton,
			"comp_feathers_check":FeathersCheck,
			"comp_feathers_input":FeathersTextInput,
			"comp_feathers_progressbar":FeathersProgressBar
		};
		
		/**
		 * 获取组建的类
		 * */
		public static function getComponentClass(classKey:String):Class{
			for(var key:String in componentClass){
				if(classKey.indexOf(key) == 0){
					return componentClass[key];
				}
			}
			return null;
		}
		
		/**
		 * 动态添加组件
		 * */
		public static function addComponentClass(compName:String,compClass:Class):void{
			componentClass[compName] = compClass;
		}
		
		/**
		 * 移除组件
		 * */
		public static function removeComponentClass(compName:String):void{
			delete componentClass[compName];
		}
		
	}
}