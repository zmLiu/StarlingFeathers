package lzm.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 碰撞 
	 * @author lzm
	 * 
	 */	
	public class CollisionUtils
	{
		
		/**
		 * 顶点碰撞检测,面积碰撞
		 * p1,p2,p3 为范围点
		 * p4为碰撞点。
		 * @return
		 */
		public static function hitPoint(p1:Point,p2:Point,p3:Point,p4:Point):Boolean{
			var a:int = hitTrianglePoint(p1,p2,p3);
			var b:int = hitTrianglePoint(p4,p2,p3);
			var c:int = hitTrianglePoint(p1,p2,p4);
			var d:int = hitTrianglePoint(p1,p4,p3);
			if ((b==a)&&(c==a)&&(d==a)){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		  * 面积检测
		  * @param   p1
		  * @param   p2
		  * @param   p3
		  * @return
		  */
		public static function hitTrianglePoint(p1:Point,p2:Point,p3:Point):int{
		    if ((p2.x-p1.x)*(p2.y+p1.y)+(p3.x-p2.x)*(p3.y+p2.y)+(p1.x-p3.x)*(p1.y+p3.y)){
			     return 1;
		    }else{
				return 0;
			}
		}
		
		/**
		 * 根据弧度获取3个定点 
		 * @param angle	弧度
		 * @param distance 距离
		 * @param fjaodu	上夹角的角度
		 * @param zjiaodu	下夹角的角度
		 * @return array[中间的定点，上夹角顶点，下夹角顶点]
		 */		
		public static function trianglePointByAngle(angle:Number,distance:Number,fjaodu:Number,zjiaodu:Number):Array{
			var point1:Point = new Point();
			var point2:Point = new Point();
			var point3:Point = new Point();
			
			point1.x = distance * Math.cos(angle);
			point1.y = distance * Math.sin(angle);
			
			var fAngle:Number = angle - (fjaodu / 180.0 * Math.PI);
			point2.x = distance * Math.cos(fAngle);
			point2.y = distance * Math.sin(fAngle);
			
			var zAngle:Number = angle + (zjiaodu / 180.0 * Math.PI);
			point3.x = distance * Math.cos(zAngle);
			point3.y = distance * Math.sin(zAngle);
			
			return [point1,point2,point3];
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 定点碰撞，象限法,叉乘法
		 */		
		public static function pointHitTriangle(px:int,py:int,x1:int,y1:int,x2:int,y2:int,x3:int,y3:int):Boolean{
			
			if((px < x1 && px < x2 && px < x3)
				||(px > x1 && px > x2 && px > x3)
				||(py < y1 && py < y2 && py < y3)
				||(py > y1 && py > y2 && py > y3)
			){
				return false;
			}
			
			var a1:int;
			var a2:int;
			var a3:int;
			
			//象限法
			a1 = quadrantJudging(px,py,x1,y1,x2,y2);
			a2 = quadrantJudging(px,py,x2,y2,x3,y3);
			a3 = quadrantJudging(px,py,x3,y3,x1,y1);
			
			//向量法
//			a1 = corssJudging(px,py,x1,y1,x2,y2);
//			a2 = corssJudging(px,py,x2,y2,x3,y3);
//			a3 = corssJudging(px,py,x3,y3,x1,y1);
			
			if((a1 > 0 && a2 > 0 && a3 > 0) || (a1 < 0 && a2 < 0 && a3 < 0)){
				return true;
			}
			
			return false;
		}
		
		public static function quadrantJudging(x1:int,y1:int,x2:int,y2:int,x3:int,y3:int):int{
			return (x1 - x2) * (y3 - y2) - (y1 - y2) * (x3 - x2);
		}
		
		public static function corssJudging(x1:int,y1:int,x2:int,y2:int,x3:int,y3:int):int{
			return (x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 判断两个矩形是否相交 
		 */	
		public static function isIntersectingRect(rectA:Rectangle,rectB:Rectangle):Boolean{
			
			var ax:Number = rectA.x;
			var ay:Number = rectA.y;
			var aw:Number = rectA.width;
			var ah:Number = rectA.height;
			
			var bx:Number = rectB.x;
			var by:Number = rectB.y;
			var bw:Number = rectB.width;
			var bh:Number = rectB.height;
			
			if (by + bh < ay || // is the bottom b above the top of a?
				by > ay + ah || // is the top of b below bottom of a?
				bx + bw < ax || // is the right of b to the left of a?
				bx > ax + aw) // is the left of b to the right of a?
				return false;
			
			return true;
		}
		
		
		
	}
}