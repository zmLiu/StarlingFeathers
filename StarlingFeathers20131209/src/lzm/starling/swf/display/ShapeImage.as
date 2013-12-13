package lzm.starling.swf.display
{
	import starling.display.Image;
	import starling.display.Shape;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	/**
	 * 使用纹理填充的图片(纹理长宽需要为2的幂数) 
	 * @author zmliu
	 * 
	 */	
	public class ShapeImage extends Shape
	{
		private var _texture:RenderTexture;
		private var _w:Number;
		private var _h:Number;
		
		public function ShapeImage(texture:Texture)
		{
			super();
			
			_texture = new RenderTexture(texture.width,texture.height);
			_texture.draw(new Image(texture));
			_w = _texture.width;
			_h = _texture.height;
			
			draw();
		}
		
		private function draw():void{
			graphics.clear();
			graphics.beginTextureFill(_texture);
			graphics.drawRect(0,0,_w,_h);
			graphics.endFill();
		}
		
		public override function set width(value:Number):void{
			_w = value;
			draw();
		}
		
		public override function get width():Number{
			return _w;
		}
		
		public override function set height(value:Number):void{
			_h = value;
			draw();
		}
		
		public override function get height():Number{
			return _h;
		}
		
		public function setSize(width:Number,height:Number):void{
			_w = width;
			_h = height;
			draw();
		}
		
		public override function dispose():void{
			graphics.clear();
			_texture.dispose();
			super.dispose();
		}
		
	}
}