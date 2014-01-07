package lzm.starling.swf.components
{
	import lzm.starling.swf.components.feathers.FeathersButton;

	public class ComponentConfig
	{
		
		private static var componentClass:Object = {
			"comp_feathers_btn":FeathersButton
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