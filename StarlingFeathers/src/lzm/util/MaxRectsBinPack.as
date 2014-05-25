/*
Based on the Public Domain MaxRectanglesBinPack.cpp source by Jukka Jylänki
https://github.com/juj/RectangleBinPack/

Based on C# port by Sven Magnus 
http://unifycommunity.com/wiki/index.php?title=MaxRectanglesBinPack


Ported to ActionScript3 by DUZENGQIANG
http://www.duzengqiang.com/blog/post/971.html
This version is also public domain - do whatever you want with it.
*/

package lzm.util {
import flash.geom.Rectangle;

public class MaxRectsBinPack
{      
	public static const BESTSHORTSIDEFIT:int = 0; ///< -BSSF: Positions the Rectangle against the short side of a free Rectangle into which it fits the best.
	public static const BESTLONGSIDEFIT:int = 1; ///< -BLSF: Positions the Rectangle against the long side of a free Rectangle into which it fits the best.
	public static const BESTAREAFIT:int = 2; ///< -BAF: Positions the Rectangle into the smallest free Rectangle into which it fits.
	public static const BOTTOMLEFTRULE:int = 3; ///< -BL: Does the Tetris placement.
	public static const CONTACTPOINTRULE:int = 4; ///< -CP: Choosest the placement where the Rectangle touches other Rectangles as much as possible.
	
	public var binWidth:int = 0;
	public var binHeight:int = 0;
	public var allowRotations:Boolean = false;
	
	public var usedRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
	public var freeRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
	
	private var score1:int = 0; // Unused in this function. We don't need to know the score after finding the position.
	private var score2:int = 0;
	private var bestShortSideFit:int;
	private var bestLongSideFit:int;
	
	public function MaxRectsBinPack( width:int, height:int, rotations:Boolean = false) {
		init(width, height, rotations);
	}
	
	
	private function init(width:int, height:int, rotations:Boolean = false):void
	{
		if( count(width) % 1 != 0 ||count(height) % 1 != 0)
			throw new Error("Must be 2,4,8,16,32,...512,1024,...");
		binWidth = width;
		binHeight = height;
		allowRotations = rotations;
		
		var n:Rectangle = new Rectangle();
		n.x = 0;
		n.y = 0;
		n.width = width;
		n.height = height;
		
		usedRectangles.length = 0;
		
		freeRectangles.length = 0;
		freeRectangles.push( n );
	}
	
	private function count(n:Number):Number
	{
		if( n >= 2 )
			return count(n / 2);
		return n;
	}
	
	/**
	 * 插入一个矩形
	 * @param width
	 * @param height
	 * @param method
	 * @return 插入的位置
	 * 
	 */	
	public function insert(width:int, height:int,  method:int):Rectangle {
		var newNode:Rectangle  = new Rectangle();
		score1 = 0;
		score2 = 0;
		switch(method) {
			case BESTSHORTSIDEFIT: 
				newNode = findPositionForNewNodeBestShortSideFit(width, height); 
				break;
			case BOTTOMLEFTRULE: 
				newNode = findPositionForNewNodeBottomLeft(width, height, score1, score2); 
				break;
			case CONTACTPOINTRULE: 
				newNode = findPositionForNewNodeContactPoint(width, height, score1); 
				break;
			case BESTLONGSIDEFIT: 
				newNode = findPositionForNewNodeBestLongSideFit(width, height, score2, score1); 
				break;
			case BESTAREAFIT: 
				newNode = findPositionForNewNodeBestAreaFit(width, height, score1, score2); 
				break;
		}
		
		if (newNode.height == 0)
			return newNode;
		
		placeRectangle(newNode);
		return newNode;
	}
	
	private function insert2( Rectangles:Vector.<Rectangle>, dst:Vector.<Rectangle>, method:int):void {
		dst.length = 0;
		
		while(Rectangles.length > 0) {
			var bestScore1:int = int.MAX_VALUE;
			var bestScore2:int = int.MAX_VALUE;
			var bestRectangleIndex:int = -1;
			var bestNode:Rectangle = new Rectangle();
			
			for(var i:int = 0; i < Rectangles.length; ++i) {
				var score1:int = 0;
				var score2:int = 0;
				var newNode:Rectangle = scoreRectangle(Rectangles[i].width, Rectangles[i].height, method, score1, score2);
				
				if (score1 < bestScore1 || (score1 == bestScore1 && score2 < bestScore2)) {
					bestScore1 = score1;
					bestScore2 = score2;
					bestNode = newNode;
					bestRectangleIndex = i;
				}
			}
			
			if (bestRectangleIndex == -1)
				return;
			
			placeRectangle(bestNode);
			Rectangles.splice(bestRectangleIndex,1);
		}
	}
	
	private function placeRectangle(node:Rectangle):void {
		var numRectanglesToProcess:int = freeRectangles.length;
		for(var i:int = 0; i < numRectanglesToProcess; i++) {
			if (splitFreeNode(freeRectangles[i], node)) {
				freeRectangles.splice(i,1);
				--i;
				--numRectanglesToProcess;
			}
		}
		
		pruneFreeList();
		
		usedRectangles.push(node);
	}
	
	private function scoreRectangle( width:int,  height:int,  method:int, 
									 score1:int, score2:int):Rectangle {
		var newNode:Rectangle = new Rectangle();
		score1 = int.MAX_VALUE;
		score2 = int.MAX_VALUE;
		switch(method) {
			case BESTSHORTSIDEFIT: 
				newNode = findPositionForNewNodeBestShortSideFit(width, height); 
				break;
			case BOTTOMLEFTRULE: 
				newNode = findPositionForNewNodeBottomLeft(width, height, score1,score2); 
				break;
			case CONTACTPOINTRULE: 
				newNode = findPositionForNewNodeContactPoint(width, height, score1); 
				// todo: reverse
				score1 = -score1; // Reverse since we are minimizing, but for contact point score bigger is better.
				break;
			case BESTLONGSIDEFIT: 
				newNode = findPositionForNewNodeBestLongSideFit(width, height, score2, score1); 
				break;
			case BESTAREAFIT: 
				newNode = findPositionForNewNodeBestAreaFit(width, height, score1, score2); 
				break;
		}
		
		// Cannot fit the current Rectangle.
		if (newNode.height == 0) {
			score1 = int.MAX_VALUE;
			score2 = int.MAX_VALUE;
		}
		
		return newNode;
	}
	
	/// Computes the ratio of used surface area.
	private function occupancy():Number {
		var usedSurfaceArea:Number = 0;
		for(var i:int = 0; i < usedRectangles.length; i++)
			usedSurfaceArea += usedRectangles[i].width * usedRectangles[i].height;
		
		return usedSurfaceArea / (binWidth * binHeight);
	}
		
	private function findPositionForNewNodeBottomLeft(width:int, height:int, 
													  bestY:int, bestX:int):Rectangle {
		var bestNode:Rectangle = new Rectangle();
		//memset(bestNode, 0, sizeof(Rectangle));
		
		bestY = int.MAX_VALUE;
		var rect:Rectangle;
		var topSideY:int;
		for(var i:int = 0; i < freeRectangles.length; i++) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				topSideY = rect.y + height;
				if (topSideY < bestY || (topSideY == bestY && rect.x < bestX)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestY = topSideY;
					bestX = rect.x;
				}
			}
			if (allowRotations && rect.width >= height && rect.height >= width) {
				topSideY = rect.y + width;
				if (topSideY < bestY || (topSideY == bestY && rect.x < bestX)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestY = topSideY;
					bestX = rect.x;
				}
			}
		}
		return bestNode;
	}
		
	private function findPositionForNewNodeBestShortSideFit(width:int, height:int):Rectangle  {
		var bestNode:Rectangle = new Rectangle();
		//memset(&bestNode, 0, sizeof(Rectangle));
		
		bestShortSideFit = int.MAX_VALUE;
		bestLongSideFit = score2;
		var rect:Rectangle;
		var leftoverHoriz:int;
		var leftoverVert:int;
		var shortSideFit:int;
		var longSideFit:int;
		
		for(var i:int = 0; i < freeRectangles.length; i++) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = Math.abs(rect.width - width);
				leftoverVert = Math.abs(rect.height - height);
				shortSideFit = Math.min(leftoverHoriz, leftoverVert);
				longSideFit = Math.max(leftoverHoriz, leftoverVert);
				
				if (shortSideFit < bestShortSideFit || (shortSideFit == bestShortSideFit && longSideFit < bestLongSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}
			var flippedLeftoverHoriz:int;
			var flippedLeftoverVert:int;
			var flippedShortSideFit:int;
			var flippedLongSideFit:int;
			if (allowRotations && rect.width >= height && rect.height >= width) {
				flippedLeftoverHoriz = Math.abs(rect.width - height);
				flippedLeftoverVert = Math.abs(rect.height - width);
				flippedShortSideFit = Math.min(flippedLeftoverHoriz, flippedLeftoverVert);
				flippedLongSideFit = Math.max(flippedLeftoverHoriz, flippedLeftoverVert);
				
				if (flippedShortSideFit < bestShortSideFit || (flippedShortSideFit == bestShortSideFit && flippedLongSideFit < bestLongSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = flippedShortSideFit;
					bestLongSideFit = flippedLongSideFit;
				}
			}
		}
		
		return bestNode;
	}
	
	private function  findPositionForNewNodeBestLongSideFit(width:int, height:int, bestShortSideFit:int, bestLongSideFit:int):Rectangle {
		var bestNode:Rectangle = new Rectangle();
		//memset(&bestNode, 0, sizeof(Rectangle));
		bestLongSideFit = int.MAX_VALUE;
		var rect:Rectangle;
		
		var leftoverHoriz:int;
		var leftoverVert:int;
		var shortSideFit:int;
		var longSideFit:int;
		for(var i:int = 0; i < freeRectangles.length; i++) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = Math.abs(rect.width - width);
				leftoverVert = Math.abs(rect.height - height);
				shortSideFit = Math.min(leftoverHoriz, leftoverVert);
				longSideFit = Math.max(leftoverHoriz, leftoverVert);
				
				if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}
			
			if (allowRotations && rect.width >= height && rect.height >= width) {
				leftoverHoriz = Math.abs(rect.width - height);
				leftoverVert = Math.abs(rect.height - width);
				shortSideFit = Math.min(leftoverHoriz, leftoverVert);
				longSideFit = Math.max(leftoverHoriz, leftoverVert);
				
				if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}
		}
		return bestNode;
	}
	
	private function findPositionForNewNodeBestAreaFit(width:int, height:int, bestAreaFit:int, bestShortSideFit:int):Rectangle {
		var bestNode:Rectangle = new Rectangle();
		//memset(&bestNode, 0, sizeof(Rectangle));
		
		bestAreaFit = int.MAX_VALUE;
		
		var rect:Rectangle;
		
		var leftoverHoriz:int;
		var leftoverVert:int;
		var shortSideFit:int;
		var areaFit:int;
		
		for(var i:int = 0; i < freeRectangles.length; i++) {
			rect = freeRectangles[i];
			areaFit = rect.width * rect.height - width * height;
			
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = Math.abs(rect.width - width);
				leftoverVert = Math.abs(rect.height - height);
				shortSideFit = Math.min(leftoverHoriz, leftoverVert);
				
				if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestAreaFit = areaFit;
				}
			}
			
			if (allowRotations && rect.width >= height && rect.height >= width) {
				leftoverHoriz = Math.abs(rect.width - height);
				leftoverVert = Math.abs(rect.height - width);
				shortSideFit = Math.min(leftoverHoriz, leftoverVert);
				
				if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = shortSideFit;
					bestAreaFit = areaFit;
				}
			}
		}
		return bestNode;
	}
	
	/// Returns 0 if the two intervals i1 and i2 are disjoint, or the length of their overlap otherwise.
	private function commonIntervalLength(i1start:int, i1end:int, i2start:int, i2end:int):int {
		if (i1end < i2start || i2end < i1start)
			return 0;
		return Math.min(i1end, i2end) - Math.max(i1start, i2start);
	}
	
	private function contactPointScoreNode(x:int, y:int, width:int, height:int):int {
		var score:int = 0;
		
		if (x == 0 || x + width == binWidth)
			score += height;
		if (y == 0 || y + height == binHeight)
			score += width;
		var rect:Rectangle;
		for(var i:int = 0; i < usedRectangles.length; i++) {
			rect = usedRectangles[i];
			if (rect.x == x + width || rect.x + rect.width == x)
				score += commonIntervalLength(rect.y, rect.y + rect.height, y, y + height);
			if (rect.y == y + height || rect.y + rect.height == y)
				score += commonIntervalLength(rect.x, rect.x + rect.width, x, x + width);
		}
		return score;
	}
	
	private function findPositionForNewNodeContactPoint(width:int, height:int, bestContactScore:int):Rectangle {
		var bestNode:Rectangle = new Rectangle();
		//memset(&bestNode, 0, sizeof(Rectangle));
		
		bestContactScore = -1;
		
		var rect:Rectangle;
		var score:int;
		for(var i:int = 0; i < freeRectangles.length; i++) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				score = contactPointScoreNode(rect.x, rect.y, width, height);
				if (score > bestContactScore) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestContactScore = score;
				}
			}
			if (allowRotations && rect.width >= height && rect.height >= width) {
				score = contactPointScoreNode(rect.x, rect.y, height, width);
				if (score > bestContactScore) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestContactScore = score;
				}
			}
		}
		return bestNode;
	}
	
	private function splitFreeNode(freeNode:Rectangle, usedNode:Rectangle):Boolean {
		// Test with SAT if the Rectangles even intersect.
		if (usedNode.x >= freeNode.x + freeNode.width || usedNode.x + usedNode.width <= freeNode.x ||
			usedNode.y >= freeNode.y + freeNode.height || usedNode.y + usedNode.height <= freeNode.y)
			return false;
		var newNode:Rectangle;
		if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x) {
			// New node at the top side of the used node.
			if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.height = usedNode.y - newNode.y;
				freeRectangles.push(newNode);
			}
			
			// New node at the bottom side of the used node.
			if (usedNode.y + usedNode.height < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.y = usedNode.y + usedNode.height;
				newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
				freeRectangles.push(newNode);
			}
		}
		
		if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y) {
			// New node at the left side of the used node.
			if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.width = usedNode.x - newNode.x;
				freeRectangles.push(newNode);
			}
			
			// New node at the right side of the used node.
			if (usedNode.x + usedNode.width < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.x = usedNode.x + usedNode.width;
				newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
				freeRectangles.push(newNode);
			}
		}
		
		return true;
	}
	
	private function pruneFreeList():void {
		for(var i:int = 0; i < freeRectangles.length; i++)
			for(var j:int = i+1; j < freeRectangles.length; j++) {
				if (isContainedIn(freeRectangles[i], freeRectangles[j])) {
					freeRectangles.splice(i,1);
					break;
				}
				if (isContainedIn(freeRectangles[j], freeRectangles[i])) {
					freeRectangles.splice(j,1);
				}
			}
	}
	
	private function isContainedIn(a:Rectangle, b:Rectangle):Boolean {
		return a.x >= b.x && a.y >= b.y 
			&& a.x+a.width <= b.x+b.width 
			&& a.y+a.height <= b.y+b.height;
	}
	
	
}


}
