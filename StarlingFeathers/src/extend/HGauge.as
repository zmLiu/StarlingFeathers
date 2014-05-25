package extend
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class HGauge extends Image
	{
		private var _ratio:Number;
		
		public function HGauge(texture:Texture)
		{
			super(texture);
		}
		
		private function update():void
		{
			scaleY = _ratio;
			setTexCoords(2, new Point(0.0, _ratio));
			setTexCoords(3, new Point(1.0, _ratio));
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