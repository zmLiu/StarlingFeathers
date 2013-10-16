package swallow.filters
{
import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Program3D;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.FragmentFilter;
import starling.textures.Texture;

/**
 * 
 * 截图类,因为截取屏幕需要插入到starling的绘制循序中去,这样就必须改动底层的一些代码,我这个是一个取巧的方法,利用滤镜deactivate方法深入到他的绘制流程中去截图.
 * 使用方法:
   var screenshot:Screenshot = new Screenshot(游戏场景,width,height,bitmapdata,function(value:BitmapData):void{
   //value是当前截图的数据,回调会一直执行,你可以通过自己判断选择截图几次
   });
   
   //删除
   screenshot.dispose();
 * @-式神-
 */
public class Screenshot extends FragmentFilter
{
    private var mShaderProgram:Program3D;
    private var canvas:BitmapData;
	private var canvasQuad:Quad
	private var canvasW:Number
	private var canvasH:Number
	private var callBack:Function
	private var scene:Sprite
    public function Screenshot(scene:Sprite,w:Number=100,h:Number=100,callBack:Function=null)
    {
		this.canvasW = w;
		this.canvasH = h;
		this.callBack = callBack;
		this.scene = scene;
		canvasQuad = new Quad(1,1);
		canvasQuad.filter = this;
		scene.addChild(canvasQuad);
    }
    public override function dispose():void
    {
		canvasQuad.filter = null;
		scene.removeChild(canvasQuad);
        if (mShaderProgram) mShaderProgram.dispose();
        super.dispose();
    }
	
    protected override function createPrograms():void
    {
        var fragmentProgramCode:String =
        "tex ft0, v0, fs0 <2d,repeat,linear,mipnone>\n"+
	    "mov oc, ft0"	
        mShaderProgram = assembleAgal(fragmentProgramCode);
    }
	
    protected override function activate(pass:int, context:Context3D, texture:Texture):void
    {
        context.setProgram(mShaderProgram);
    }
	
    override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
    {
		if (canvas == null)
		canvas = new BitmapData(canvasW,canvasH, true, 0xffffffff);
		Starling.context.drawToBitmapData(canvas);
		if(callBack!=null)
		callBack(canvas);
    }
}
}