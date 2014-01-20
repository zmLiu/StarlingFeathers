package lzm.starling.swf.display
{
	import feathers.display.Scale9Image;
	
	import lzm.starling.swf.components.ISwfComponent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * 封装一层Sprite方便取各个类型的子对象
	 * @author °无量，zmliu
	 */
	public class SwfSprite extends Sprite 
	{
		
		/**
		 * sprite的类名
		 * */
		public var spriteName:String;
		/**
		 * sprite本身的数据 
		 * */
		public var data:Array;
		/**
		 * sprite child的数据
		 * */
		public var spriteData:Array;
		
		public function SwfSprite() 
		{
			
		}
		public function getTextField(name:String):TextField
		{
			return getChildByName(name) as TextField;
		}
		public function getButton(name:String):Button
		{
			return getChildByName(name) as Button;
		}
		public function getMovie(name:String):SwfMovieClip
		{
			return getChildByName(name) as SwfMovieClip;
		}
		public function getSprite(name:String):SwfSprite
		{
			return getChildByName(name) as SwfSprite;
		}
		public function getImage(name:String):Image
		{
			return getChildByName(name) as Image;
		}
		public function getScale9Image(name:String):Scale9Image
		{
			return getChildByName(name) as Scale9Image;
		}
		
		public function getShapeImage(name:String):ShapeImage{
			return getChildByName(name) as ShapeImage;
		}
		
		
		//---------------以下为非显示对象的组件--------//
		public function addComponent(component:ISwfComponent):void{
			
		}
		public function getComponent(name:String):ISwfComponent{
			return null;
		}
		
		
		
	}

}