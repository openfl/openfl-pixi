package pixi.display;


import pixi.core.Matrix;
import pixi.core.Point;
import pixi.core.Rectangle;
import pixi.utils.Utils;
import pixi.InteractionManager;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class Stage extends DisplayObjectContainer {
	
	
	public var backgroundColor:Int;
	public var backgroundColorSplit:Array<Float>;
	public var backgroundColorString:String;
	
	/**
	 * Whether the stage is dirty and needs to have interactions updated
	 *
	 * @property dirty
	 * @type Boolean
	 * @private
	 */
	public var dirty:Bool;
	
	/**
	 * The interaction manage for this stage, manages all interactive activity on the stage
	 *
	 * @property interactive
	 * @type InteractionManager
	 */
	public var interactionManager:InteractionManager;
	
	public var _interactiveEventsAdded:Bool;
	private var __childrenAdded:Array<DisplayObject>;
	private var __childrenRemoved:Array<DisplayObject>;
	
	
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
	public function new (backgroundColor:Int, interactive:Bool = false) {
		
		super ();
		
		this.worldTransform = Mat3.create();
		this.interactive = interactive;
		this.interactionManager = new InteractionManager(this);
		
		this.dirty = true;
		
		this.__childrenAdded = [];
		this.__childrenRemoved = [];
		
		//the stage is it's own stage
		this.stage = #if openfl cast #end this;
		
		//optimize hit detection a bit
		this.stage.hitArea = new Rectangle(0,0,100000, 100000);
		
		this.setBackgroundColor(backgroundColor);
		this.worldVisible = true;
		
	}
	
	
	/**
	 * This will return the point containing global coords of the mouse.
	 *
	 * @method getMousePosition
	 * @return {Point} The point containing the coords of the global InteractionData position.
	 */
	public function getMousePosition ():Point {
		
		return this.interactionManager.mouse.global;
		
	}
	
	
	/**
	 * Sets the background color for the stage
	 *
	 * @method setBackgroundColor
	 * @param backgroundColor {Number} the color of the background, easiest way to pass this in is in hex format
	 *		like: 0xFFFFFF for white
	 */
	public function setBackgroundColor (backgroundColor = 0x000000):Void {
		
		this.backgroundColor = backgroundColor;
		this.backgroundColorSplit = Utils.HEXtoRGB(this.backgroundColor);
		var hex = StringTools.hex (this.backgroundColor, 6);
		hex = "000000".substr(0, 6 - hex.length) + hex;
		this.backgroundColorString = "#" + hex;
		
	}
	
	
	/*
	 * Updates the object transform for rendering
	 *
	 * @method updateTransform
	 * @private
	 */
	public override function updateTransform ():Void {
		
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
	
	
}