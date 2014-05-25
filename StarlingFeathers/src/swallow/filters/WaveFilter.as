package swallow.filters
{
import flash.display.InterpolationMethod;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import starling.filters.FragmentFilter;
import starling.textures.Texture;
import starling.utils.getNextPowerOfTwo;

/**
 * 波浪滤镜
 * @-式神-
 */
public class WaveFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
	private var _thresholdScope:Number = 0;
	private var _thresholdDensity:Number = 0;
	private var _direction:Number = 0;
	private var _frequency:Number = 0;
	
	
	/**
	 * 创建一个波浪滤镜(可以用于做海浪海底特效)
	 * @param	direction 方向阈值
	 * @param	frequency 频率阈值 
	 * @param	thresholdScope 范围阈值
	 * @param	thresholdDensity 密度阈值
	 */
    public function WaveFilter(direction:Number=250,frequency:Number=10,thresholdScope:Number=20,thresholdDensity:Number=0.005)
    {
      this.direction = direction;
	  this.frequency = frequency;
	  this.thresholdScope = thresholdScope;
	  this.thresholdDensity = thresholdDensity;
    }

    public override function dispose():void
    {
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }

    protected override function createPrograms():void
    {
        var fragmentProgramCode:String =
         //复制插值坐标到零时寄存器ft2中
		"mov ft2,v0\n"+
		
		//复制常量寄存器的值到零时寄存器ft0中,便于之后的计算
		"mov ft0,fc1\n"+

		//先计算X的值 首先计算时间步除以平率值
		"div ft1.x,ft0.x,ft0.y\n"+
		
		//然后用插值坐标乘以速度
		"mul ft1.y,v0.x,ft0.z\n"+
		
		//最后相加以上2个值
		"add ft1.z,ft1.x,ft1.y\n"+
		
		//再根据公式COS
		"cos ft1.w,ft1.z\n"+
		
		//最后乘以一个范围值
		"mul ft1.x,ft1.w,ft0.w\n"+
		
		//然后让当前的UV插值坐标加上这个坐标
		"add ft2.x,ft2.x,ft1.x\n"+
		
		
		//原理同上下面是计算Y坐标的值
		"div ft4.x,ft0.x,ft0.y\n"+
		"mul ft4.y,v0.y,ft0.z\n"+
		"add ft4.z,ft4.x,ft4.y\n"+
		"cos ft4.w,ft4.z\n"+
		"mul ft4.x,ft4.w,ft0.w\n"+
		"add ft2.y,ft2.y,ft4.x\n"+
		
		"mov ft5,ft2\n"+
		
		//最后通过计算后的插值坐标获取像素信息,这个纹理是海底的图片
		"tex ft5, ft5, fs0 <2d,repet,linear,nomip>\n"+
		"mov oc,ft5";
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }
	

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([_direction,_frequency,_thresholdScope,_thresholdDensity]) );
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {

    }
 
	/**
	 * 范围阈值
	 */
	public function get thresholdScope():Number 
	{
		return _thresholdScope;
	}
	
	public function set thresholdScope(value:Number):void 
	{
		_thresholdScope = value;
	}
	
	/**
	 * 密度阈值
	 */
	public function get thresholdDensity():Number 
	{
		return _thresholdDensity;
	}
	
	public function set thresholdDensity(value:Number):void 
	{
		_thresholdDensity = value;
	}
	
	/**
	 * 方向
	 */
	public function get direction():Number 
	{
		return _direction;
	}
	
	public function set direction(value:Number):void 
	{
		_direction = value;
	}
	
	/**
	 * 频率
	 */
	public function get frequency():Number 
	{
		return _frequency;
	}
	
	public function set frequency(value:Number):void 
	{
		_frequency = value;
	}
}
}