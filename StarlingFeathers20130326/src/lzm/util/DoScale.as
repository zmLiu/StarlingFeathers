package lzm.util
{
	

	public class DoScale
	{
		/**
		 * @param img         显示对象
		 * @param oldWidth    原始宽度
		 * @param oldHeight   原始高度
		 * @param toWidth     目标宽度
		 * @param toHeight    目标高度
		 * @return 缩放后scaleX,scaleY
		 */
		public static function doScale(oldWidth:Number, oldHeight:Number, limitWidth:Number, limitHeight:Number):Object {
			var newWidth:Number;
			var newHeight:Number;
			if (oldWidth > 0 && oldHeight > 0) //检查元素高宽能不能正常
			{
				if (oldWidth / oldHeight >= limitWidth / limitHeight) {
					newWidth = limitWidth;
					newHeight = (oldHeight * limitWidth) / oldWidth;
				} else {
					newHeight = limitHeight;
					newWidth = (oldWidth * limitHeight) / oldHeight;
				}
			} else {
				newWidth = 0;
				newHeight = 0;
			}
			var obj:Object = {};
			obj.sx = newWidth/oldWidth;
			obj.sy = newHeight/oldHeight;
			return obj;
		}
		
		/**
		 * @param img         显示对象
		 * @param oldWidth    原始宽度
		 * @param oldHeight   原始高度
		 * @param toWidth     目标宽度
		 * @param toHeight    目标高度
		 * @return 按比例缩放的最大值
		 */
		public static function doMaxScale(oldWidth:Number, oldHeight:Number, limitWidth:Number, limitHeight:Number):Number{
			var sx:Number = limitWidth/oldWidth;
			var sy:Number = limitHeight/oldHeight;
			return sx > sy ? sx : sy;
		}
	}
}