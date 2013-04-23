package swallow.filters 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import starling.core.Starling;
	import starling.filters.FragmentFilter;
	import starling.textures.Texture;
	/**
	 * 凹凸贴图滤镜
	 * @-式神-
	 */
	public class BumpMakerFilter extends FragmentFilter
	{
		private var mShaderProgram:Program3D
		
		private var normalBitmap:Texture
		private var highlightBitmap:Texture
		private var materialBitmap:Texture
		
		private var mNormalX:Number = 9;
		private var mNormalY:Number = 9;
		private var mLightValue:Number = 1;
		private var mAmbientLightValue:Number = 1;
		
		private var mLightX:Number = .05;
		private var mLightY:Number = .02;
		private var mLightContrast:Number = 0;
		private var mLightIteration:int = 2;
		
		private var mReflectLightX:Number = 10;
		private var mReflectLightY:Number = 1;
		private var mReflectLightValue:Number = .1;
		
		/**
		 * 默认图片诶漫反射贴图
		 * @param	normalBitmap 法线贴图
		 * @param	highlightBitmap 高光贴图
		 * @param	materialBitmap 材质
		 */
		public function BumpMakerFilter(normalBitmap:Texture,highlightBitmap:Texture,materialBitmap:Texture) 
		{
			this.normalBitmap = normalBitmap;
			this.highlightBitmap = highlightBitmap;
			this.materialBitmap = materialBitmap;
		}
		
		public override function dispose():void
		{
			if (mShaderProgram) mShaderProgram.dispose();
			super.dispose();
		}

		protected override function createPrograms():void
		{

			var fragmentProgramCode:String =
			 //通过UV信息创建纹理	
			"tex ft0, v0, fs1 <2d,repet,nearest,nomip>\n"+
			"tex ft1, v0, fs0 <2d,repet,nearest,nomip>\n"+
			"tex ft2, v0, fs2 <2d,repet,nearest,nomip>\n"+
			"tex ft4, v0, fs3 <2d,repet,nearest,nomip>\n"+

			//贴材质
			"mul ft1,ft1,ft4\n"+
			
			//计算法线,高光,朝向
			"dp3 ft3.x,ft0,fc1\n"+
			"mul ft3.x,ft3.x,ft2.x\n"+
			"mul ft5,ft1,ft3.x\n"+
			"mul ft3.y,ft2.x,fc1.w\n"+
			"add ft5,ft5,ft3.y\n"+
			"dp3 ft6,ft0,fc1\n"+
			"mul ft6,ft6,fc2.w\n"+
			"mul ft6,ft6,ft0\n"+
			"sub ft6,ft6.xyz,fc1.xyz\n"+
			"dp3 ft6,ft6,fc2\n"+
			"pow ft6,ft6,fc3.x\n"+
			"mul ft6,ft6,fc3.y\n"+
			"mul ft6,ft6,fc3.z\n"+
			//融合最终颜色
			"add ft1,ft5,ft6\n"+
			"mov oc, ft1\n"
		
			mShaderProgram = assembleAgal(fragmentProgramCode);
		}

		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			context.setScissorRectangle(null)
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([mNormalX,mNormalY,mLightValue,mAmbientLightValue]) );
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([mLightX,mLightY,mLightContrast,mLightIteration]) );
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([mReflectLightX,mReflectLightY,mReflectLightValue,1]) );
			context.setTextureAt(1, normalBitmap.base);
			context.setTextureAt(2, highlightBitmap.base);
			context.setTextureAt(3, materialBitmap.base);
			context.setProgram(mShaderProgram);
		}
		override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
		{
			context.setTextureAt(1, null);
			context.setTextureAt(2, null);
			context.setTextureAt(3, null);
		}
		
		/**
		 * 法线X方向
		 */
		public function get normalX():Number { return mNormalX };
		public function set normalX(value:Number):void { mNormalX = value };
		
		/**
		 * 法线Y方向
		 */
		public function get normalY():Number { return mNormalY };
		public function set normalY(value:Number):void { mNormalY = value };
		
		/**
		 * 高光大小
		 */
		public function get lightValue():Number { return mLightValue };
		public function set lightValue(value:Number):void { mLightValue = value };
		
		/**
		 * 环境光亮度
		 */
		public function get ambientLightValue():Number { return mAmbientLightValue };
		public function set ambientLightValue(value:Number):void { mAmbientLightValue = value };
		
		/**
		 * 高光X方向
		 */
		public function get lightX():Number { return mLightX };
		public function set lightX(value:Number):void { mLightX = value };
		
		/**
		 * 高光Y方向
		 */
		public function get lightY():Number { return mLightY };
		public function set lightY(value:Number):void { mLightY = value };
		
		/**
		 * 高光对比度
		 */
		public function get lightContrast():Number { return mLightContrast };
		public function set lightContrast(value:Number):void { mLightContrast = value };
		
		/**
		 * 高光迭代次数
		 */
		public function get lightIteration():int { return mLightIteration };
		public function set lightIteration(value:int):void { mLightIteration = value };
		
		/**
		 * X反光强度
		 */
		public function get reflectLightX():Number { return mReflectLightX };
		public function set reflectLightX(value:Number):void { mReflectLightX = value };
		
		/**
		 * Y反光强度
		 */
		public function get reflectLightY():Number { return mReflectLightY };
		public function set reflectLightY(value:Number):void { mReflectLightY = value };
		
		/**
		 * 反光大小
		 */
		public function get reflectLightValue():Number { return mReflectLightValue };
		public function set reflectLightValue(value:Number):void { mReflectLightValue = value };
		
	}

}