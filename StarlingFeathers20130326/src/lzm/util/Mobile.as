package lzm.util {
	
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	/**
	 * This class provides mobile devices information.
	 */
	public class Mobile {
		
		static private var _STAGE:Stage;
		
		static private const _IOS_MARGIN:uint = 40;
		
		static private const _IPHONE_RETINA_WIDTH:uint = 640;
		static private const _IPHONE_RETINA_HEIGHT:uint = 960;
		static private const _IPHONE5_RETINA_HEIGHT:uint = 1136;
		
		static private const _IPAD_WIDTH:uint = 768;
		static private const _IPAD_HEIGHT:uint = 1024;
		static private const _IPAD_RETINA_WIDTH:uint = 1536;
		static private const _IPAD_RETINA_HEIGHT:uint = 2048;
		
		public static function init(stage:Stage):void{
			_STAGE = stage;
		}
		
		public function Mobile() {
			
		}
		
		static public function isIOS():Boolean {
			return (Capabilities.version.substr(0, 3) == "IOS");
		}
		
		static public function isAndroid():Boolean {
			return (Capabilities.version.substr(0, 3) == "AND");
		}
		
		static public function isLandscapeMode():Boolean {
			
			return (_STAGE.fullScreenWidth > _STAGE.fullScreenHeight);
		}
		
		static public function isRetinaIOS():Boolean {
			if (Mobile.isIOS()) {
				
				if (isLandscapeMode())
					return (_STAGE.fullScreenWidth == _IPHONE_RETINA_HEIGHT || _STAGE.fullScreenWidth == _IPHONE5_RETINA_HEIGHT || _STAGE.fullScreenWidth == _IPAD_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPHONE_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPHONE5_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPAD_RETINA_HEIGHT);
				else
					return (_STAGE.fullScreenWidth == _IPHONE_RETINA_WIDTH ||  _STAGE.fullScreenWidth == _IPAD_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPHONE_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPAD_RETINA_WIDTH);
				
			} else 
				return false;
		}
		
		/**
		 * <p>指定舞台的有效像素缩放系数。</p>
		 * <p>此值在标准屏幕上通常为 1，在 HiDPI（又称 Retina）屏幕上通常为 2。</p>
		 * <p>当舞台呈现在 HiDPI 屏幕上时，像素分辨率会增大一倍；</p>
		 * <p>即使舞台缩放模式设置为 StageScaleMode.NO_SCALE 也是如此。Stage.stageWidth 和 Stage.stageHeight 将继续以传统像素单位进行报告。</p>
		 * <p>注意：此值会根据舞台是在 HiDPI 屏幕上还是标准屏幕上而动态变化。</p>
		 */		
		static public function mobileContentsScaleFactor():int{
			return _STAGE.contentsScaleFactor;
		}
		
		static public function isIpad():Boolean {
			
			if (Mobile.isIOS()) {
				
				if (isLandscapeMode())
					return (_STAGE.fullScreenWidth == _IPAD_HEIGHT || _STAGE.fullScreenWidth == _IPAD_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPAD_HEIGHT || _STAGE.fullScreenHeight == _IPAD_RETINA_HEIGHT);
				else
					return (_STAGE.fullScreenWidth == _IPAD_WIDTH || _STAGE.fullScreenWidth == _IPAD_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPAD_WIDTH || _STAGE.fullScreenHeight == _IPAD_RETINA_WIDTH);
				
			} else
				return false;
		}
		
		static public function isIphone5():Boolean {
			
			if (Mobile.isIOS()) {
				if (isLandscapeMode())
					return _STAGE.fullScreenWidth == _IPHONE5_RETINA_HEIGHT;
				else
					return _STAGE.fullScreenHeight == _IPHONE5_RETINA_HEIGHT;
				
			} else
				return false;
		}
		
		static public function get iOS_MARGIN():uint {
			return _IOS_MARGIN;
		}
		
		static public function get iPHONE_RETINA_WIDTH():uint {
			return _IPHONE_RETINA_WIDTH;
		}
		
		static public function get iPHONE_RETINA_HEIGHT():uint {
			return _IPHONE_RETINA_HEIGHT;
		}
		
		static public function get iPHONE5_RETINA_HEIGHT():uint {
			return _IPHONE5_RETINA_HEIGHT;
		}
		
		static public function get iPAD_WIDTH():uint {
			return _IPAD_WIDTH;
		}
		
		static public function get iPAD_HEIGHT():uint {
			return _IPAD_HEIGHT;
		}
		
		static public function get iPAD_RETINA_WIDTH():uint {
			return _IPAD_RETINA_WIDTH;
		}
		
		static public function get iPAD_RETINA_HEIGHT():uint {
			return _IPAD_RETINA_HEIGHT;
		}
	}
}