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
 * 遮罩滤镜
 * @-式神-
 */
public class MaskFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
    private var mCenterX:Number=0;
    private var mCenterY:Number=0;
	private var shade:Texture;
	private var scaleX:Number = 0;
	private var scaleY:Number = 0;
	
	/**
	 * 创建一个遮罩滤镜,注意使用遮罩贴图时多空余2像素的空白区域用作移动,因为它只是对边缘像素的复制而不是真的移动
	 * @param	shade 遮罩的蒙板纹理
	 * @param	mCenterX 蒙板坐标X(原点0,0为图片的中心点)
	 * @param	mCenterY 蒙板坐标Y
	 */
    public function MaskFilter(shade:Texture,mCenterX:Number=0,mCenterY:Number=0)
    {
		this.shade = shade;
		this.mCenterX = mCenterX;
		this.mCenterY = mCenterY;
    }

    public override function dispose():void
    {
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }

    protected override function createPrograms():void
    {
        var fragmentProgramCode:String =
		"mov ft0,v0\n" +
		 //移动遮罩层
		"add ft0,ft0,fc0.xy\n" +
		//缩放
	    "mul ft0,ft0,fc0.zw\n" +
		//获取原图
		"tex ft1, v0, fs0 <2d,repet,nearest,linear,mipnone>\n"+
		//获取遮罩图采样点
		"tex ft2, ft0, fs1 <2d,repet,nearest,linear,mipnone>\n" +
		//遮罩
		"mul ft2,ft1,ft2.wwww\n" +
		//输出
		"mov oc,ft2";
		
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D,texture:Texture):void
    {
		scaleX = texture.width + texture.height;
		scaleY = shade.width + shade.height;
		
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([ -mCenterX / texture.width, -mCenterY / texture.height, scaleX/scaleY, scaleX / scaleY]) );
		
		context.setTextureAt(1,shade.base)
        context.setProgram(mShaderProgram);
		
		
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		context.setTextureAt(1,null)
    }
	
	/**
	 * 中心点X位置
	 */
    public function set centerX(value:Number):void { mCenterX = value; }
    public function get centerX():Number { return mCenterX; }

	/**
	 * 中心点Y位置
	 */
    public function set centerY(value:Number):void { mCenterY = value; }
    public function get centerY():Number { return mCenterY; }
}
}