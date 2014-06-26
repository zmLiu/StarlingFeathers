package lzm.starling.swf.filter
{
	import flash.utils.getDefinitionByName;
	
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilter;
	import starling.filters.FragmentFilterMode;
	

	/**
	 * 滤镜管理类 
	 * @author zmliu
	 * 
	 */	
	public class SwfFilter
	{
		
		public static const filters:Array = [
			"flash.filters::GlowFilter",
			"flash.filters::DropShadowFilter",
			"flash.filters::BlurFilter"
		];
		
		/** 创建滤镜 */
		public static function createFilter(filterObjects:Object):FragmentFilter{
			var filterName:String;
			var filterData:Object;
			var filter:FragmentFilter;
			for(filterName in filterObjects){
				filterData = filterObjects[filterName];
				
				switch(filterName){
					case filters[0]://描边
						var glow:BlurFilter = new BlurFilter(filterData.blurX / 10, filterData.blurY / 10);
						glow.mode = FragmentFilterMode.BELOW;
						glow.setUniformColor(true, filterData.color, filterData.alpha);
						filter = glow;
						break;
					case filters[1]://阴影
						var dropShadow:BlurFilter = new BlurFilter(filterData.blurX / 10, filterData.blurY / 10);
						dropShadow.offsetX = Math.cos(filterData.angle) * filterData.distance;
						dropShadow.offsetY = Math.sin(filterData.angle) * filterData.distance;
						dropShadow.mode = FragmentFilterMode.BELOW;
						dropShadow.setUniformColor(true, filterData.color, filterData.alpha);
						filter = dropShadow;
						break;
					case filters[2]://模糊
						var blur:BlurFilter = new BlurFilter(filterData.blurX / 10, filterData.blurY / 10);
						filter = blur;
						break;
				}
				
			}
			return filter;
		}
		
		/** 创建文本的滤镜 */
		public static function createTextFieldFilter(filterObjects:Object):Array{
			var filters:Array = [];
			var filter:Object;
			var filterName:String;
			var filterClazz:Class;
			for(filterName in filterObjects){
				filterClazz = getDefinitionByName(filterName) as Class;
				filter = new filterClazz();
				
				setPropertys(filter,filterObjects[filterName]);
				filters.push(filter);
			}
			return filters.length > 0 ? filters : null;
		}
		
		private static function setPropertys(filter:Object,propertys:Object):void{
			for(var key:String in propertys){
				if(filter.hasOwnProperty(key)) filter[key] = propertys[key];
			}
		}
		
	}
}