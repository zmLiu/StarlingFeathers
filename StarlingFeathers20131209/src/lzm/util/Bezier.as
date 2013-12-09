package lzm.util
{
	import flash.geom.Point;

	public class Bezier
	{
		private var p0:Point;// 起点
		private var p1:Point;// 控制点
		private var p2:Point;// 终点
		private var step:uint;// 分割份数
		
		private var ax:int;
		private var ay:int;
		private var bx:int;
		private var by:int;
		
		private var A:Number;
		private var B:Number;
		private var C:Number;
		
		private var total_length:Number;// 长度
		
		/**
		 * 创建bezier
		 * @param p0		起点
		 * @param p1		控制点
		 * @param p2		终点
		 * @param speed		速度
		 * 
		 */		
		public function Bezier(p0:Point, p1:Point, p2:Point, speed:Number){
			this.p0   = p0;
			this.p1   = p1;
			this.p2   = p2;
			
			ax = p0.x - 2 * p1.x + p2.x;
			ay = p0.y - 2 * p1.y + p2.y;
			bx = 2 * p1.x - 2 * p0.x;
			by = 2 * p1.y - 2 * p0.y;
			
			A = 4*(ax * ax + ay * ay);
			B = 4*(ax * bx + ay * by);
			C = bx * bx + by * by;
			
			//计算长度
			total_length = L(1);
			
			//计算步数
			step = Math.floor(total_length / speed);
			if (total_length % speed > speed / 2) step ++;
		}
		
		
		//速度函数
		private function s (t:Number):Number
		{
			return Math.sqrt(A * t * t + B * t + C);
		}
		
		//长度函数
		private function L (t:Number):Number
		{
			var temp1:Number = Math.sqrt(C + t * (B + A * t));
			var temp2:Number = (2 * A * t * temp1 + B *(temp1 - Math.sqrt(C)));
			var temp3:Number = Math.log(B + 2 * Math.sqrt(A) * Math.sqrt(C));
			var temp4:Number = Math.log(B + 2 * A * t + 2 * Math.sqrt(A) * temp1);
			var temp5:Number = 2 * Math.sqrt(A) * temp2;
			var temp6:Number = (B * B - 4 * A * C) * (temp3 - temp4);
			
			return (temp5 + temp6) / (8 * Math.pow(A, 1.5));
		}
		
		//长度函数反函数，使用牛顿切线法求解
		private function InvertL (t:Number, l:Number):Number
		{
			var t1:Number = t;
			var t2:Number;
			do
			{
				t2 = t1 - (L(t1) - l)/s(t1);
				if (Math.abs(t1-t2) < 0.000001) break;
				t1 = t2;
			}while(true);
			return t2;
		}
		
		//根据指定nIndex位置获取锚点：返回坐标和角度
		public function getAnchorPoint (nIndex:Number):Array
		{
			if (nIndex >= 0 && nIndex <= step)
			{
				var t:Number = nIndex/step;
				//  如果按照线行增长，此时对应的曲线长度
				var l:Number = t*total_length;
				//  根据L函数的反函数，求得l对应的t值
				t = InvertL(t, l);
				
				//  根据贝塞尔曲线函数，求得取得此时的x,y坐标
				var xx:Number = (1 - t) * (1 - t) * p0.x + 2 * (1 - t) * t * p1.x + t * t * p2.x;
				var yy:Number = (1 - t) * (1 - t) * p0.y + 2 * (1 - t) * t * p1.y + t * t * p2.y;
				
				//  获取切线
				var Q0:Point = new Point((1 - t) * p0.x + t * p1.x, (1 - t) * p0.y + t * p1.y);
				var Q1:Point = new Point((1 - t) * p1.x + t * p2.x, (1 - t) * p1.y + t * p2.y);
				
				//  计算角度
				var dx:Number = Q1.x - Q0.x;
				var dy:Number = Q1.y - Q0.y;
				var radians:Number = Math.atan2(dy, dx);
				var degrees:Number = radians * 180 / Math.PI;
				
				return new Array(xx, yy, degrees);
			}
			else
			{
				return [];
			}
		}
		
		//获取所需步数
		public function get bezierStep():int{
			return step;
		}
	}
}