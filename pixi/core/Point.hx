package pixi.core;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class Point {
	
	
	public var x:Float;
	public var y:Float;
	
	
	/**
	 * The Point object represents a location in a two-dimensional coordinate system, where x represents the horizontal axis and y represents the vertical axis.
	 *
	 * @class Point
	 * @constructor 
	 * @param x {Number} position of the point
	 * @param y {Number} position of the point
	 */
	public function new (x:Float = 0, y:Float = 0) {
		
		this.x = x;
		this.y = y;
		
	}
	
	
	/**
	 * Creates a clone of this point
	 *
	 * @method clone
	 * @return {Point} a copy of the point
	 */
	public function clone ():Point {
		
		return new Point(this.x, this.y);
		
	}
	
	
}