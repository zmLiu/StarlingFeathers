package lzm.util
{
	import starling.utils.formatString;

	public class TimeUtil
	{
		/**
		 * 将秒数转换为时间
		 * @param s
		 * 
		 */		
		public static function convertStringToDate(s:int):String{
			if(s <= 0){
				return "00:00:00";
			}
			var h:int = s / (60*60);
			var hStr:String = h+"";
			hStr = hStr.length > 1 ? hStr : "0"+hStr;
			
			s -= h * (60 * 60);
			var m:int = s / 60;
			var mStr:String = m+"";
			mStr = mStr.length > 1 ? mStr : "0"+mStr;
			
			s -= m * 60;
			var sStr:String = s+"";
			sStr = sStr.length > 1 ? sStr : "0"+sStr;
			
			return hStr+":"+mStr+":"+sStr;
		}
		
		/**
		 * 将秒数转换为时间
		 * @param s
		 * 
		 */		
		public static function convertStringToDate2(s:int):String{
			if(s <= 0){
				return "00:00:00";
			}
			var h:int = s / (60*60);
			var hStr:String = h+"";
			hStr = hStr.length > 1 ? hStr : "0"+hStr;
			
			s -= h * (60 * 60);
			var m:int = s / 60;
			var mStr:String = m+"";
			mStr = mStr.length > 1 ? mStr : "0"+mStr;
			
			s -= m * 60;
			var sStr:String = s+"";
			sStr = sStr.length > 1 ? sStr : "0"+sStr;
			
			var d:int = h/24;
			h -= d*24;
			
			if(d > 0){
				return formatString("{0}天 {1}小时 {2}分",d,h,m);
			}else if(h > 0){
				return formatString("{0}小时 {1}分",h,m);
			}else if(m > 0){
				return formatString("{0}分 {1}秒",m,s);
			}else{
				return formatString("{0}秒",s);
			}
		}
		
		public static function parseString(dataString:String):Date{
			var arr:Array = dataString.split(" ");
			var arr1:Array = arr[0].split("-");
			var arr2:Array = arr[1].split(":");
			
			return new Date(arr1[0],arr1[1],arr1[2],arr2[0],arr2[1],arr2[2]);
		}
	}
}