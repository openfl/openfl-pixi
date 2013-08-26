package pixi.primitives;


import pixi.display.DisplayObjectContainer;

/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */


/**
 * The Graphics class contains a set of methods that you can use to create primitive shapes and lines. 
 * It is important to know that with the webGL renderer only simple polys can be filled at this stage
 * Complex polys will not be filled. Heres an example of a complex poly: http://www.goodboydigital.com/wp-content/uploads/2013/06/complexPolygon.png
 *
 * @class Graphics 
 * @extends DisplayObjectContainer
 * @constructor
 */
class Graphics extends DisplayObjectContainer {
	
	public static var POLY = 0;
	public static var RECT = 1;
	public static var CIRC = 2;
	public static var ELIP = 3;

	public var fillAlpha:Float;
	public var lineWidth:Float;
	public var lineAlpha:Float;
	public var lineColor:Float;
	public var fillColor:Float;
	public var graphicsData:Array<Dynamic>;
	public var currentPath:Dynamic;
	public var dirty:Bool;
	public var filling:Bool;
	public var clearDirty:Bool;
	
public function new ()
{
	//PIXI.DisplayObjectContainer.call( this );
	super ();
	
	this.renderable = true;

    /**
     * The alpha of the fill of this graphics object
     *
     * @property fillAlpha
     * @type Number
     */
	this.fillAlpha = 1;

    /**
     * The width of any lines drawn
     *
     * @property lineWidth
     * @type Number
     */
	this.lineWidth = 0;

    /**
     * The color of any lines drawn
     *
     * @property lineColor
     * @type String
     */
	this.lineColor = 0;

    /**
     * Graphics data
     *
     * @property graphicsData
     * @type Array
     * @private
     */
	this.graphicsData = [];

    /**
     * Current path
     *
     * @property currentPath
     * @type Object
     * @private
     */
	this.currentPath = {points:[]};
}

// constructor
//PIXI.Graphics.prototype = Object.create( PIXI.DisplayObjectContainer.prototype );
//PIXI.Graphics.prototype.constructor = PIXI.Graphics;

/**
 * Specifies a line style used for subsequent calls to Graphics methods such as the lineTo() method or the drawCircle() method.
 *
 * @method lineStyle
 * @param lineWidth {Number} width of the line to draw, will update the object's stored style
 * @param color {Number} color of the line to draw, will update the object's stored style
 * @param alpha {Number} alpha of the line to draw, will update the object's stored style
 */
public function lineStyle (lineWidth = 0, color = 0, alpha = 1)
{
	if(this.currentPath.points.length == 0)this.graphicsData.pop();
	
	this.lineWidth = lineWidth;
	this.lineColor = color;
	this.lineAlpha = alpha;
	
	this.currentPath = {lineWidth:this.lineWidth, lineColor:this.lineColor, lineAlpha:this.lineAlpha, 
						fillColor:this.fillColor, fillAlpha:this.fillAlpha, fill:this.filling, points:[], type:Graphics.POLY};
	
	this.graphicsData.push(this.currentPath);
}

/**
 * Moves the current drawing position to (x, y).
 *
 * @method moveTo
 * @param x {Number} the X coord to move to
 * @param y {Number} the Y coord to move to
 */
public function moveTo (x, y)
{
	if(this.currentPath.points.length == 0)this.graphicsData.pop();
	
	this.currentPath = this.currentPath = {lineWidth:this.lineWidth, lineColor:this.lineColor, lineAlpha:this.lineAlpha, 
						fillColor:this.fillColor, fillAlpha:this.fillAlpha, fill:this.filling, points:[], type:Graphics.POLY};
	
	this.currentPath.points.push(x, y);
	
	this.graphicsData.push(this.currentPath);
}

/**
 * Draws a line using the current line style from the current drawing position to (x, y);
 * the current drawing position is then set to (x, y).
 *
 * @method lineTo
 * @param x {Number} the X coord to draw to
 * @param y {Number} the Y coord to draw to
 */
public function lineTo (x, y)
{
	this.currentPath.points.push(x, y);
	this.dirty = true;
}

/**
 * Specifies a simple one-color fill that subsequent calls to other Graphics methods
 * (such as lineTo() or drawCircle()) use when drawing.
 *
 * @method beginFill
 * @param color {uint} the color of the fill
 * @param alpha {Number} the alpha
 */
public function beginFill (color = 0, alpha = 1)
{
	this.filling = true;
	this.fillColor = color;
	this.fillAlpha = alpha;
}

/**
 * Applies a fill to the lines and shapes that were added since the last call to the beginFill() method.
 *
 * @method endFill
 */
public function endFill ()
{
	this.filling = false;
	this.fillColor = null;
	this.fillAlpha = 1;
}

/**
 * @method drawRect
 *
 * @param x {Number} The X coord of the top-left of the rectangle
 * @param y {Number} The Y coord of the top-left of the rectangle
 * @param width {Number} The width of the rectangle
 * @param height {Number} The height of the rectangle
 */
public function drawRect ( x, y, width, height )
{
	if(this.currentPath.points.length == 0)this.graphicsData.pop();
	
	this.currentPath = {lineWidth:this.lineWidth, lineColor:this.lineColor, lineAlpha:this.lineAlpha, 
						fillColor:this.fillColor, fillAlpha:this.fillAlpha, fill:this.filling, 
						points:[x, y, width, height], type:Graphics.RECT};
						
	this.graphicsData.push(this.currentPath);
	this.dirty = true;
}

/**
 * Draws a circle.
 *
 * @method drawCircle
 * @param x {Number} The X coord of the center of the circle
 * @param y {Number} The Y coord of the center of the circle
 * @param radius {Number} The radius of the circle
 */
public function drawCircle ( x, y, radius)
{
	if(this.currentPath.points.length == 0)this.graphicsData.pop();
	
	this.currentPath = {lineWidth:this.lineWidth, lineColor:this.lineColor, lineAlpha:this.lineAlpha, 
						fillColor:this.fillColor, fillAlpha:this.fillAlpha, fill:this.filling, 
						points:[x, y, radius, radius], type:Graphics.CIRC};
						
	this.graphicsData.push(this.currentPath);
	this.dirty = true;
}

/**
 * Draws an elipse.
 *
 * @method drawElipse
 * @param x {Number}
 * @param y {Number}
 * @param width {Number}
 * @param height {Number}
 */
public function drawElipse ( x, y, width, height)
{
	if(this.currentPath.points.length == 0)this.graphicsData.pop();
	
	this.currentPath = {lineWidth:this.lineWidth, lineColor:this.lineColor, lineAlpha:this.lineAlpha, 
						fillColor:this.fillColor, fillAlpha:this.fillAlpha, fill:this.filling, 
						points:[x, y, width, height], type:Graphics.ELIP};
						
	this.graphicsData.push(this.currentPath);
	this.dirty = true;
}

/**
 * Clears the graphics that were drawn to this Graphics object, and resets fill and line style settings.
 *
 * @method clear
 */
public function clear ()
{
	this.lineWidth = 0;
	this.filling = false;
	
	this.dirty = true;
	this.clearDirty = true;
	this.graphicsData = [];
}

// SOME TYPES:
//PIXI.Graphics.POLY = 0;
//PIXI.Graphics.RECT = 1;
//PIXI.Graphics.CIRC = 2;
//PIXI.Graphics.ELIP = 3;

}
