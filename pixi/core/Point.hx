/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */

/**
 * The Point object represents a location in a two-dimensional coordinate system, where x represents the horizontal axis and y represents the vertical axis.
 *
 * @class Point
 * @constructor 
 * @param x {Number} position of the point
 * @param y {Number} position of the point
 */
package pixi.core;
class Point {

public var x:Float;
public var y:Float;

public function new (x:Float = 0, y:Float = 0)
{
	/**
	 * @property x 
	 * @type Number
	 * @default 0
	 */
	this.x = x;
	
	/**
	 * @property y
	 * @type Number
	 * @default 0
	 */
	this.y = y;
}

/**
 * Creates a clone of this point
 *
 * @method clone
 * @return {Point} a copy of the point
 */
public function clone ()
{
	return new Point(this.x, this.y);
}

// constructor
//PIXI.Point.prototype.constructor = PIXI.Point;

}