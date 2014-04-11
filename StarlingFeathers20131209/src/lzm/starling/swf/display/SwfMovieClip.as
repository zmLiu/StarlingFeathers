package lzm.starling.swf.display
{
	import lzm.starling.swf.Swf;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	[Event(name="complete", type="starling.events.Event")]
	
	/**
	 * 
	 * @author zmliu
	 * 
	 */	
	public class SwfMovieClip extends SwfSprite implements ISwfAnimation
	{
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		private var _ownerSwf:Swf;//所属swf
		
		private var _frames:Array;
		private var _labels:Array;
		private var _displayObjects:Object;
		
		private var _startFrame:int;
		private var _endFrame:int;
		private var _currentFrame:int;
		private var _currentLabel:String;
		
		private var _isPlay:Boolean = false;
		private var _loop:Boolean = true;
		
		private var _completeFunction:Function = null;//播放完毕的回调
		private var _hasCompleteListener:Boolean = false;//是否监听过播放完毕的事件
		
		public function SwfMovieClip(frames:Array,labels:Array,displayObjects:Object,ownerSwf:Swf){
			super();
			
			_frames = frames;
			_labels = labels;
			_displayObjects = displayObjects;
			
			_startFrame = 0;
			_endFrame = _frames.length - 1;
			_ownerSwf = ownerSwf;
			
			currentFrame = 0;
			
			play();
		}
		
		public function update():void{
			if (!_isPlay) return;
			
			if(_currentFrame > _endFrame){
				if(_completeFunction) _completeFunction(this);
				if(_hasCompleteListener) dispatchEventWith(Event.COMPLETE);
				
				_currentFrame = _startFrame;
				
				if(!_loop){
					stop(false);
					return;
				}
				
				if(_startFrame == _endFrame){//只有一帧就不要循环下去了
					stop(false);
					return;
				}
				currentFrame = _startFrame;
			}else{
				currentFrame = _currentFrame;
			}
			_currentFrame += 1;
		}
		
		
		private var __frameInfos:Array;
		public function set currentFrame(frame:int):void{
			clearChild();
			
			_currentFrame = frame;
			__frameInfos = _frames[_currentFrame];
			
			var name:String;
			var type:String;
			var data:Array;
			var display:DisplayObject;
			var useIndex:int;
			var length:int = __frameInfos.length;
			for (var i:int = 0; i < length; i++) {
				data = __frameInfos[i];
				useIndex = data[10];
				display = _displayObjects[data[0]][useIndex];
				
				display.mOrientationChanged = true;
				display.mSkewX = data[6] * ANGLE_TO_RADIAN;
				display.mSkewY = data[7] * ANGLE_TO_RADIAN;
				display.alpha = data[8];
				display.mName = data[9];
				
				if(data[1] == Swf.dataKey_Particle){
					display["setPostion"](data[2],data[3]);
				}else{
					display.mX = data[2];
					display.mY = data[3];
				}
				if(data[1] == Swf.dataKey_Scale9){
					display.width = data[11];
					display.height = data[12];
				}else{
					display.mScaleX = data[4];
					display.mScaleY = data[5];
				}
				
				addQuiackChild(display);
				
				if(data[1] == Swf.dataKey_TextField){
					display["width"] = data[11];
					display["height"] = data[12];
					display["fontName"] = data[13];
					display["color"] = data[14];
					display["fontSize"] = data[15];
					display["hAlign"] = data[16];
					display["italic"] = data[17];
					display["bold"] = data[18];
					if(data[19] && data[19] != "\r" && data[19] != ""){
						display["text"] = data[19];
					}
				}
			}
		}
		
		public function get currentFrame():int{
			return _currentFrame;
		}
		
		/**
		 * 播放
		 * */
		public function play():void{
			_isPlay = true;
			
			_ownerSwf.swfUpdateManager.addSwfAnimation(this);
			
			var k:String;
			var arr:Array;
			var l:int;
			for(k in _displayObjects){
				if(k.indexOf(Swf.dataKey_MovieClip) == 0){
					arr = _displayObjects[k];
					l = arr.length;
					for (var i:int = 0; i < l; i++) {
						(arr[i] as SwfMovieClip).play();
					}
				}
			}
		}
		
		/**
		 * 停止
		 * @param	stopChild	是否停止子动画
		 * */
		public function stop(stopChild:Boolean = true):void{
			_isPlay = false;
			_ownerSwf.swfUpdateManager.removeSwfAnimation(this);
			
			if(!stopChild) return;
			
			var k:String;
			var arr:Array;
			var l:int;
			for(k in _displayObjects){
				if(k.indexOf(Swf.dataKey_MovieClip) == 0){
					arr = _displayObjects[k];
					l = arr.length;
					for (var i:int = 0; i < l; i++) {
						(arr[i] as SwfMovieClip).stop(stopChild);
					}
				}
			}
		}
		
		public function gotoAndStop(frame:Object,stopChild:Boolean = true):void{
			goTo(frame);
			stop(stopChild);
		}
		
		public function gotoAndPlay(frame:Object):void{
			goTo(frame);
			play();
		}
		
		private function goTo(frame:*):void{
			if((frame is String)){
				var labelData:Array = getLabelData(frame);
				_currentLabel = labelData[0];
				_currentFrame = _startFrame = labelData[1];
				_endFrame = labelData[2];
			}else if(frame is int){
				_currentFrame = _startFrame = frame;
				_endFrame = _frames.length - 1;
			}
			currentFrame = _currentFrame;
		}
		
		private function getLabelData(label:String):Array{
			var length:int = _labels.length;
			var labelData:Array;
			for (var i:int = 0; i < length; i++) {
				labelData = _labels[i];
				if(labelData[0] == label){
					return labelData;
				}
			}
			return null;
		}
		
		/**
		 * 是否再播放
		 * */
		public function get isPlay():Boolean{
			return _isPlay;
		}
		
		/**
		 * 设置/获取 是否循环播放
		 * */
		public function get loop():Boolean{
			return _loop;
		}
		
		public function set loop(value:Boolean):void{
			_loop = value;
		}
		
		/**
		 * 设置播放完毕的回调
		 */		
		public function set completeFunction(value:Function):void{
			_completeFunction = value;
		}
		
		public function get completeFunction():Function{
			return _completeFunction;
		}
		
		/**
		 * 总共有多少帧
		 * */
		public function get totalFrames():int{
			return _frames.length;
		}
		
		/**
		 * 返回当前播放的是哪一个标签
		 * */
		public function get currentLabel():String{
			return _currentLabel;
		}
		
		/**
		 * 获取所有标签
		 * */
		public function get labels():Array{
			var length:int = _labels.length;
			var returnLabels:Array = [];
			for (var i:int = 0; i < length; i++) {
				returnLabels.push(_labels[i][0]);
			}
			return returnLabels;
		}
		
		public override function set color(value:uint):void{
			_color = value;
			
			var len:int;
			for each (var displayArray:Array in _displayObjects) {
				len = displayArray.length;
				for (var i:int = 0; i < len; i++) {
					setDisplayColor(displayArray[i],_color);
				}
			}
		}
		
		/**
		 * 是否包含某个标签
		 * */
		public function hasLabel(label:String):Boolean{
			var ls:Array = labels;
			return !(ls.indexOf(label) == -1);
		}
		
		public override function addEventListener(type:String, listener:Function):void{
			super.addEventListener(type,listener);
			_hasCompleteListener = hasEventListener(Event.COMPLETE);
		}
		
		public override function removeEventListener(type:String, listener:Function):void{
			super.removeEventListener(type,listener);
			_hasCompleteListener = hasEventListener(Event.COMPLETE);
		}
		
		public override function removeEventListeners(type:String=null):void{
			super.removeEventListeners(type);
			_hasCompleteListener = hasEventListener(Event.COMPLETE);
		}
		
		public override function dispose():void{
			_ownerSwf.swfUpdateManager.removeSwfAnimation(this);
			_ownerSwf = null;
			for each (var array:Array in _displayObjects) {
				var len:int = array.length;
				for (var i:int = 0; i < len; i++) {
					(array[i] as DisplayObject).removeFromParent(true);
				}
			}
			super.dispose();
		}
		
		
		
	}
}