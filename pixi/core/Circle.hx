package pixi.core;

/**
 * @author Chad Engler <chad@pantherdev.com>
 */

/**
 * The Circle object can be used to specify a hit area for displayobjects
 *
 * @class Circle
 * @constructor
 * @param x {Number} The X coord of the upper-left corner of the framing rectangle of this circle
 * @param y {Number} The Y coord of the upper-left corner of the framing rectangle of this circle
 * @param radius {Number} The radius of the circle
 */
class Circle {


public var x:Float;
public var y:Float;
public var radius:Float;


public function new (x:Float = 0, y:Float = 0, radius:Float = 0)
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

    /**
     * @property radius
     * @type Number
     * @default 0
     */
    this.radius = radius;
}

/**
 * Creates a clone of this Circle instance
 *
 * @method clone
 * @return {Circle} a copy of the polygon
 */
public function clone ()
{
    return new Circle(this.x, this.y, this.radius);
}

/**
 * Checks if the x, and y coords passed to this function are contained within this circle
 *
 * @method contains
 * @param x {Number} The X coord of the point to test
 * @param y {Number} The Y coord of the point to test
 * @return {Boolean} if the x/y coords are within this polygon
 */
public function contains (x, y)
{
    if(this.radius <= 0)
        return false;

    var dx = (this.x - x),
        dy = (this.y - y),
        r2 = this.radius * this.radius;

    dx *= dx;
    dy *= dy;

    return (dx + dy <= r2);
}

//PIXI.Circle.prototype.constructor = PIXI.Circle;

}

