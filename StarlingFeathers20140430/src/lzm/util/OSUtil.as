package lzm.util
{
	import flash.system.Capabilities;

	public class OSUtil
	{
		public static function isMac():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("MAC") != -1;
		}
		
		public static function isWindows():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("WIN") != -1;
		}
		
		public static function isAndriod():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("ANDROID") != -1;
		}
		
		public static function isIPhone():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("IPHONE") != -1;
		}
	}
}