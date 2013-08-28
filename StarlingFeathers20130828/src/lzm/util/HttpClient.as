package lzm.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * http网络请求工具
	 * @author lzm
	 */	
	public class HttpClient
	{
		/**
		 * 请求url 
		 * @param url
		 * @param params
		 * @param completeFunction
		 * @param method
		 * 
		 */		
		public static function send(url:String,params:Object,completeFunction:Function=null,timeoutFunction:Function=null,method:String="get"):void{
			var request:URLRequest;
			if(method=="get"){
				request = getRequest(url,params);
			}else if(method=="post"){
				request = postRequest(url,params);
			}
			
			var loader:URLLoader = new URLLoader();
			
			var callback:Function = function(e:Event):void{
				loader.removeEventListener(Event.COMPLETE,callback);
				loader.removeEventListener(IOErrorEvent.IO_ERROR,timeout);
				if(completeFunction!=null){
//					trace(loader.data);
					completeFunction(loader.data);
				}
			};
			
			var timeout:Function = function(e:Event):void{
				loader.removeEventListener(Event.COMPLETE,callback);
				loader.removeEventListener(IOErrorEvent.IO_ERROR,timeout);
				if(timeoutFunction != null){
					timeoutFunction(loader.data);
				}
			};
			
			loader.addEventListener(Event.COMPLETE,callback);
			loader.addEventListener(IOErrorEvent.IO_ERROR,timeout);
			loader.load(request);
		}
		
		
		private static function getRequest(url:String,params:Object):URLRequest{
			url += "?"
			var k:String;
			for (k in params){
				url += k+"="+params[k] + "&";
			}
			trace(url.substring(0,url.length-1));
			return new URLRequest(url.substring(0,url.length-1));
		}
		
		private static function postRequest(url:String,params:Object):URLRequest{
			var data:URLVariables = new URLVariables();
			var k:String;
			for (k in params){
				data[k] = params[k];
			}
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = data;
			return request;
		}
	}
}