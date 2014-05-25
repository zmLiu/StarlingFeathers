package lzm.util
{
	import extend.particlesystem.PDParticleSystem;
	
	import starling.textures.Texture;

	public class ParticlePool
	{
		
		private static var _pool:Object = new Object();
		
		/**
		 * 获取一个粒子效果
		 * */
		public static function getParticle(name:String,xml:XML,texture:Texture):PDParticleSystem{
			var particleArray:Vector.<PDParticleSystem> = _pool[name];
			if(particleArray == null || particleArray.length == 0){
				var particle:PDParticleSystem = new PDParticleSystem(xml,texture);
				particle.name = name;
				return particle;
			}
			return particleArray.shift();
		}
		
		/**
		 * 归还一个粒子效果
		 * */
		public static function returnParticle(particle:PDParticleSystem):void{
			particle.stop(true);
			particle.removeFromParent();
			
			var particleArray:Vector.<PDParticleSystem> = _pool[particle.name];
			if(particleArray == null){
				particleArray = new Vector.<PDParticleSystem>();
			}
			particleArray.push(particle);
			_pool[particle.name] = particleArray;
		}
	}
}