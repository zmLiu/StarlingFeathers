package extend
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	
	/**
	 * 冷却效果图
	 * @author abo
	 */
	public class CoolDownImage extends DisplayObject 
	{
		private static var PROGRAM_NAME:String = "CoolDown";
		
		// custom members
		private var mProgress:Number = 0;
		private var mTexture:Texture;
		private var mWidth:Number;
		private var mHeight:Number;
		private var radiansW2H:Number;
        
        // vertex data 
        private var mVertexData:VertexData;
        private var mVertexBuffer:VertexBuffer3D;
        
        // index data
        private var mIndexData:Vector.<uint>;
        private var mIndexBuffer:IndexBuffer3D;
		
        // helper objects (to avoid temporary objects)
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
		
		public function CoolDownImage(texture:Texture, progress:Number = 0) 
		{
			mTexture = texture;
			
			var frame:Rectangle = texture.frame;
			mWidth = frame ? frame.width : texture.width;
			mHeight = frame ? frame.height : texture.height;
			radiansW2H = Math.atan2(mWidth, mHeight);
			
			// setup vertex data and prepare shaders
            setupVertices();
            this.progress = progress;
            registerPrograms();
            
            // handle lost context
            Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
        /** Disposes all resources of the display object. */
        public override function dispose():void
        {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
            
            if (mVertexBuffer) mVertexBuffer.dispose();
            if (mIndexBuffer)  mIndexBuffer.dispose();
            
            super.dispose();
        }
        
        private function onContextCreated(event:Event):void
        {
            // the old context was lost, so we create new buffers and shaders.
            createBuffers();
            registerPrograms();
        }
        
        /** Returns a rectangle that completely encloses the object as it appears in another 
         * coordinate system. */
        public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle
        {
            if (resultRect == null) resultRect = new Rectangle();
            
            var transformationMatrix:Matrix = targetSpace == this ? 
                null : getTransformationMatrix(targetSpace, sHelperMatrix);
            
            return mVertexData.getBounds(transformationMatrix, 0, -1, resultRect);
        }
		
        /** Creates the required vertex- and index data and uploads it to the GPU. */ 
        private function setupVertices():void
        {
            var i:int;
            
            // create vertices
			mVertexData = new VertexData(7);
			mVertexData.setUniformColor(0xFF0000);
			
			mVertexData.setPosition(0, mWidth * 0.5, mHeight * 0.5);
			mVertexData.setPosition(1, mWidth * 0.5, 0);
			mVertexData.setPosition(2, 0.0, 0.0);
			mVertexData.setPosition(3, 0.0, 0.0);
			mVertexData.setPosition(4, 0.0, 0.0);
			mVertexData.setPosition(5, 0.0, 0.0);
			mVertexData.setPosition(6, 0.0, 0.0);
			
			//For every vertex you add you must set the UV (texture coords) for that vertex.
			//UV goes from 0 to 1. So if the x position of the vertex is at the middle of the texture the U would be 0.5.
			//(U, V) = (0, 0) means the bottom-left corner of the texture image, and (U, V) = (1, 1) means the top-right corner.
			mVertexData.setTexCoords(0, 0.5, 0.5);
			mVertexData.setTexCoords(1, 0.5, 0);
			mVertexData.setTexCoords(2, 0, 0);
			mVertexData.setTexCoords(3, 0, 1);
			mVertexData.setTexCoords(4, 1, 1);
			mVertexData.setTexCoords(5, 1, 0);
			mVertexData.setTexCoords(6, 0.5, 0);
			
			mIndexData = new <uint>[];
			mIndexData.push(0, 1, 2);
			mIndexData.push(0, 2, 3);
			mIndexData.push(0, 3, 4);
			mIndexData.push(0, 4, 5);
			mIndexData.push(0, 5, 6);
		}
		
		/** Creates new vertex- and index-buffers and uploads our vertex- and index-data to those
         *  buffers. */ 
        private function createBuffers():void
        {
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            if (mVertexBuffer) mVertexBuffer.dispose();
            if (mIndexBuffer)  mIndexBuffer.dispose();
            
            mVertexBuffer = context.createVertexBuffer(mVertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
            
            mIndexBuffer = context.createIndexBuffer(mIndexData.length);
            mIndexBuffer.uploadFromVector(mIndexData, 0, mIndexData.length);
        }
        
        /** Renders the object with the help of a 'support' object and with the accumulated alpha
         * of its parent object. */
        public override function render(support:RenderSupport, alpha:Number):void
        {
            // always call this method when you write custom rendering code!
            // it causes all previously batched quads/images to render.
            support.finishQuadBatch();
            
            // make this call to keep the statistics display in sync.
            support.raiseDrawCount();
            
			alpha *= this.alpha;
            sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = mTexture.premultipliedAlpha ? alpha : 1.0;
            sRenderAlpha[3] = alpha;
            
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            // apply the current blendmode
            support.applyBlendMode(false);
			
			context.setTextureAt(0, mTexture.base);
            
            // activate program (shader) and set the required buffers / constants 
            context.setProgram(Starling.current.getProgram(PROGRAM_NAME));
            context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
            context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
			context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);            
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
            
            // finally: draw the object!
            context.drawTriangles(mIndexBuffer, 0, 5);
            
            // reset buffers
			context.setTextureAt(0, null);
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
        }
		
        /** Creates vertex and fragment programs from assembly. */
        private static function registerPrograms():void
        {
            var target:Starling = Starling.current;
            if (target.hasProgram(PROGRAM_NAME)) return; // already registered
            
            // va0 -> position
            // va1 -> color
            // vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
            // vc4 -> alpha
            
            var vertexProgramCode:String =
                "m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
                "mul v0, va1, vc4 \n" + // multiply color with alpha and pass it to fragment shader
				"mov v6, va2 \n"; //insert uv and send to fragment shader
            
            var fragmentProgramCode:String =
				"tex ft0, v6, fs0 <2d,linear,nomip> \n" +
				"mov oc, ft0 \n";
            
            var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
            
            var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
            
            target.registerProgram(PROGRAM_NAME, vertexProgramAssembler.agalcode,
                fragmentProgramAssembler.agalcode);
        }
		
		public function get progress():Number
		{
			return mProgress;
		}
		
		public function set progress(value:Number):void
		{
			if (value > 1) mProgress = 1;
			else if (value < 0) mProgress = 0;
			else mProgress = value;
			
			var radians:Number = Math.PI * 2 * mProgress;
			var halfWidth:Number = mWidth * 0.5;
			var halfHeight:Number = mHeight * 0.5;
			var pX:Number;
			var pY:Number;
			
			if (radians < radiansW2H)
			{
				pX = halfWidth + halfHeight * Math.tan(radians);
				mVertexData.setPosition(6, pX, 0);
				
				mVertexData.setPosition(2, 0, 0);
				mVertexData.setPosition(3, 0, mHeight);
				mVertexData.setPosition(4, mWidth, mHeight);
				mVertexData.setPosition(5, mWidth, 0);
				
				mVertexData.setTexCoords(6, pX / mWidth, 0);
				mVertexData.setTexCoords(2, 0, 0);
				mVertexData.setTexCoords(3, 0, 1);
				mVertexData.setTexCoords(4, 1, 1);
				mVertexData.setTexCoords(5, 1, 0);
			}
			else if (radians < Math.PI - radiansW2H)
			{
				mVertexData.setPosition(6, halfWidth, halfHeight);
				
				pY = halfWidth - halfWidth / Math.tan(radians);
				mVertexData.setPosition(5, mWidth, pY);
				
				mVertexData.setPosition(2, 0, 0);
				mVertexData.setPosition(3, 0, mHeight);
				mVertexData.setPosition(4, mWidth, mHeight);
				
				mVertexData.setTexCoords(5, 1, pY / mHeight);
				mVertexData.setTexCoords(2, 0, 0);
				mVertexData.setTexCoords(3, 0, 1);
				mVertexData.setTexCoords(4, 1, 1);
			}
			else if (radians < Math.PI + radiansW2H)
			{
				mVertexData.setPosition(6, halfWidth, halfHeight);
				mVertexData.setPosition(5, halfWidth, halfHeight);
				
				pX = halfWidth + halfHeight * Math.tan(Math.PI - radians);
				mVertexData.setPosition(4, pX, mHeight);
				
				mVertexData.setPosition(2, 0, 0);
				mVertexData.setPosition(3, 0, mHeight);
				
				mVertexData.setTexCoords(4, pX / mWidth, 1);
				mVertexData.setTexCoords(2, 0, 0);
				mVertexData.setTexCoords(3, 0, 1);
			}
			else if (radians < 2 * Math.PI - radiansW2H)
			{
				mVertexData.setPosition(6, halfWidth, halfHeight);
				mVertexData.setPosition(5, halfWidth, halfHeight);
				mVertexData.setPosition(4, halfWidth, halfHeight);
				
				pY = halfHeight + halfWidth / Math.tan(radians - Math.PI);
				mVertexData.setPosition(3, 0, pY);
				
				mVertexData.setPosition(2, 0, 0);
				
				mVertexData.setTexCoords(3, 0, pY / mHeight);
				mVertexData.setTexCoords(2, 0, 0);
			}
			else
			{
				mVertexData.setPosition(6, halfWidth, halfHeight);
				mVertexData.setPosition(5, halfWidth, halfHeight);
				mVertexData.setPosition(4, halfWidth, halfHeight);
				mVertexData.setPosition(3, halfWidth, halfHeight);
				
				pX = halfWidth - halfHeight * Math.tan(2 * Math.PI - radians);
				mVertexData.setPosition(2, pX, 0);
				
				mVertexData.setTexCoords(2, pX / mWidth, 0);
			}
			
			createBuffers();
		}
		
	}

}