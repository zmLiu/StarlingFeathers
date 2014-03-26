package lzm.starling.swf.display
{
	import starling.display.Stage;

	public interface ISwfAnimation
	{
		function update():void;
		
		function get stage():Stage;
	}
}