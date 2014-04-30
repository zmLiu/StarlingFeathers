package lzm.starling
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import lzm.util.Mobile;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class STLStarup extends Sprite
	{
		
		protected var _mStarling:Starling;
		
		public function STLStarup()
		{
			
		}
		
		/**
		 * 根据宽高来创建starling 
		 * @param mainClass
		 * @param width		starling舞台宽
		 * @param height	starling舞台高
		 * @param HDWidth	高清 普通屏幕的分界线
		 * @param debug		是否显示fps状态
		 * @param isPc		是否是再web上运行
		 * @param pullUp	是否拉伸(不拉伸就留黑边)
		 * 
		 */		
		protected function initStarlingWithWH(mainClass:Class,width:int,height:int,HDWidth:int=480,debug:Boolean=false,isPc:Boolean=false,pullUp:Boolean=false,stage3DProfile:String="auto"):void{
			STLConstant.nativeStage = stage;
			STLConstant.StageWidth = width;
			STLConstant.StageHeight = height;
			
			Starling.handleLostContext = !Mobile.isIOS();
			
			var stageFullScreenWidth:Number = isPc ? stage.stageWidth : stage.fullScreenWidth;
			var stageFullScreenHeight:Number = isPc ? stage.stageHeight : stage.fullScreenHeight;
			
			var viewPort:Rectangle;
			if(pullUp){
				viewPort = new Rectangle(0,0,stageFullScreenWidth,stageFullScreenHeight);
			}else{
				viewPort = RectangleUtil.fit(
					new Rectangle(0, 0, width, height), 
					new Rectangle(0, 0,stageFullScreenWidth,stageFullScreenHeight), 
					ScaleMode.SHOW_ALL);
			}
			
			STLConstant.scale = viewPort.width > HDWidth ? 2 : 1;//Capabilities.screenDPI > 200 ? 2 : 1;
			
			_mStarling = new Starling(STLRootClass, stage, viewPort,null,"auto",stage3DProfile);
			_mStarling.antiAliasing = 0;
			_mStarling.stage.stageWidth  = width;
			_mStarling.stage.stageHeight = height;
			_mStarling.enableErrorChecking = Capabilities.isDebugger;
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:STLRootClass):void
				{
					STLConstant.currnetAppRoot = app;
					
					_mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					_mStarling.start();
					if(debug) _mStarling.showStatsAt(HAlign.RIGHT);
					
					app.start(mainClass);
				});
			
			trace("handleLostContext:"+Starling.handleLostContext);
			trace("Scale:" + STLConstant.scale);
			trace("StageWidth:"+STLConstant.StageWidth);
			trace("StageHeight:"+STLConstant.StageHeight);
		}
		
		/**
		 * 创建一个满屏的starling但是需要自己动态管理布局 
		 * @param mainClass
		 * @param HDWidth	高清 普通屏幕的分界线
		 * @param debug		是否显示fps状态
		 * @param isPc		是否是再web上运行
		 * 
		 */		
		protected function initStarling(mainClass:Class,HDWidth:int=480,debug:Boolean=false,isPc:Boolean=false,stage3DProfile:String="auto"):void{
			STLConstant.nativeStage = stage;
			
			Starling.handleLostContext = !Mobile.isIOS();
			
			var viewPort:Rectangle = new Rectangle(0,0,
				isPc ? stage.stageWidth : stage.fullScreenWidth, 
				isPc ? stage.stageHeight : stage.fullScreenHeight
			);
			STLConstant.scale = viewPort.width > HDWidth ? 2 : 1;//Capabilities.screenDPI > 200 ? 2 : 1;
			STLConstant.StageWidth = viewPort.width * (1/STLConstant.scale);
			STLConstant.StageHeight = viewPort.height * (1/STLConstant.scale);
			
			_mStarling = new Starling(STLRootClass, stage, viewPort,null,"auto",stage3DProfile);
			_mStarling.antiAliasing = 0;
			_mStarling.stage.stageWidth  = STLConstant.StageWidth;
			_mStarling.stage.stageHeight = STLConstant.StageHeight;
			_mStarling.enableErrorChecking = Capabilities.isDebugger;
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:STLRootClass):void
				{
					STLConstant.currnetAppRoot = app;
					
					_mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					_mStarling.start();
					if(debug) _mStarling.showStatsAt(HAlign.RIGHT);
					
					app.start(mainClass);
				});
			trace("handleLostContext:"+Starling.handleLostContext);
			trace("Scale:" + STLConstant.scale);
			trace("StageWidth:"+STLConstant.StageWidth);
			trace("StageHeight:"+STLConstant.StageHeight);
		}
		
	}
}