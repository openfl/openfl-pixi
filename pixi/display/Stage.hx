package pixi.display;


import pixi.core.Rectangle;
import pixi.core.Matrix;
import pixi.InteractionManager;
import pixi.utils.Utils;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */

/**
 * A Stage represents the root of the display tree. Everything connected to the stage is rendered
 *
 * @class Stage
 * @extends DisplayObjectContainer
 * @constructor
 * @param backgroundColor {Number} the background color of the stage, easiest way to pass this in is in hex format
 *		like: 0xFFFFFF for white
 * @param interactive {Boolean} enable / disable interaction (default is false)
 */
class Stage extends DisplayObjectContainer {
	
	public var backgroundColor:Int;
	public var backgroundColorSplit:Array<Float>;
	public var backgroundColorString:String;
	public var interactionManager:InteractionManager;
	public var dirty:Bool;
	private var __childrenAdded:Array<DisplayObject>;
	private var __childrenRemoved:Array<DisplayObject>;
	public var worldVisible:Bool;
	public var _interactiveEventsAdded:Bool;
	
public function new (backgroundColor:Int, interactive:Bool = false)
{
	super ();
	//PIXI.DisplayObjectContainer.call( this );

	/**
	 * [read-only] Current transform of the object based on world (parent) factors
	 *
	 * @property worldTransform
	 * @type Mat3
	 * @readOnly
	 * @private
	 */
	this.worldTransform = Mat3.create();

	/**
	 * Whether or not the stage is interactive
	 *
	 * @property interactive
	 * @type Boolean
	 */
	this.interactive = interactive;

	/**
	 * The interaction manage for this stage, manages all interactive activity on the stage
	 *
	 * @property interactive
	 * @type InteractionManager
	 */
	this.interactionManager = new InteractionManager(this);

	/**
	 * Whether the stage is dirty and needs to have interactions updated
	 *
	 * @property dirty
	 * @type Boolean
	 * @private
	 */
	this.dirty = true;

	this.__childrenAdded = [];
	this.__childrenRemoved = [];

	//the stage is it's own stage
	this.stage = this;

	//optimize hit detection a bit
	this.stage.hitArea = new Rectangle(0,0,100000, 100000);

	this.setBackgroundColor(backgroundColor);
	this.worldVisible = true;
}

// constructor
//PIXI.Stage.prototype = Object.create( PIXI.DisplayObjectContainer.prototype );
//PIXI.Stage.prototype.constructor = PIXI.Stage;

/*
 * Updates the object transform for rendering
 *
 * @method updateTransform
 * @private
 */
public override function updateTransform ()
{
	this.worldAlpha = 1;		
	
	var i = 0;
	var j = this.children.length;
	while (i<j)
	{
		this.children[i].updateTransform();	
		i++;
	}
	
	if(this.dirty)
	{
		this.dirty = false;
		// update interactive!
		this.interactionManager.dirty = true;
	}

	if(this.interactive)this.interactionManager.update();
}

/**
 * Sets the background color for the stage
 *
 * @method setBackgroundColor
 * @param backgroundColor {Number} the color of the background, easiest way to pass this in is in hex format
 *		like: 0xFFFFFF for white
 */
public function setBackgroundColor (backgroundColor = 0x000000)
{
	this.backgroundColor = backgroundColor;
	this.backgroundColorSplit = Utils.HEXtoRGB(this.backgroundColor);
	var hex = StringTools.hex (this.backgroundColor, 6);
	hex = "000000".substr(0, 6 - hex.length) + hex;
	this.backgroundColorString = "#" + hex;
}

/**
 * This will return the point containing global coords of the mouse.
 *
 * @method getMousePosition
 * @return {Point} The point containing the coords of the global InteractionData position.
 */
public function getMousePosition ()
{
	return this.interactionManager.mouse.global;
}


}