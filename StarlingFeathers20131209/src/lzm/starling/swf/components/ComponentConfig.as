package lzm.starling.swf.components
{
	import lzm.starling.swf.components.feathers.FeathersButton;
	import lzm.starling.swf.components.feathers.FeathersCheck;

	public class ComponentConfig
	{
		
		private static var componentClass:Object = {
			"comp_feathers_button":FeathersButton,
			"comp_feathers_check":FeathersCheck
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
	}
}