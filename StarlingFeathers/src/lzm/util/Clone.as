package lzm.util
{
	import flash.utils.ByteArray;

	public class Clone
	{
		public static function clone(obj:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(obj);
			copier.position = 0;
			return copier.readObject();
		}
	}
}