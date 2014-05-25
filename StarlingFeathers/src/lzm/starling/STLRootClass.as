package lzm.starling
{
	import starling.display.Sprite;

	public class STLRootClass extends Sprite
	{
		private var _root:Sprite;
		
		public function STLRootClass()
		{
			
		}
		
		public function start(clazz:Class):void{
			_root = new clazz();
			addChild(_root);
		}
	}
}