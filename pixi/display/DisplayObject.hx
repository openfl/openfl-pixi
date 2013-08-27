package pixi.display;


import pixi.core.Matrix;
import pixi.core.Point;
import pixi.filters.FilterBlock;
import pixi.primitives.Graphics;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class DisplayObject {
	
	
	/**
	 * The opacity of the object.
	 *
	 * @property alpha
	 * @type Number
	 */	
	public var alpha:Float;
	
	/**
	 * This is used to indicate if the displayObject should display a mouse hand cursor on rollover
	 *
	 * @property buttonMode
	 * @type Boolean
	 */
	public var buttonMode:Bool;
	
	/**
	 * [NYI] Unkown
	 *
	 * @property color
	 * @type Array<>
	 * @private
	 */
	public var color:Array<Dynamic>;
	
	
	
	/**
	 * This is the defined area that will pick up mouse / touch events. It is null by default.
	 * Setting it is a neat way of optimising the hitTest function that the interactionManager will use (as it will not need to hit test all the children)
	 *
	 * @property hitArea
	 * @type Rectangle|Circle|Ellipse|Polygon
	 */	
	public var hitArea:Dynamic;
	
	/**
	 * Indicates if the sprite will have touch and mouse interactivity. It is false by default
	 *
	 * @property interactive
	 * @type Boolean
	 * @default false
	 */
	public var interactive (get, null):Bool;
	
	/**
	 * [read-only] Current transform of the object locally
	 *
	 * @property localTransform
	 * @type Mat3
	 * @readOnly
	 * @private
	 */
	public var localTransform (default, null):Matrix;
	
	/**
	 * Sets a mask for the displayObject. A mask is an object that limits the visibility of an object to the shape of the mask applied to it.
	 * In PIXI a regular mask must be a PIXI.Ggraphics object. This allows for much faster masking in canvas as it utilises shape clipping.
	 * To remove a mask, set this property to null.
	 *
	 * @property mask
	 * @type Graphics
	 */
	public var mask (get, set):Graphics;
	
	/**
	 * [read-only] The display object container that contains this display object.
	 *
	 * @property parent
	 * @type DisplayObjectContainer
	 * @readOnly
	 */	
	public var parent:DisplayObjectContainer;
	
	/**
	 * The pivot point of the displayObject that it rotates around
	 *
	 * @property pivot
	 * @type Point
	 */
	public var pivot:Point;
	
	/**
	 * The coordinate of the object relative to the local coordinates of the parent.
	 *
	 * @property position
	 * @type Point
	 */
	public var position:Point;
	
	/**
	 * Can this object be rendered
	 *
	 * @property renderable
	 * @type Boolean
	 */
	public var renderable:Bool;
	
	/**
	 * The rotation of the object in radians.
	 *
	 * @property rotation
	 * @type Number
	 */
	public var rotation:Float;
	
	/**
	 * The scale factor of the object.
	 *
	 * @property scale
	 * @type Point
	 */
	public var scale:Point;
	
	/**
	 * [read-only] The stage the display object is connected to, or undefined if it is not connected to the stage.
	 *
	 * @property stage
	 * @type Stage
	 * @readOnly
	 */	
	public var stage:Stage;
	
	/**
	 * The visibility of the object.
	 *
	 * @property visible
	 * @type Boolean
	 */	
	public var visible:Bool;
	
	/**
	 * [read-only] The multiplied alpha of the displayobject
	 *
	 * @property worldAlpha
	 * @type Number
	 * @readOnly
	 */
	public var worldAlpha:Float;
	
	/**
	 * [read-only] Current transform of the object based on world (parent) factors
	 *
	 * @property worldTransform
	 * @type Mat3
	 * @readOnly
	 * @private
	 */
	public var worldTransform (default, null):Matrix;
	public var worldVisible:Bool;
	
	/**
	 * [NYI] Holds whether or not this object is dynamic, for rendering optimization
	 *
	 * @property dynamic
	 * @type Boolean
	 * @private
	 */
	private var isDynamic:Bool;
	
	private var rotationCache:Float;
	private var _cr:Float;
	private var _interactive:Bool;
	private var _mask:Graphics;
	private var _sr:Float;
	
	private var filter:Bool;
	public var first:Dynamic;
	public var last:Dynamic;
	public var vcount:Int;
	public var _iNext:Dynamic;
	public var __next:Dynamic;
	public var __prev:Dynamic;
	public var __iParent:DisplayObjectContainer;
	public var __renderGroup:Dynamic;
	
	
	/**
	 * The base class for all objects that are rendered on the screen.
	 *
	 * @class DisplayObject
	 * @constructor
	 */
	public function new () {
		
		this.last = this;
		this.first = this;
		this.position = new Point();
		this.scale = new Point(1,1);//{x:1, y:1};
		this.pivot = new Point(0,0);
		this.rotation = 0;
		this.alpha = 1;
		this.visible = true;
		this.hitArea = null;
		this.buttonMode = false;
		this.renderable = false;
		this.parent = null;
		this.stage = null;
		this.worldAlpha = 1;
		this._interactive = false;
		this.worldTransform = Mat3.create();//mat3.identity();
		this.localTransform = Mat3.create();//mat3.identity();
		this.color = [];
		this.isDynamic = true;
		
		// chach that puppy!
		this._sr = 0;
		this._cr = 1;
		
		/*
		 * MOUSE Callbacks
		 */
		
		/**
		 * A callback that is used when the users clicks on the displayObject with their mouse
		 * @method click
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user clicks the mouse down over the sprite
		 * @method mousedown
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user releases the mouse that was over the displayObject
		 * for this callback to be fired the mouse must have been pressed down over the displayObject
		 * @method mouseup
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user releases the mouse that was over the displayObject but is no longer over the displayObject
		 * for this callback to be fired, The touch must have started over the displayObject
		 * @method mouseupoutside
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the users mouse rolls over the displayObject
		 * @method mouseover
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the users mouse leaves the displayObject
		 * @method mouseout
		 * @param interactionData {InteractionData}
		 */
		
		
		/*
		 * TOUCH Callbacks
		 */
		
		/**
		 * A callback that is used when the users taps on the sprite with their finger
		 * basically a touch version of click
		 * @method tap
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user touch's over the displayObject
		 * @method touchstart
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user releases a touch over the displayObject
		 * @method touchend
		 * @param interactionData {InteractionData}
		 */
		
		/**
		 * A callback that is used when the user releases the touch that was over the displayObject
		 * for this callback to be fired, The touch must have started over the sprite
		 * @method touchendoutside
		 * @param interactionData {InteractionData}
		 */
	}
	
	
	/*
	 * Adds a filter to this displayObject
	 *
	 * @method addFilter
	 * @param mask {Graphics} the graphics object to use as a filter
	 * @private
	 */
	private function addFilter (mask:Graphics):Void {
		
		if(this.filter)return;
		this.filter = true;
		
		// insert a filter block..
		var start = new FilterBlock();
		var end = new FilterBlock();
		
		start.mask = mask;
		end.mask = mask;
		
		start.first = start.last = this;
		end.first = end.last = this;
		
		start.open = true;
		
		/*
		 * insert start
		 */
		
		var childFirst = start;
		var childLast = start;
		var nextObject:Dynamic;
		var previousObject:Dynamic;
			
		previousObject = this.first._iPrev;
		
		if(previousObject != null)
		{
			nextObject = previousObject._iNext;
			childFirst._iPrev = previousObject;
			previousObject._iNext = childFirst;		
		}
		else
		{
			nextObject = this;
		}	
		
		if(nextObject != null)
		{
			nextObject._iPrev = childLast;
			childLast._iNext = nextObject;
		}
		
		// now insert the end filter block..
		
		/*
		 * insert end filter
		 */
		var childFirst = end;
		var childLast = end;
		var nextObject = null;
		var previousObject = null;
			
		previousObject = this.last;
		nextObject = previousObject._iNext;
		
		if(nextObject != null)
		{
			nextObject._iPrev = childLast;
			childLast._iNext = nextObject;
		}
		
		childFirst._iPrev = previousObject;
		previousObject._iNext = childFirst;	
		
		var updateLast = this;
		
		var prevLast = this.last;
		while(updateLast != null)
		{
			if(updateLast.last == prevLast)
			{
				updateLast.last = end;
			}
			updateLast = updateLast.parent;
		}
		
		this.first = start;
		
		// if webGL...
		if(this.__renderGroup != null)
		{
			this.__renderGroup.addFilterBlocks(start, end);
		}
		
		mask.renderable = false;
		
	}
	
	
	/*
	 * Removes the filter to this displayObject
	 *
	 * @method removeFilter
	 * @private
	 */
	private function removeFilter ():Void {
		
		if(!this.filter)return;
		this.filter = false;
		
		// modify the list..
		var startBlock = this.first;
		
		var nextObject:Dynamic = startBlock._iNext;
		var previousObject:Dynamic = startBlock._iPrev;
			
		if(nextObject != null)nextObject._iPrev = previousObject;
		if(previousObject != null)previousObject._iNext = nextObject;		
		
		this.first = startBlock._iNext;
		
		// remove the end filter
		var lastBlock = this.last;
		
		var nextObject:Dynamic = lastBlock._iNext;
		var previousObject:Dynamic = lastBlock._iPrev;
			
		if(nextObject != null)nextObject._iPrev = previousObject;
		previousObject._iNext = nextObject;		
		
		// this is always true too!
		var tempLast =  lastBlock._iPrev;	
		// need to make sure the parents last is updated too
		var updateLast = this;
		while(updateLast.last == lastBlock)
		{
			updateLast.last = tempLast;
			updateLast = updateLast.parent;
			if(updateLast == null)break;
		}
		
		var mask = startBlock.mask;
		mask.renderable = true;
		
		// if webGL...
		if(this.__renderGroup != null)
		{
			this.__renderGroup.removeFilterBlocks(startBlock, lastBlock);
		}
		
	}
	
	
	/**
	 * [Deprecated] Indicates if the sprite will have touch and mouse interactivity. It is false by default
	 * Instead of using this function you can now simply set the interactive property to true or false
	 *
	 * @method setInteractive
	 * @param interactive {Boolean}
	 * @deprecated Simply set the `interactive` property directly
	 */
	public function setInteractive (interactive:Bool):Void {
		
		this.interactive = interactive;
		
	}
	
	
	/*
	 * Updates the object transform for rendering
	 *
	 * @method updateTransform
	 * @private
	 */
	private function updateTransform ():Void {
		
		// TODO OPTIMIZE THIS!! with dirty
		if(this.rotation != this.rotationCache)
		{
			this.rotationCache = this.rotation;
			this._sr =  Math.sin(this.rotation);
			this._cr =  Math.cos(this.rotation);
		}	
		
		var localTransform = this.localTransform;
		var parentTransform = this.parent.worldTransform;
		var worldTransform = this.worldTransform;
		//console.log(localTransform)
		localTransform[0] = this._cr * this.scale.x;
		localTransform[1] = -this._sr * this.scale.y;
		localTransform[3] = this._sr * this.scale.x;
		localTransform[4] = this._cr * this.scale.y;
		
		// TODO --> do we even need a local matrix???
		
		var px = this.pivot.x;
		var py = this.pivot.y;
		
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = localTransform[0], a01 = localTransform[1], a02 = this.position.x - localTransform[0] * px - py * localTransform[1],
			a10 = localTransform[3], a11 = localTransform[4], a12 = this.position.y - localTransform[4] * py - px * localTransform[3],
			
			b00 = parentTransform[0], b01 = parentTransform[1], b02 = parentTransform[2],
			b10 = parentTransform[3], b11 = parentTransform[4], b12 = parentTransform[5];
		
		localTransform[2] = a02;
		localTransform[5] = a12;
		
		worldTransform[0] = b00 * a00 + b01 * a10;
		worldTransform[1] = b00 * a01 + b01 * a11;
		worldTransform[2] = b00 * a02 + b01 * a12 + b02;
		
		worldTransform[3] = b10 * a00 + b11 * a10;
		worldTransform[4] = b10 * a01 + b11 * a11;
		worldTransform[5] = b10 * a02 + b11 * a12 + b12;
		
		// because we are using affine transformation, we can optimise the matrix concatenation process.. wooo!
		// mat3.multiply(this.localTransform, this.parent.worldTransform, this.worldTransform);
		this.worldAlpha = this.alpha * this.parent.worldAlpha;
		
		this.vcount = Pixi.visibleCount;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_interactive ():Bool {
		
		return this._interactive;
		
	}
	
	private function set_interactive (value:Bool):Bool {
		
		this._interactive = value;
		
		// TODO more to be done here..
		// need to sort out a re-crawl!
		if(this.stage != null)this.stage.dirty = true;
		
		return value;
		
	}
	
	
	private function get_mask ():Graphics {
		
		return this._mask;
	}
	
	private function set_mask (value:Graphics):Graphics {
		
		this._mask = value;
		
		if(value != null)
		{
			this.addFilter(value);
		}
		else
		{
			this.removeFilter();
		}
		
		return value;
		
	}
	
	
}