package swallow.filters
{
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import starling.core.Starling;
import starling.filters.FragmentFilter;
import starling.textures.Texture;
import starling.utils.getNextPowerOfTwo;

/**
 * 马赛克滤镜
 * @-式神-
 */
public class MosaicFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
	private var _thresholdX:Number = 5;
	private var _thresholdY:Number = 5;
	
	/**
	 * 创建一个马赛克滤镜 
	 * @param	cx 马赛克范围X
	 * @param	cy 马赛克范围Y
	 */
    public function MosaicFilter(cx:Number = 5.0, cy:Number = 5.0)
    {
       _thresholdX = cx;
	   _thresholdY = cy;
    }

    public override function dispose():void
    {
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }

    protected override function createPrograms():void
    {
        var fragmentProgramCode:String =
          //先获得原始图像
		"tex ft1, v0, fs0 <2d,linear,nomip>\n"+
		
		//用当前插值X坐标除以图像宽度
		"mul ft2.x,v0.x,fc0.x\n"+
		//用当前插值Y坐标除以图像宽度
		"mul ft2.y,v0.y,fc0.y\n"+
		
		//然后用结果除以像素宽度和高度
		"div ft2.z,ft2.x,fc0.z\n"+
		"div ft2.w,ft2.y,fc0.w\n"+
		
		//取整数的办法,先取得数据的小数部分
		"frc,ft5.x,ft2.z\n"+
		"frc,ft5.y,ft2.w\n"+
		//然后减去小数部分获得了整数部分
		"sub ft2.z,ft2.z,ft5.x\n"+
		"sub ft2.w,ft2.w,ft5.y\n"+

		//用ft2的结果乘以像素高度和宽度
		"mul ft3.x,ft2.z,fc0.z\n"+
		"mul ft3.y,ft2.w,fc0.w\n"+
		
		//然后再除以图像的宽度和高度
		"div ft4.x,ft3.x,fc0.x\n"+
		"div ft4.y,ft3.y,fc0.y\n"+
		
		//因为没有用到ZW但不能有空位,所以复制ft1的ZW
		"mov ft4.zw,ft1.zw\n"+
		
		//通过计算好的坐标获得采样点
		"tex ft4,ft4, fs0 <2d,linear,nomip>\n"+
		//输出到像素着色器
		"mov oc, ft4";
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		Starling.context.setScissorRectangle(null)
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([getNextPowerOfTwo(texture.width),getNextPowerOfTwo(texture.height),thresholdX,thresholdY]) );
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		
    }
 
	/**
	 * 设置马赛克Y阈值
	 */
	public function get thresholdY():Number 
	{
		return _thresholdY;
	}
	
	public function set thresholdY(value:Number):void 
	{
		_thresholdY = value;
	}
	
	/**
	 * 设置马赛克X阈值
	 */
	public function get thresholdX():Number 
	{
		return _thresholdX;
	}
	
	public function set thresholdX(value:Number):void 
	{
		_thresholdX = value;
	}
}
}