package pixi;


import js.Browser;
import pixi.core.Point;
import pixi.display.DisplayObject;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.display.Stage;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class InteractionManager {
	
	
	public var dirty:Bool;
	public var interactiveItems:Array<Dynamic>;
	public var last:Int;
	
	/**
	 * the mouse data
	 *
	 * @property mouse
	 * @type InteractionData
	 */
	public var mouse:InteractionData;
	public var mouseoverEnabled:Bool;
	public var pool:Array<Dynamic>;
	
	/**
	 * a reference to the stage
	 *
	 * @property stage
	 * @type Stage
	 */
	public var stage:Stage;
	public var tempPoint:Point;
	
	/**
	 * an object that stores current touches (InteractionData) by id reference
	 *
	 * @property touchs
	 * @type Object
	 */
	public var touchs:Dynamic;
	
	private var target:Dynamic;
	
	
	/**
	 * The interaction manager deals with mouse and touch events. Any DisplayObject can be interactive
	 * This manager also supports multitouch.
	 *
	 * @class InteractionManager
	 * @constructor
	 * @param stage {Stage} The stage to handle interactions
	 */
	public function new (stage:Stage) {
		
		this.stage = stage;
		this.mouse = new InteractionData();
		this.touchs = {};
		
		// helpers
		this.tempPoint = new Point();
		//this.tempMatrix =  mat3.create();
		
		this.mouseoverEnabled = true;
		
		//tiny little interactiveData pool!
		this.pool = [];
		
		this.interactiveItems = [];
		this.last = 0;
		
	}
	
	
	/**
	 * Collects an interactive sprite recursively to have their interactions managed
	 *
	 * @method collectInteractiveSprite
	 * @param displayObject {DisplayObject} the displayObject to collect
	 * @param iParent {DisplayObject}
	 * @private
	 */
	private function collectInteractiveSprite (displayObject:DisplayObjectContainer, iParent:DisplayObjectContainer):Void {
		
		var children = displayObject.children;
		var length = children.length;
		
		/// make an interaction tree... {item.__interactiveParent}
		var i = length-1;
		while (i >= 0)
		{
			var child = children[i];
			
			//if(child.visible) {
				// push all interactive bits
				if(child.interactive)
				{
					iParent.interactiveChildren = true;
					//child.__iParent = iParent;
					this.interactiveItems.push(child);
						
					if(Std.is (child, DisplayObjectContainer) && cast (child, DisplayObjectContainer).children.length > 0)
					{
						this.collectInteractiveSprite(cast child, cast child);
					}
				}
				else
				{
					child.__iParent = null;
					
					if(Std.is (child, DisplayObjectContainer) && cast (child, DisplayObjectContainer).children.length > 0)
					{
						this.collectInteractiveSprite(cast child, iParent);
					}
				}
			//}
			i--;
		}
		
	}
	
	
	/**
	 * Tests if the current mouse coords hit a sprite
	 *
	 * @method hitTest
	 * @param item {DisplayObject} The displayObject to test for a hit
	 * @param interactionData {InteractionData} The interactiondata object to update in the case of a hit
	 * @private
	 */
	private function hitTest (item:DisplayObject, interactionData:InteractionData):Bool {
		
		var global = interactionData.global;
		
		if(item.vcount != Pixi.visibleCount)return false;
		
		var isSprite = Std.is (item, Sprite),
			worldTransform = item.worldTransform,
			a00 = worldTransform[0], a01 = worldTransform[1], a02 = worldTransform[2],
			a10 = worldTransform[3], a11 = worldTransform[4], a12 = worldTransform[5],
			id = 1 / (a00 * a11 + a01 * -a10),
			x = a11 * id * global.x + -a01 * id * global.y + (a12 * a01 - a02 * a11) * id,
			y = a00 * id * global.y + -a10 * id * global.x + (-a12 * a00 + a02 * a10) * id;
			
		if (isSprite) interactionData.target = cast item;
		
		//a sprite or display object with a hit area defined
		if(item.hitArea != null && item.hitArea.contains != null) {
			if(item.hitArea.contains(x, y)) {
				//if(isSprite)
				if (isSprite) interactionData.target = cast item;
				
				return true;
			}
			
			return false;
		}
		// a sprite with no hitarea defined
		else if(isSprite)
		{
			var width = cast (item, Sprite).texture.frame.width,
				height = cast (item, Sprite).texture.frame.height,
				x1 = -width * cast (item, Sprite).anchor.x,
				y1;
			
			if(x > x1 && x < x1 + width)
			{
				y1 = -height * cast (item, Sprite).anchor.y;
			
				if(y > y1 && y < y1 + height)
				{
					// set the target property if a hit is true!
					interactionData.target = cast item;
					return true;
				}
			}
		}
		
		var length = cast (item, Sprite).children.length;
		
		for (i in 0...length)
		{
			var tempItem = cast (item, Sprite).children[i];
			var hit = this.hitTest(tempItem, interactionData);
			if(hit)
			{
				// hmm.. TODO SET CORRECT TARGET?
				interactionData.target = cast item;
				return true;
			}
		}
		
		return false;
		
	}
	
	
	/**
	 * Is called when the mouse button is pressed down on the renderer element
	 *
	 * @method onMouseDown
	 * @param event {Event} The DOM event of a mouse button being pressed down
	 * @private
	 */
	private function onMouseDown (event:Dynamic):Void {
		
		this.mouse.originalEvent = event != null ? event : Browser.window.event; //IE uses window.event
		
		// loop through inteaction tree...
		// hit test each item! -> 
		// get interactive items under point??
		//stage.__i
		var length = this.interactiveItems.length;
		var global = this.mouse.global;
		
		var index = 0;
		var parent = this.stage;
		
		// while 
		// hit test 
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			
			if(item.mousedown != null || item.click != null)
			{
				item.__mouseIsDown = true;
				item.__hit = this.hitTest(cast item, this.mouse);
				
				if(item.__hit != null)
				{
					//call the function!
					if(item.mousedown != null)item.mousedown(this.mouse);
					item.__isDown = true;
					
					// just the one!
					if(!item.interactiveChildren)break;
				}
			}
		}
		
	}
	
	
	/**
	 * Is called when the mouse moves accross the renderer element
	 *
	 * @method onMouseMove
	 * @param event {Event} The DOM event of the mouse moving
	 * @private
	 */
	private function onMouseMove (event:Dynamic):Void {
		
		this.mouse.originalEvent = event != null ? event : Browser.window.event; //IE uses window.event
		// TODO optimize by not check EVERY TIME! maybe half as often? //
		var rect = this.target.view.getBoundingClientRect();
		
		this.mouse.global.x = (event.clientX - rect.left) * (this.target.width / rect.width);
		this.mouse.global.y = (event.clientY - rect.top) * ( this.target.height / rect.height);
		
		var length = this.interactiveItems.length;
		var global = this.mouse.global;
		
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			
			if(item.mousemove != null)
			{
				//call the function!
				item.mousemove(this.mouse);
			}
		}
		
	}
	
	
	private function onMouseOut (event:Dynamic):Void {
		
		var length = this.interactiveItems.length;
		
		this.target.view.style.cursor = "default";	
		
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			
			if(item.__isOver)
			{
				this.mouse.target = cast item;
				if(item.mouseout != null)item.mouseout(this.mouse);
				item.__isOver = false;	
			}
		}
		
	}
	
	
	/**
	 * Is called when the mouse button is released on the renderer element
	 *
	 * @method onMouseUp
	 * @param event {Event} The DOM event of a mouse button being released
	 * @private
	 */
	private function onMouseUp (event:Dynamic):Void {
		
		this.mouse.originalEvent = event != null ? event : Browser.window.event; //IE uses window.event
		
		var global = this.mouse.global;
		
		var length = this.interactiveItems.length;
		var up = false;
		
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			
			if(item.mouseup != null || item.mouseupoutside != null || item.click != null)
			{
				item.__hit = this.hitTest(cast item, this.mouse);
				
				if(item.__hit && !up)
				{
					//call the function!
					if(item.mouseup != null)
					{
						item.mouseup(this.mouse);
					}
					if(item.__isDown != null)
					{
						if(item.click != null)item.click(this.mouse);
					}
					
					if(!item.interactiveChildren)up = true;
				}
				else
				{
					if(item.__isDown)
					{
						if(item.mouseupoutside != null)item.mouseupoutside(this.mouse);
					}
				}
			
				item.__isDown = false;	
			}
		}
		
	}
	
	
	/**
	 * Is called when a touch is ended on the renderer element
	 *
	 * @method onTouchEnd
	 * @param event {Event} The DOM event of a touch ending on the renderer view
	 * @private
	 */
	private function onTouchEnd (event:Dynamic):Void {
		
		//this.mouse.originalEvent = event || window.event; //IE uses window.event
		var rect = this.target.view.getBoundingClientRect();
		var changedTouches:Array<Dynamic> = cast event.changedTouches;
		
		for (i in 0...changedTouches.length) 
		{
			var touchEvent = changedTouches[i];
			var touchData:Dynamic = this.touchs[touchEvent.identifier];
			var up = false;
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top)  * (this.target.height / rect.height);
			
			var length = this.interactiveItems.length;
			for (j in 0...length)
			{
				var item = this.interactiveItems[j];
				var itemTouchData:Dynamic = item.__touchData; // <-- Here!
				item.__hit = this.hitTest(cast item, touchData);
				
				if(itemTouchData == touchData)
				{
					// so this one WAS down...
					touchData.originalEvent = event != null ? event : Browser.window.event;
					//touchData.originalEvent =  event || window.event;
					// hitTest??
					
					if(item.touchend != null || item.tap != null)
					{
						if(item.__hit && !up)
						{
							if(item.touchend != null)item.touchend(touchData);
							if(item.__isDown)
							{
								if(item.tap != null)item.tap(touchData);
							}
							
							if(!item.interactiveChildren)up = true;
						}
						else
						{
							if(item.__isDown)
							{
								if(item.touchendoutside != null)item.touchendoutside(touchData);
							}
						}
						
						item.__isDown = false;
					}
					
					item.__touchData = null;
						
				}
				else
				{
					
				}
			}
			// remove the touch..
			this.pool.push(touchData);
			this.touchs[touchEvent.identifier] = null;
		}
		
	}
	
	
	/**
	 * Is called when a touch is moved accross the renderer element
	 *
	 * @method onTouchMove
	 * @param event {Event} The DOM event of a touch moving accross the renderer view
	 * @private
	 */
	private function onTouchMove (event:Dynamic):Void {
		
		var rect = this.target.view.getBoundingClientRect();
		var changedTouches:Array<Dynamic> = cast event.changedTouches;
		var touchData:Dynamic = null;
		
		for (i in 0...changedTouches.length) 
		{
			var touchEvent = changedTouches[i];
			touchData = this.touchs[touchEvent.identifier];
			touchData.originalEvent = event != null ? event : Browser.window.event;
			
			// update the touch position
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top)  * (this.target.height / rect.height);
		}
		
		var length = this.interactiveItems.length;
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			if(item.touchmove != null)item.touchmove(touchData);
		}
		
	}
	
	
	/**
	 * Is called when a touch is started on the renderer element
	 *
	 * @method onTouchStart
	 * @param event {Event} The DOM event of a touch starting on the renderer view
	 * @private
	 */
	private function onTouchStart (event:Dynamic):Void {
		
		var rect = this.target.view.getBoundingClientRect();
		
		var changedTouches:Array<Dynamic> = cast event.changedTouches;
		for (i in 0...changedTouches.length) 
		{
			var touchEvent = changedTouches[i];
			
			var touchData:Dynamic = this.pool.pop();
			if(!touchData)touchData = new pixi.InteractionData();
			
			touchData.originalEvent =  event != null ? event : Browser.window.event;
			
			this.touchs[touchEvent.identifier] = touchData;
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top)  * (this.target.height / rect.height);
			
			var length = this.interactiveItems.length;
			
			for (j in 0...length)
			{
				var item = this.interactiveItems[j];
				
				if(item.touchstart != null || item.tap != null)
				{
					item.__hit = this.hitTest(cast item, touchData);
					
					if(item.__hit)
					{
						//call the function!
						if(item.touchstart != null)item.touchstart(touchData);
						item.__isDown = true;
						item.__touchData = touchData;
						
						if(!item.interactiveChildren)break;
					}
				}
			}
		}
		
	}
	
	
	/**
	 * Sets the target for event delegation
	 *
	 * @method setTarget
	 * @param target {WebGLRenderer|CanvasRenderer} the renderer to bind events to
	 * @private
	 */
	public function setTarget (target:Dynamic):Void {
		
		if (untyped __js__ ("window.navigator.msPointerEnabled")) 
		{
			// time to remove some of that zoom in ja..
			untyped __js__ ('target.view.style["-ms-content-zooming"] = "none"');
			untyped __js__ ('target.view.style["-ms-touch-action"] = "none"');
			
			// DO some window specific touch!
		}
		
		this.target = target;
		target.view.addEventListener('mousemove',  this.onMouseMove, true);
		target.view.addEventListener('mousedown',  this.onMouseDown, true);
		Browser.document.body.addEventListener('mouseup',  this.onMouseUp, true);
		target.view.addEventListener('mouseout',   this.onMouseOut, true);
		
		// aint no multi touch just yet!
		target.view.addEventListener("touchstart", this.onTouchStart, true);
		target.view.addEventListener("touchend", this.onTouchEnd, true);
		target.view.addEventListener("touchmove", this.onTouchMove, true);
		
	}
	
	
	/**
	 * updates the state of interactive objects
	 *
	 * @method update
	 * @private
	 */
	public function update ():Void {
		
		if(!this.target)return;
		
		// frequency of 30fps??
		var now = Date.now();
		var diff:Float = now.getDate () - this.last;
		diff = (diff * 30) / 1000;
		if(diff < 1)return;
		this.last = now.getDate ();
		//
		
		// ok.. so mouse events??
		// yes for now :)
		// OPTIMSE - how often to check??
		if(this.dirty)
		{
			this.dirty = false;
			
			var len = this.interactiveItems.length;
			
			for (i in 0...len) {
				this.interactiveItems[i].interactiveChildren = false;
			}
			
			this.interactiveItems = [];
			
			if(this.stage.interactive)this.interactiveItems.push(this.stage);
			// go through and collect all the objects that are interactive..
			this.collectInteractiveSprite(this.stage, this.stage);
		}
		
		// loop through interactive objects!
		var length = this.interactiveItems.length;
		
		this.target.view.style.cursor = "default";	
					
		for (i in 0...length)
		{
			var item = this.interactiveItems[i];
			
			//if(!item.visible)continue;
			
			// OPTIMISATION - only calculate every time if the mousemove function exists..
			// OK so.. does the object have any other interactive functions?
			// hit-test the clip!
			
			if(item.mouseover != null || item.mouseout != null || item.buttonMode)
			{
				// ok so there are some functions so lets hit test it..
				item.__hit = this.hitTest(cast item, this.mouse);
				this.mouse.target = cast item;
				// ok so deal with interactions..
				// loks like there was a hit!
				if(item.__hit != null)
				{
					if(item.buttonMode)this.target.view.style.cursor = "pointer";	
					
					if(!item.__isOver)
					{
						
						if(item.mouseover != null)item.mouseover(this.mouse);
						item.__isOver = true;	
					}
				}
				else
				{
					if(item.__isOver)
					{
						// roll out!
						if(item.mouseout != null)item.mouseout(this.mouse);
						item.__isOver = false;	
					}
				}
			}
			
			// --->
		}
		
	}
	
	
}




class InteractionData {
	
	
	/**
	 * This point stores the global coords of where the touch/mouse event happened
	 *
	 * @property global 
	 * @type Point
	 */
	public var global:Point;
	public var local:Point;
	
	/**
	 * When passed to an event handler, this will be the original DOM Event that was captured
	 *
	 * @property originalEvent
	 * @type Event
	 */
	public var originalEvent:Dynamic;
	
	/**
	 * The target Sprite that was interacted with
	 *
	 * @property target
	 * @type Sprite
	 */
	public var target:Sprite;
	
	
	/**
	 * Holds all information related to an Interaction event
	 *
	 * @class InteractionData
	 * @constructor
	 */
	public function new () {
		
		this.global = new Point();
		
		// this is here for legacy... but will remove
		this.local = new Point();
		
	}
	
	
	/**
	 * This will return the local coords of the specified displayObject for this InteractionData
	 *
	 * @method getLocalPosition
	 * @param displayObject {DisplayObject} The DisplayObject that you would like the local coords off
	 * @return {Point} A point containing the coords of the InteractionData position relative to the DisplayObject
	 */
	public function getLocalPosition (displayObject:DisplayObject):Point {
		
		var worldTransform = displayObject.worldTransform;
		var global = this.global;
		
		// do a cheeky transform to get the mouse coords;
		var a00 = worldTransform[0], a01 = worldTransform[1], a02 = worldTransform[2],
			a10 = worldTransform[3], a11 = worldTransform[4], a12 = worldTransform[5],
			id = 1 / (a00 * a11 + a01 * -a10);
		// set the mouse coords...
		return new Point(a11 * id * global.x + -a01 * id * global.y + (a12 * a01 - a02 * a11) * id,
					   a00 * id * global.y + -a10 * id * global.x + (-a12 * a00 + a02 * a10) * id);
	}
	
	
}