package lzm.starling.swf.components
{
	import lzm.starling.swf.display.SwfSprite;

	public interface ISwfComponent
	{
		
		/**
		 * 设置 /获取 组件名称
		 * */
		function get name():String;
		function set name(value:String):void;
		
		/**
		 * 初始化组件 
		 * @param componetContent	组件的基础显示内容
		 */	
		function initialization(componetContent:SwfSprite):void;
		
		/**
		 * 获取 / 设置 可编辑属性
		 * */
		function get editableProperties():Object;
		function set editableProperties(properties:Object):void;
	}
}