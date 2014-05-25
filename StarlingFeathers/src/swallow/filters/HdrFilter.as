package swallow.filters
{
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import starling.filters.FragmentFilter;
import starling.textures.Texture;
import starling.utils.getNextPowerOfTwo;

/**
 * HDR滤镜
 * @-式神-
 */
public class HdrFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
	private var _threshold:Number =0
	private var _luminance:Number = 0
	private var _saturation:Number =0
	private var _contrast:Number = 0
	private var _tone:Number = 0;
	private var _scope:Number = 0;
		
    public function HdrFilter(threshold:Number=1.6,luminance:Number=0.3,saturation:Number=0.59,contrast:Number=0.11,tone:Number=1,scope:Number=4)
    {
      this.threshold = threshold;
	  this.luminance = luminance;
	  this.saturation = saturation;
	  this.contrast = contrast;
	  this.tone = tone;
	  this.scope = scope;
    }

    public override function dispose():void
    {
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }

    protected override function createPrograms():void
    {
        var fragmentProgramCode:String =
        "tex ft1, v0, fs0 <2d,repeat,linear,mipnone>\n"+
		"mul ft2.x,ft1.x,fc1.x\n"+
		"mul ft2.y,ft1.y,fc1.y\n"+
		"mul ft2.z,ft1.z,fc1.z\n"+
		"add ft2.w,ft2.x,ft2.y\n"+
		"add ft2.w,ft2.w,ft2.z\n"+
		"mov ft6,fc2\n"+
		"mul ft4.x,ft6.x,ft6.y\n"+
		"sub ft4.x,ft4.x,ft6.z\n"+
		"sub ft4.y,ft6.w,ft4.x\n"+
		"mul ft4.z,ft4.y,ft2.w\n"+
		"add ft4.z,ft4.z,ft4.x\n"+
		"mul ft4.z,ft4.z,ft2.w\n"+
		"mul ft1,ft1,ft4.zzzz\n"+
		"mov oc, ft1";
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([_luminance,_saturation,_contrast,1]) );
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([scope,_threshold,tone,1]) );
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setBlendFactors(Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
    }
 
	/**
	 * 亮度
	 */
	public function get luminance():Number 
	{
		return _luminance;
	}
	
	public function set luminance(value:Number):void 
	{
		_luminance = value;
	}
	
	
	/**
	 * 饱和度
	 */
	public function get saturation():Number 
	{
		return _saturation;
	}
	
	public function set saturation(value:Number):void 
	{
		_saturation = value;
	}
	
	/**
	 * 对比度
	 */
	public function get contrast():Number 
	{
		return _contrast;
	}
	
	public function set contrast(value:Number):void 
	{
		_contrast = value;
	}
	
	/**
	 * 色调
	 */
	public function get tone():Number 
	{
		return _tone;
	}
	
	public function set tone(value:Number):void 
	{
		_tone = value;
	}
	
	/**
	 * 范围阈值
	 */
	public function get threshold():Number 
	{
		return _threshold;
	}
	
	public function set threshold(value:Number):void 
	{
		_threshold = value;
	}
	
	/**
	 * 柔化范围
	 */
	public function get scope():Number 
	{
		return _scope;
	}
	
	public function set scope(value:Number):void 
	{
		_scope = value;
	}
}
}