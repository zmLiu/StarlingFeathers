package lzm.starling.display
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 任意变形的图片 
	 * @author lzm
	 * 
	 */	
	public class DistortImage extends Image
	{
		
		private var _w:Number;
		private var _h:Number;
		
		public function DistortImage(texture:Texture)
		{
			super(texture);
			_w = texture.width;
			_h = texture.height;
		}
		
		/**
		 * 设置顶点位置
		 * */
		public function setVertextDataPostion(vertexID:int, x:Number, y:Number):void{
			switch(vertexID)
			{
				case 0:
					mVertexData.setPosition(vertexID,x,y);
					break;
				case 1:
					mVertexData.setPosition(vertexID,_w + x,y);
					break;
				case 2:
					mVertexData.setPosition(vertexID,x,_h + y);
					break;
				case 3:
					mVertexData.setPosition(vertexID,_w + x,_h + y);
					break;
			}
			resetAllTexCoords();
			onVertexDataChanged();
		}
		
		/**重置UV坐标*/
		protected function resetAllTexCoords():void
		{
			mVertexData.setTexCoords(0, 0, 0);
			mVertexData.setTexCoords(1, 1, 0);
			mVertexData.setTexCoords(2, 0, 1);
			mVertexData.setTexCoords(3, 1.0, 1.0);
		}
		
	}
}