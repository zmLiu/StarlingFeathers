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
	}
}