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
 * 反向灯光滤镜
 * @-式神-
 */
public class ShadowFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
    private var mCenterX:Number=0;
    private var mCenterY:Number=0;
    private var mRadius:Number;
	
	private var _r:Number = 1;
	private var _g:Number = 1;
	private var _b:Number = 1;
	private var _a:Number = 1;
	private var mScopeX:Number=2;
	private var mScopeY:Number=2;

	/**
	 * 创建一个灯光滤镜
	 * @param	radius 灯光范围
	 * @param	cx 灯光坐标(原点0,0为图片中心点)
	 * @param	cy 灯光坐标
	 */
    public function ShadowFilter(cx:Number =0, cy:Number = 0)
    {
		this.mCenterX = cx;
		this.mCenterY = cy;
       
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
		"mov ft4,v0\n"+
		"sub ft4,v0,fc1\n"+
		"abs ft4,ft4\n"+
		"mul ft4.x,ft4.x,fc1.z\n"+
		"mul ft4.y,ft4.y,fc1.w\n"+
		"mul ft4,ft4,ft4\n"+
		"add ft4.z,ft4.x,ft4.y\n"+
		"sqt ft4.w,ft4.z\n"+
		"mul ft4.w,ft4.w,fc1.z\n" +
		"mul ft5,ft1,ft4.wwww\n"+
		"mul ft5,ft5,fc2\n"+
	    "mov oc, ft5"	
	
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([
		mCenterX/getNextPowerOfTwo(texture.width),
		mCenterY/getNextPowerOfTwo(texture.height),
		mScopeX,mScopeY]));
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([r,g,b,a]));
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {

    }
	
	/**
	 * 灯光X坐标
	 */
    public function set centerX(value:Number):void { mCenterX = value; }
    public function get centerX():Number { return mCenterX; }

	/**
	 * 灯光Y坐标
	 */
    public function set centerY(value:Number):void { mCenterY = value; }
    public function get centerY():Number { return mCenterY; }

	
	/**
	 * 灯光R值
	 */
	public function get r():Number {return _r;}
	public function set r(value:Number):void {_r = value;}
	
	/**
	 * 灯光G值
	 */
	public function get g():Number {return _g;}
	public function set g(value:Number):void {_g = value;}
	
	/**
	 * 灯光B值
	 */
	public function get b():Number {return _b;}
	public function set b(value:Number):void {_b = value;}
	
	/**
	 * 灯光A值
	 */
	public function get a():Number {return _a;}
	public function set a(value:Number):void {_a = value;}
	
	/**
	 * 灯光X轴范围
	 */
	public function get scopeX():Number {return mScopeX;}
	public function set scopeX(value:Number):void {mScopeX = value;}
	
	/**
	 * 灯光Y轴范围
	 */
	public function get scopeY():Number {return mScopeY;}
	public function set scopeY(value:Number):void {mScopeY = value;}
}
}