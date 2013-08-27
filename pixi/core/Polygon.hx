package pixi.core;


/**
 * @author Adrien Brault <adrien.brault@gmail.com>
 * @author Joshua Granick
 */
class Polygon {
    
    
	public var points:Array<Point>;
    
    
	/**
	 * @class Polygon
	 * @constructor
	 * @param points* {Array<Point>|Array<Number>|Point...|Number...} This can be an array of Points that form the polygon,
	 *	  a flat array of numbers that will be interpreted as [x,y, x,y, ...], or the arugments passed can be
	 *	  all the points of the polygon e.g. `new PIXI.Polygon(new PIXI.Point(), new PIXI.Point(), ...)`, or the
	 *	  arguments passed can be flat x,y values e.g. `new PIXI.Polygon(x,y, x,y, x,y, ...)` where `x` and `y` are
	 *	  Numbers.
	 */
	public function new (points:Dynamic) {
        
		//if points isn't an array, use arguments as the array
		if(untyped __js__("!(points instanceof Array)"))
			points = untyped __js__("Array.prototype.slice.call(arguments)");
        
		//if this is a flat array of numbers, convert it to points
		if(points.length > 0 && Std.is (points[0], Float)) {
			var p = [];
            
            var i = 0;
            var il = points.length;
            while (i < il) {
				p.push(
					new Point(points[i], points[i + 1]);
				);
                i+=2;
			}
            
			points = p;
		}
        
		this.points = points;
        
	}
    
    
	/**
	 * Creates a clone of this polygon
	 *
	 * @method clone
	 * @return {Polygon} a copy of the polygon
	 */
	public function clone ():Polygon {
        
		var points = [];
		for (i in 0...this.points.length) {
			points.push(this.points[i].clone());
		}
        
		return new Polygon(points);
        
	}
    
    
	/**
	 * Checks if the x, and y coords passed to this function are contained within this polygon
	 *
	 * @method contains
	 * @param x {Number} The X coord of the point to test
	 * @param y {Number} The Y coord of the point to test
	 * @return {Boolean} if the x/y coords are within this polygon
	 */
	public function contains (x:Float, y:Float):Bool {
        
		var inside = false;
        
		// use some raycasting to test hits
		// https://github.com/substack/point-in-polygon/blob/master/index.js
		var i = 0;
		var j = this.points.length - 1;
		while (i < this.points.length) {
			var xi = this.points[i].x, yi = this.points[i].y,
				xj = this.points[j].x, yj = this.points[j].y,
				intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
            
			if(intersect) inside = !inside;
			j = i++;
		}
        
		return inside;
        
	}
    
    
}