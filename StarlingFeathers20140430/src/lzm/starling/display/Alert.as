package lzm.starling.display
{
	import flash.geom.Rectangle;
	
	import lzm.starling.STLConstant;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;

	public class Alert
	{
		
		private static var background:Quad;
		private static var dialogs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private static var root:DisplayObjectContainer;
		private static var stageWidth:Number = NaN;
		private static var stageHeight:Number = NaN;
		
		public static function init(root:DisplayObjectContainer,stageWidth:Number,stageHeight:Number):void{
			Alert.root = root;
			Alert.stageWidth = stageWidth;
			Alert.stageHeight = stageHeight;
		}
		
		private static function get container():DisplayObjectContainer{
			return Alert.root == null ? STLConstant.currnetAppRoot : Alert.root;
		}
		
		private static function get width():Number{
			return isNaN(Alert.stageWidth) ? STLConstant.StageWidth : Alert.stageWidth;
		}
		
		private static function get height():Number{
			return isNaN(Alert.stageHeight) ? STLConstant.StageHeight : Alert.stageHeight;
		}
		
		public static function show(display:DisplayObject):void{
			container.addChild(display);
		}
		
		public static function alert(dialog:DisplayObject,setXY:Boolean = true):void{
			if(dialogs.indexOf(dialog) != -1){
				return;
			}
			
			dialog.addEventListener(Event.ADDED_TO_STAGE,dialogAddToStage);
			
			initBackGround();
			container.addChild(background);
			container.addChild(dialog);
			
			if(setXY){
				var dialogRect:Rectangle = dialog.getBounds(dialog.parent);
				dialog.x = (width - dialogRect.width)/2;
				dialog.y = (height - dialogRect.height)/2;
			}
		}
		
		private static function dialogAddToStage(e:Event):void{
			var dialog:DisplayObject = e.currentTarget as DisplayObject;
			dialog.removeEventListener(Event.ADDED_TO_STAGE,dialogAddToStage);
			dialog.addEventListener(Event.REMOVED_FROM_STAGE,dialogRemoveFromStage);
			
			dialogs.push(dialog);
		}
		
		private static function dialogRemoveFromStage(e:Event):void{
			var dialog:DisplayObject = e.currentTarget as DisplayObject;
			dialog.removeEventListener(Event.REMOVED_FROM_STAGE,dialogRemoveFromStage);
			
			dialogs.pop();
			
			if(dialogs.length == 0){
				background.removeFromParent();
			}else{
				dialog = dialogs[dialogs.length-1];
				try{
					container.swapChildren(background,dialog);
				} catch(error:Error) {}
			}
		}
		
		private static function initBackGround():void{
			if(background) return;
			background = new Quad(width,height,0x000000);
			background.alpha = 0.5;
		}
		
	}
}