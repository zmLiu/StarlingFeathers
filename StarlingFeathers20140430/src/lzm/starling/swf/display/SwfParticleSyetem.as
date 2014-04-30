package lzm.starling.swf.display
{
	import extend.particlesystem.PDParticleSystem;
	
	import lzm.starling.swf.Swf;
	
	import starling.textures.Texture;
	
	public class SwfParticleSyetem extends SwfSprite implements ISwfAnimation
	{
		private var _ownerSwf:Swf;//所属swf
		
		private var _isPlay:Boolean = false;
		
		private var _pdParticle:PDParticleSystem;
		
		public function SwfParticleSyetem(config:XML, texture:Texture,ownerSwf:Swf)
		{
			_ownerSwf = ownerSwf;
			
			_pdParticle = new PDParticleSystem(config, texture);
			addChild(_pdParticle);
			
			start(_pdParticle.duration);
		}
		
		public function update():void{
			if(_isPlay) _pdParticle.advanceTime(_ownerSwf.passedTime);
		}
		
		public function start(duration:Number=Number.MAX_VALUE):void{
			_pdParticle.start(duration);
			
			_isPlay = true;
			_ownerSwf.swfUpdateManager.addSwfAnimation(this);
		}
		
		public function startPD(callBack:Function=null, delayTime:int=100):void{
			_pdParticle.startPD(callBack,delayTime);
			
			_isPlay = true;
			_ownerSwf.swfUpdateManager.addSwfAnimation(this);
		}
		
		public function stop(clearParticles:Boolean=false):void{
			_pdParticle.stop(clearParticles);
			
			_isPlay = false;
			_ownerSwf.swfUpdateManager.removeSwfAnimation(this);
		}
		
		public function setPostion(x:Number,y:Number):void{
			_pdParticle.emitterX = x;
			_pdParticle.emitterY = y;
//			this.x = _pdParticle.pivotX = _pdParticle.emitterX = x;
//			this.y = _pdParticle.pivotY = _pdParticle.emitterY = y;
		}
		
		public override function dispose():void{
			_ownerSwf.swfUpdateManager.removeSwfAnimation(this);
			_ownerSwf = null;
			
			_pdParticle.stop(true);
			_pdParticle.removeFromParent(true);
			
			super.dispose();
		}
		
	}
}