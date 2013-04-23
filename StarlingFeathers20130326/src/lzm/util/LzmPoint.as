package lzm.util
{
	public class LzmPoint
	{
		public var x:Number
		public var y:Number
		//public var z:Number
		public function LzmPoint(x:Number=0,y:Number=0)
		{
			this.x=x
			this.y=y
		}
		/**
		 * 测试两点是否相同 
		 * @param ponit
		 * @return 
		 * 
		 */		
		public function equals(target:LzmPoint):Boolean{			
			var LiiFontZip:Boolean=false
			if(target.x==this.x&&target.y==this.y){
				LiiFontZip=true
			}
			return LiiFontZip
		}
		/**
		 * 获取两点间直线距离 
		 * @param PointA
		 * @param PointB
		 * @return 
		 * 
		 */		
		public static function distance(PointA:LzmPoint,PointB:LzmPoint):Number{
			var a:Number=PointA.x-PointB.x
			var b:Number=PointA.y-PointB.y
			return Math.sqrt(a*a+b*b)
		}
		public static function angleABC(PointA:LzmPoint,PointB:LzmPoint,PointC:LzmPoint):Number{
			var a:Number=distance(PointA,PointC)
			var b:Number=distance(PointB,PointC)
			var c:Number=distance(PointA,PointB)
			return Math.acos(-(a*a-b*b-c*c)/2/b/c)/Math.PI*180
		}
		/**
		 * 获取A和B点连接的直线与X轴的夹角 
		 * @param PointA
		 * @param PointB
		 * @return 
		 * 
		 */		
		public static function rotation(PointA:LzmPoint,PointB:LzmPoint):Number{
			return Math.atan2(PointB.y-PointA.y,PointB.x-PointA.x)/0.017453292519943295
		}
		/**
		 * 获取A和B点连接的直线与X轴的夹角 
		 * @param PointA
		 * @param PointB
		 * @return 
		 * 
		 */		
		public static function FLrotation(PointA:LzmPoint,PointB:LzmPoint):Number{
			return Math.atan2(PointB.y-PointA.y,PointB.x-PointA.x)/0.017453292519943295
		}		
		/**
		 * 获取2点的中间点 
		 * @param Point1 起点
		 * @param Point2 终点
		 * @return 中点
		 * 
		 */		
		public static function lineCenter(Point1:LzmPoint,Point2:LzmPoint):LzmPoint{
			return new LzmPoint(Point1.x-(Point1.x-Point2.x)/2,Point1.y-(Point1.y-Point2.y)/2)
		}		
		public function get length():Number{
			return distance(new LzmPoint(),this)
		}
		public function get point():LzmPoint{return new LzmPoint(x,y)}
		public function set point(p:LzmPoint):void{x=p.x;y=p.y}
		public function clone():*{
			return new LzmPoint(x,y);
		}
		public function toString():String{
			return "[ LzmPoint ](x="+x+",y="+y+")"
		}
	}
}