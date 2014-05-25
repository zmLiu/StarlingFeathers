package lzm.util{
	import flash.utils.ByteArray;
	/**
	 * @author xinsiyu 
	 * 20120126 xinsiyu2008@gmail.com
	 */
	public class XXTEA {
		
		public function XXTEA(){
			
		}
		//加密
		public static function NetEncrypt(val:String,key:String):String{
			var datas:ByteArray = ToUtf8(val);
			var keys:ByteArray = ToUtf8(key);
			if (datas.length == 0){
				return val;
			}
			return Utf8toString(ToByteArray(Encrypt(ToUInt32Array(datas, true), ToUInt32Array(keys, false)), false));
		}
		//解密
		public static function NetDecrypt(val:String,key:String):String{
			var datas:ByteArray = Base64.decodeToByteArray(val);
			var keys:ByteArray = ToUtf8(key);
			if (datas.length == 0){
				return val;
			}
			var arrVal:Array = ToByteArray(Decrypt(ToUInt32Array(datas, false), ToUInt32Array(keys, false)), true);
			var express:ByteArray = new ByteArray();
			for(var i:uint=0;i<arrVal.length;i++){
				express[i] = (arrVal[i]);
			}
			
			return express.toString();
		}
		
		private static function ToUInt32Array(datas:ByteArray,includeLength:Boolean):Array{
			var result:Array=new Array();
			var nn:uint = datas.length;
			for (var i:int = 0; i < nn; i++){
				result[i >>> 2] = uint(result[i >>> 2]| uint(datas[i]) << ((i & 3) << 3));
				
			}
			if (includeLength){
				result.push(nn);
				var endIndex:uint = datas.length-1;
				result[(endIndex) >>> 2] = uint(result[(endIndex) >>> 2]| uint(datas[(endIndex)]) << ((endIndex & 3) << 3));
			}
			return result;
		}
		
		private static function Encrypt(v:Array,k:Array):Array{
			var n:int = v.length - 1;
			if (n < 1){
				return v;
			}
			if (k.length < 4){
				var key:Array = new Array();
				key = k.slice();
				k = key;
			}
			while(k.length<4){
				k.push(0);
			}
			var z:uint = v[n], y:uint = v[0],delta:uint = 0x9E3779B9,sum:uint = 0,e:uint=0;
			var p:int=0, q:int = 6 + 52 / (n + 1);
			while (q-- > 0){
				sum = uint(sum + delta);
				e = sum >>> 2 & 3;
				for (p = 0; p < n; p++){
					y = v[p + 1];
					z = uint(v[p] += (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z));
				}
				y = v[0];
				z = uint(v[n] += (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z));
			}
			for(var i:uint=0;i<v.length;i++){
				v[i] = uint(v[i]);
			}
			return v;
		}
		private static function Decrypt(v:Array, k:Array):Array{
			var n:int = v.length - 1;
			if (n < 1){
				return v;
			}
			if (k.length < 4)
			{
				var key:Array = new Array();
				key = k.slice();
				k = key;
			}
			while(k.length<4){
				k.push(0);
			}
			var z:uint = v[n], y:uint = v[0], delta:uint = 0x9E3779B9, sum:uint, e:uint;
			var p:int, q:int = 6 + 52 / (n + 1);
			sum = uint(uint(q) * delta);
			while (sum != 0){
				e = sum >>> 2 & 3;
				for (p = n; p > 0; p--){
					z = v[p - 1];
					y = uint(v[p] -= (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z));
				}
				z = v[n];
				y = uint(v[0] -= (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z));
				sum = uint(sum - delta);
			}
			return v;
		}
		
		private static function ToByteArray(datas:Array,includeLength:Boolean):Array{
			var n:int;
			if (includeLength){
				n = int(datas[datas.length - 1]);
			}
			else{
				n = datas.length << 2;
			}
			var result:Array = new Array();
			for (var i:uint = 0; i < n; i++){
				var byte:uint = (datas[i >>> 2] >>> ((i & 3) << 3)) & uint(255);
				result.push(byte);
			}
			return result;
		}
		
		//to utf8 code
		private static function ToUtf8(str:String):ByteArray{
			var bytes:ByteArray = new ByteArray ();
			bytes.writeUTFBytes(str);
			bytes.position = 0;
			return bytes;
		}
		private static function Utf8toString(arr:Array):String{
			var bytes:ByteArray = new ByteArray ();
			for(var i:uint = 0;i<arr.length;i++){
				bytes.writeByte(arr[i]);
			}
			bytes.position = 0;
			if(bytes.bytesAvailable>0){
				return Base64.encodeByteArray(bytes);
			} 
			return "";
			
			
		}
		
		
		
		
	}
}
