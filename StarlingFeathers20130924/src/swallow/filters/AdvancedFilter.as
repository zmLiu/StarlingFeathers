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
 * 色调滤镜
 * @-式神-
 */
public class AdvancedFilter extends FragmentFilter
{

    private var mShaderProgram:Program3D;
	private var maddR:Number = 0;
	private var maddG:Number = 0;
	private var maddB:Number = 0;
	private var maddA:Number = 0;
	
	/**
	 * 创建一个色调滤镜 
	 */
    public function AdvancedFilter(r:Number=0,g:Number=0,b:Number=0,a:Number=0)
    {
       this.maddG = r;
	   this.maddG = r;
	   this.maddB = b;
	   this.maddA = a;
    }

    public override function dispose():void
    {
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }

    protected override function createPrograms():void
    {

        var fragmentProgramCode:String =
		"tex ft0, v0,fs0 <2d,repeat,linear,mipnone>\n" +
		"mul ft1,fc0,ft0.wwww\n" +
		"add ft0,ft0,ft1\n" +
		"mov oc, ft0\n";
	
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }

    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
		Starling.context.setScissorRectangle(null)
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0, Vector.<Number>([maddR,maddG,maddB,maddA]) );
        context.setProgram(mShaderProgram);
    }
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		
    }
 
	/**
		 * 红色增量
		 */
	public function get addR():Number { return maddR };
	public function set addR(value:Number):void { maddR = value };
	
	/**
	 * 绿色增量
	 */
	public function get addG():Number { return maddG };
	public function set addG(value:Number):void { maddG = value };
	
	/**
	 * 蓝色增量
	 */
	public function get addB():Number { return maddB };
	public function set addB(value:Number):void { maddB = value };
	
	/**
	 * 透明度增量
	 */
	public function get addA():Number { return maddA };
	public function set addA(value:Number):void { maddA = value };
}
}