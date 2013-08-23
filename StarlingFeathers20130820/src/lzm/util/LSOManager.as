package lzm.util
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * 全局ShareObject管理器
	 * location shareobject manager
	 */	
	public final class LSOManager
	{
		/**
		 * 全局ShareObject name
		 */		
		public static var NAME:String = "LSODB";
		/**
		 * 全局ShareObject path
		 */
		public static const PATH:String = "/";
//		
//		public static const PATH_SPLITER:String = "/";
		
		private static var dbObj:Object;
		private static var shareObj:SharedObject;
		private static var pendingObj:Object;
		
		private static function init():void
		{
			if(shareObj==null){
				try{
					shareObj = SharedObject.getLocal(NAME, PATH);
					dbObj = shareObj.data;
				}catch(err:Error){
					dbObj = {};
				};
			}
		}
				
//		private static function find(obj:Object, path:Array):*{
//			obj = obj[path.pop()];
//			if(path.length>0 && path[0].length>0){
//				obj = find(obj, path);
//			}
//			return obj;
//		}
		
		/**
		 * 通过key从全局ShareObject中获取数据
		 * @param key
		 * @return 
		 */		
		public static function get(key:*):*
		{
			return getSO()[key]
		}
		
		/**
		 * 放入数据到全局ShareObject中
		 * @param key
		 * @param value
		 * @return 
		 */		
		public static function put(key:*,value:*):*
		{
			var old:* = getSO()[key];
			getSO()[key] = value;
			saveSO();
			return old;
		}
		
		/**
		 * 判断全局ShareObject中是否含有key
		 * @param key
		 * @return 
		 */		
		public static function has(key:*):Boolean
		{
			return getSO().hasOwnProperty(key);
		}
		
		/**
		 * 从全局ShareObject中删除key以及其对应的数据
		 * @param key
		 * @return 
		 */		
		public static function del(key:*):Boolean
		{
			var db:Object = getSO();
			var b:Boolean = delete db[key];
			if(b){
				saveSO();
			}
			return b;
		}
		
		/**
		 * the lsodb object
		 * @return 
		 */		
		private static function getSO():Object
		{
			init();
			return dbObj;
		}
		
		/**
		 * 强制保存到本地一次<br/>
		 * SharedObject.flush
		 */		
		public static function saveSO() : void
		{
			init();
			var result:String;
			try
			{
				result = shareObj.flush();
				if(result == SharedObjectFlushStatus.PENDING){
					pendingObj = shareObj;
					shareObj.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
				}else if(result == SharedObjectFlushStatus.FLUSHED){
					
				}
			}catch (e:Error){
//				Security.showSettings(SecurityPanel.LOCAL_STORAGE);
				trace("LSOManager.saveSo\n",e.getStackTrace());
			}
		}
		
		private static function onStatus(event:NetStatusEvent) : void
		{
			shareObj.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
			if(event.info.code == "SharedObject.Flush.Success"){
				if(pendingObj != null){
					saveSO();
					pendingObj = null;
				}
			}else if(event.info.code == "SharedObject.Flush.Failed"){
				
			}
		}
		
	}
}