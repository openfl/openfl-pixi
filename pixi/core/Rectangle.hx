package pixi.core;


/**
 * @author Mat Groves http://matgroves.com/
 * @author Joshua Granick
 */
class Rectangle {
	
	
	public var height:Float;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	
	
	/**
	 * the Rectangle object is an area defined by its position, as indicated by its top-left corner point (x, y) and by its width and its height.
	 *
	 * @class Rectangle
	 * @constructor 
	 * @param x {Number} The X coord of the upper-left corner of the rectangle
	 * @param y {Number} The Y coord of the upper-left corner of the rectangle
	 * @param width {Number} The overall wisth of this rectangle
	 * @param height {Number} The overall height of this rectangle
	 */
	public function new (x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
	}
	
	
	/**
	 * Creates a clone of this Rectangle
	 *
	 * @method clone
	 * @return {Rectangle} a copy of the rectangle
	 */
	public function clone ():Rectangle {
		
		return new Rectangle(this.x, this.y, this.width, this.height);
		
	}
	
	
	/**
	 * Checks if the x, and y coords passed to this function are contained within this Rectangle
	 *
	 * @method contains
	 * @param x {Number} The X coord of the point to test
	 * @param y {Number} The Y coord of the point to test
	 * @return {Boolean} if the x/y coords are within this Rectangle
	 */
	public function contains (x:Float, y:Float):Bool {
		
		if(this.width <= 0 || this.height <= 0)
			return false;
		
		var x1 = this.x;
		if(x >= x1 && x <= x1 + this.width)
		{
			var y1 = this.y;
			
			if(y >= y1 && y <= y1 + this.height)
			{
				return true;
			}
		}
		
		return false;
		
	}
	
	
}