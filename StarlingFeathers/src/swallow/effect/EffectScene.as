package swallow.effect 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.errors.MissingContextError;
	import starling.textures.RenderTexture;
	/**
	 * 场景特效
	 * @-式神-
	 */
	public class EffectScene extends Image
	{
		/**
		 * 显示列表
		 */
		private var childList:Vector.<DisplayObject>
		
		private var renderTexture:RenderTexture
		
		private var mMask:Rectangle
		public function EffectScene(width:int, height:int,persistent:Boolean=true, scale:Number=-1) 
		{
			super(init(width,height,persistent,scale));
			childList = new Vector.<DisplayObject>();
		}

		public override function render(support:RenderSupport, alpha:Number):void
        {
			
            if (mMask == null) super.render(support, alpha);
            else
            {
                var context:Context3D = Starling.context;
                if (context == null) throw new MissingContextError();
                
                support.finishQuadBatch();
                context.setScissorRectangle(mMask);

                super.render(support, alpha);
                
                support.finishQuadBatch();
                context.setScissorRectangle(null);
            }
			
			for (var i:int = 0; i < childList.length; i++)
			{
				renderTexture.draw(childList[i]);
			}
			Starling.context.setBlendFactors(Context3DBlendFactor.ZERO, Context3DBlendFactor.ZERO)
        }
		private function init(width:int, height:int,persistent:Boolean=true, scale:Number=-1):RenderTexture
		{
			var img:Quad = new Quad(1, 1);
			renderTexture = new RenderTexture(width, height, persistent, scale)
			renderTexture.draw(img)
			return renderTexture;
		}
		
		
		/**
		 * 添加显示对象
		 * @param	object
		 */
		public function addChild(child:DisplayObject):void
		{
			if (childList.indexOf(child)==-1)
			{
				childList.push(child);
			}
		}
		
		public function removeChild(child:DisplayObject):void
		{
			var index:int=childList.indexOf(child)
			if (index!=-1)
			{
				childList.splice(index,1);
			}
		}
		
		/**
		 * 交换两个指定子对象的 Z 轴顺序（从前到后顺序）。 显示对象容器中所有其它子对象的索引位置保持不变。
		 * @param child1
		 * @param child2
		 */
		public function swapChildren(childA:DisplayObject,childB:DisplayObject,value:int=0):void
		{
			var indexA:int=childList.indexOf(childA);
			var indexB:int=childList.indexOf(childB);
			swapChildrenAt(indexA,indexB);
		}
		
		/**
		 * 在子级列表中两个指定的索引位置，交换子对象的 Z 轴顺序（前后顺序）。 显示对象容器中所有其它子对象的索引位置保持不变。
		 * @param index1
		 * @param index2
		 */
		public function swapChildrenAt(indexA:int,indexB:int,value:int=0):void
		{
			var displayA:DisplayObject = childList[value][indexA];
			var displayB:DisplayObject = childList[value][indexB];
			childList[indexA] = displayB;
			childList[indexB] = displayA;
		}
	
		/**
		 * 返回 DisplayObject2D 的 child 实例的索引位置。
		 * @param child
		 * @return
		 */
		public function getChildIndex(child:DisplayObject,value:int=0):int
		{
			return childList.indexOf(child);
		}
		
		/**
		 * 返回此对象的子项数目
		 * @return
		 */
		public function numChildren(value:int=0):int
		{
			return childList.length;
		}

		/**
		 * 返回索引处的对象
		 * @param	index
		 */
		public function getChildAt(index:int,value:int):DisplayObject
		{
			if (index < childList.length)
			{
				return childList[index];
			}
			return null;
		}
		
		/**
		 * 指定一个遮罩
		 */
		public function get mask():Rectangle { return mMask };
		public function set mask(value:Rectangle):void { mMask = value };
		
	}

}