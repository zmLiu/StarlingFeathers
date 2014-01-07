package lzm.starling.swf.components
{
	import lzm.starling.swf.display.SwfSprite;

	public interface ISwfComponent
	{
		/**
		 * 初始化组件 
		 * @param componetContent	组件的基础显示内容
		 */	
		function initialization(componetContent:SwfSprite):void;
	}
}