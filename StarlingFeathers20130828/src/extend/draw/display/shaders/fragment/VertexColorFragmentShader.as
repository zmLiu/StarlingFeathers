package extend.draw.display.shaders.fragment
{
	import flash.display3D.Context3DProgramType;
	
	import extend.draw.display.shaders.AbstractShader;
	
	/*
	* A pixel shader that multiplies the vertex color by the material color transform.
	*/
	public class VertexColorFragmentShader extends AbstractShader
	{
		public function VertexColorFragmentShader()
		{
			var agal:String = "mul oc, v0, fc0";
			compileAGAL( Context3DProgramType.FRAGMENT, agal );
		}
	}
}