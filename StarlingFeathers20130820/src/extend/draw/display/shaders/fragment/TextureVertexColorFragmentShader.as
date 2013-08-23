package extend.draw.display.shaders.fragment
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	
	import extend.draw.display.shaders.AbstractShader;
	
	/*
	* A pixel shader that multiplies a single texture with constants (the color transform) and vertex color
	*/
	public class TextureVertexColorFragmentShader extends AbstractShader
	{
		public function TextureVertexColorFragmentShader()
		{
			var agal:String =
			"tex ft1, v1, fs0 <2d, repeat, linear> \n" +
			"mul ft2, v0, fc0 \n" +
			"mul oc, ft1, ft2"
			
			compileAGAL( Context3DProgramType.FRAGMENT, agal );
		}
	}
}