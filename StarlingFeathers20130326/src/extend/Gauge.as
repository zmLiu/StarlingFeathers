package extend
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 进度条 
	 * @author lzm
	 * 
	 */	
	public class Gauge extends Image
	{
		private var _ratio:Number;
		
		public function Gauge(texture:Texture)
		{
			super(texture);
		}
		
		private function update():void
		{
			scaleX = _ratio;
			setTexCoords(1, new Point(_ratio, 0.0));
			setTexCoords(3, new Point(_ratio, 1.0));
		}
		
		public function get ratio():Number { return _ratio; }
		public function set ratio(value:Number):void 
		{
			if(value != _ratio){
				_ratio = Math.max(0.0, Math.min(1.0, value));
				update();
			}
		}
	}
}