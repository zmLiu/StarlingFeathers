package lzm.starling.display
{
	import flash.geom.Rectangle;
	
	import lzm.starling.STLConstant;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	public class Alert
	{
		
		private static var background:Quad;
		private static var dialogs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public static function show(display:DisplayObject):void{
			STLConstant.currnetAppRoot.addChild(display);
		}
		
		public static function alert(dialog:DisplayObject):void{
			if(dialogs.indexOf(dialog) != -1){
				return;
			}
			
			dialog.addEventListener(Event.ADDED_TO_STAGE,dialogAddToStage);
			
			initBackGround();
			STLConstant.currnetAppRoot.addChild(background);
			STLConstant.currnetAppRoot.addChild(dialog);
			
			var dialogRect:Rectangle = dialog.getBounds(dialog.parent);
			dialog.x = (STLConstant.StageWidth - dialogRect.width)/2;
			dialog.y = (STLConstant.StageHeight - dialogRect.height)/2;
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
					STLConstant.currnetAppRoot.swapChildren(background,dialog);
				} catch(error:Error) {}
			}
		}
		
		private static function initBackGround():void{
			if(background) return;
			background = new Quad(STLConstant.StageWidth,STLConstant.StageHeight,0x000000);
			background.alpha = 0.5;
		}
		
	}
}