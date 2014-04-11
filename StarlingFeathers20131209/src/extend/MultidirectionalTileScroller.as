package extend
{
	//Imports
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	
	//Class
	public class MultidirectionalTileScroller extends DisplayObjectContainer
	{
		//Properties
		private var m_Canvas:QuadBatch;
		private var m_Width:uint;
		private var m_Height:uint;
		private var m_Texture:Texture;
		private var m_Image:Image;
		
		private var m_TextureNativeWidth:Number;
		private var m_TextureNativeHeight:Number;
		private var m_TextureScaleX:Number;
		private var m_TextureScaleY:Number;
		private var m_TextureWidth:Number;
		private var m_TextureHeight:Number;
		
		private var m_PivotPoint:Point;
		private var m_IsAnimating:Boolean;
		private var m_Speed:Number = 0;
		private var m_Angle:Number = 0;
		
		//Constructor
		public function MultidirectionalTileScroller(width:uint, height:uint, texture:Texture, textureScaleX:Number = 1.0, textureScaleY:Number = 1.0)
		{
			m_Width = width;
			m_Height = height;
			m_Texture = texture;
			m_TextureScaleX = textureScaleX;
			m_TextureScaleY = textureScaleY;
			
			init();
		}
		
		//Init
		private function init():void
		{
			touchable = false;
			
			drawTexture();
		}
		
		//Draw Texture
		private function drawTexture():void
		{
			m_TextureNativeWidth = m_Texture.width;
			m_TextureNativeHeight = m_Texture.height;
			
			m_Image = new Image(m_Texture);
			m_Image.scaleX = m_TextureScaleX;
			m_Image.scaleY = m_TextureScaleY;
			
			drawCanvas();
		}
		
		//Draw Canvas
		private function drawCanvas():void
		{
			if (numChildren) removeChildren();
			
			m_Canvas = new QuadBatch();
			
			for (var columns:uint = 0; columns <= Math.ceil(m_Width / (m_TextureNativeWidth * m_TextureScaleX)) + 1; columns++)
			{
				for (var rows:uint = 0; rows <= Math.ceil(m_Height / (m_TextureNativeHeight * m_TextureScaleY)) + 1; rows++)
				{
					m_Image.x = m_TextureNativeWidth * m_TextureScaleX * columns;
					m_Image.y = m_TextureNativeHeight * m_TextureScaleY * rows;
					
					m_Canvas.addImage(m_Image);
				}
			}
			
			m_TextureWidth = m_TextureNativeWidth * m_TextureScaleX;
			m_TextureHeight = m_TextureNativeHeight * m_TextureScaleY;
			
			m_PivotPoint = new Point(m_Width / 2, m_Height / 2);
			
			m_Canvas.alignPivot();
			m_Canvas.x = m_PivotPoint.x;
			m_Canvas.y = m_PivotPoint.y;
			
			addChild(m_Canvas);
		}
		
		//Play
		public function play(speed:Number = NaN, angle:Number = NaN):void
		{
			this.speed = (isNaN(speed)) ? this.speed : speed;
			this.angle = (isNaN(speed)) ? this.angle : angle;
			
			m_IsAnimating = true;
			
			if (!m_Canvas.hasEventListener(EnterFrameEvent.ENTER_FRAME))
			{
				m_Canvas.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
			}
		}
		
		//Stop
		public function stop():void
		{
			m_IsAnimating = false;
			
			if (m_Canvas.hasEventListener(EnterFrameEvent.ENTER_FRAME))
			{
				m_Canvas.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
			}
		}
		
		//Enter Frame Event Handler
		private function enterFrameEventHandler(event:EnterFrameEvent):void
		{
			m_Canvas.x += Math.cos(m_Angle) * m_Speed;
			m_Canvas.y += Math.sin(m_Angle) * m_Speed;
			
			if (m_Canvas.x < m_PivotPoint.x - m_TextureWidth)
			{
				m_Canvas.x += m_TextureWidth;
			}
			
			if (m_Canvas.x > m_PivotPoint.x + m_TextureWidth)
			{
				m_Canvas.x -= m_TextureWidth;
			}
			
			if (m_Canvas.y < m_PivotPoint.y - m_TextureHeight)
			{
				m_Canvas.y += m_TextureHeight;
			}
			
			if (m_Canvas.y > m_PivotPoint.y + m_TextureHeight)
			{
				m_Canvas.y -= m_TextureHeight;
			}
		}
		
		//Dispose
		override public function dispose():void
		{
			stop();
			
			super.dispose();
		}
		
		//Set Texture
		public function setTexture(texture:Texture, textureScaleX:Number = 1.0, textureScaleY:Number = 1.0):void
		{
			if (isAnimating) stop();
			
			if (m_Texture) m_Texture.dispose();
			
			m_Texture = texture;
			m_TextureScaleX = textureScaleX;
			m_TextureScaleY = m_TextureScaleY;
			
			drawTexture();
		}
		
		//Set Size
		public function setSize(width:uint, height:uint):void
		{
			m_Width = width;
			m_Height = height;
			
			drawCanvas();
		}
		
		//Set Speed
		public function set speed(value:Number):void
		{
			m_Speed = (isNaN(value) || value <= 0.0) ? 0.0 : Math.min(value, Math.min(m_TextureWidth, m_TextureHeight));
		}
		
		//Get Speed
		public function get speed():Number
		{
			return m_Speed;
		}
		
		//Set Angle
		public function set angle(value:Number):void
		{
			m_Angle = (isNaN(value) ? 180 : 180 - value) * Math.PI / 180;
		}
		
		//Get Angle
		public function get angle():Number
		{
			return 180 - m_Angle * 180 / Math.PI;
		}
		
		//Get isAnimating
		public function get isAnimating():Boolean
		{
			return m_IsAnimating;
		}
		
		public function set canvasX(value:Number):void{ m_Canvas.x = value; }
		public function get canvasX():Number{ return m_Canvas.x; }
		public function set canvasY(value:Number):void{ m_Canvas.y = value; }
		public function get canvasY():Number{ return m_Canvas.y; }
		
	}
}