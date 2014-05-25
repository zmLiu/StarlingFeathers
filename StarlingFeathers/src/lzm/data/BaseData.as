package lzm.data
{
	

	public class BaseData
	{
		public function BaseData()
		{
			
		}
		
		public function parse(data:Object):void{
			for(var k:String in data){
				if(this.hasOwnProperty(k)){
					this[k] = data[k];
				}
			}
		}
		
		public function parseFieldValues(fields:Array,values:Array):void{
			var len:int = fields.length;
			var filed:String;
			for (var i:int = 0; i < len; i++) {
				filed = fields[i];
				if(this.hasOwnProperty(filed)){
					this[filed] = values[i];
				}
			}
		}
		
	}
}