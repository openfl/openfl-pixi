package pixi.core;

/**
 * @author Chad Engler <chad@pantherdev.com>
 * @author Joshua Granick
 */
class Ellipse
{
	public var height:Float;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	
	/**
	 * The Ellipse object can be used to specify a hit area for displayobjects
	 *
	 * @class Ellipse
	 * @constructor
	 * @param x {Number} The X coord of the upper-left corner of the framing rectangle of this ellipse
	 * @param y {Number} The Y coord of the upper-left corner of the framing rectangle of this ellipse
	 * @param width {Number} The overall height of this ellipse
	 * @param height {Number} The overall width of this ellipse
	 */
	public function new (x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	/**
	 * Creates a clone of this Ellipse instance
	 *
	 * @method clone
	 * @return {Ellipse} a copy of the ellipse
	 */
	public function clone ():Ellipse
	{
		return new Ellipse(this.x, this.y, this.width, this.height);
	}
	
	/**
	 * Checks if the x, and y coords passed to this function are contained within this ellipse
	 *
	 * @method contains
	 * @param x {Number} The X coord of the point to test
	 * @param y {Number} The Y coord of the point to test
	 * @return {Boolean} if the x/y coords are within this ellipse
	 */
	public function contains (x:Float, y:Float):Bool
	{
		if(this.width <= 0 || this.height <= 0)
			return false;
		
		//normalize the coords to an ellipse with center 0,0
		//and a radius of 0.5
		var normx = ((x - this.x) / this.width) - 0.5,
			normy = ((y - this.y) / this.height) - 0.5;
		
		normx *= normx;
		normy *= normy;
		
		return (normx + normy < 0.25);
	}
	
	public function getBounds ():Rectangle
	{
		return new Rectangle(this.x, this.y, this.width, this.height);
	}
}