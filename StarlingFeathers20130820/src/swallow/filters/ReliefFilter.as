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
 * 浮雕滤镜
 * @-式神-
 */
public class ReliefFilter extends FragmentFilter
{

	private var setting:Texture;
    private var mShaderProgram:Program3D;
	
	private var _thresholdX:Number = 5;
	private var _thresholdY:Number = 5;
	private var _r:Number = 1;
	private var _g:Number = 1;
	private var _b:Number = 1;
	private var _a:Number = 1;
	
	/**
	 * 创建一个浮雕滤镜
	 * @param	setting 浮雕的背景
	 * @param	cx 浮雕的偏移阈值X
	 * @param	cy 浮雕的偏移阈值Y
	 */
    public function ReliefFilter(setting:Texture,cx:Number = 5.0, cy:Number = 5.0)
    {
		this.setting = setting;
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
        "mov ft0,v0\n"+
				
		//让XY分别除以一个偏移量达到浮雕效果的厚度
		"sub ft0.x,v0.x,fc1.x\n"+
		"sub ft0.y,v0.y,fc1.y\n"+
		
		//通过原始UV插值取得采样值
		"tex ft1, v0, fs0 <2d,linear,repeat,nomip>\n"+
		
		//通过偏移后的UV插值取得采样值
		"tex ft2, ft0, fs0 <2d,linear,repeat,nomip>\n"+
		
		//获取2个采样值的差异值
		"sub ft3,ft1,ft2\n"+
		
		//对这个差异值做灰度处理
		"mul ft4.x,ft3.x,fc4.y\n"+
		"mul ft4.y,ft3.y,fc4.z\n"+
		"mul ft4.z,ft3.z,fc4.z\n"+
		"mul ft4.w,ft3.w,fc4.w\n"+
		
		
		//获得差异值处理后的灰度值的累加结果到ft5.x中
		"add ft5.x,ft4.x,ft4.y\n"+
		"add ft5.x,ft5.x,ft4.z\n"+
		
		//用灰度值填充ft6
		"mov ft6,ft4\n"+
		"mov ft6.x,ft5.x\n"+
		"mov ft6.y,ft5.x\n"+
		"mov ft6.z,ft5.x\n"+
		
		//让ft6加上fc2的外部传递的值达到变色的效果
		"add ft6,ft6,fc2\n"+
		
		//通过偏转后的UV值获取背景纹理
		"tex ft0, ft0, fs1 <2d,linear,repeat,nomip>\n"+
				
		//融合2个像素
		"mul ft6,ft6,ft0\n"+
				
		//最终颜色乘以一个外部的常量值起到变色的作用
		"mul ft6,ft6,fc3\n"+
		"mov oc, ft6";
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		//控制浮雕的厚度
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([_thresholdX/getNextPowerOfTwo(texture.width), _thresholdY/getNextPowerOfTwo(texture.height), 1, 1]) );
		
		//浮雕的叠加颜色
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([.5, .5, .5, 1]) );
		
		//变色
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([_r, _g, _b, _a]) );
		
		//灰度参数
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([0.3, 0.59, 0.11, 0]) );
		context.setTextureAt(1,setting.base)
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setTextureAt(1,null)
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
	
	public function get r():Number 
	{
		return _r;
	}
	
	public function set r(value:Number):void 
	{
		_r = value;
	}
	
	public function get g():Number 
	{
		return _g;
	}
	
	public function set g(value:Number):void 
	{
		_g = value;
	}
	
	public function get b():Number 
	{
		return _b;
	}
	
	public function set b(value:Number):void 
	{
		_b = value;
	}
	
	public function get a():Number 
	{
		return _a;
	}
	
	public function set a(value:Number):void 
	{
		_a = value;
	}
}
}