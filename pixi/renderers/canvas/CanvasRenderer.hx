package pixi.renderers.canvas;


import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import pixi.display.DisplayObject;
import pixi.display.Sprite;
import pixi.display.Stage;
import pixi.extras.CustomRenderable;
import pixi.extras.Strip;
import pixi.extras.TilingSprite;
import pixi.filters.FilterBlock;
import pixi.primitives.Graphics;
import pixi.textures.Texture;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 # @author Joshua Granick
 */
class CanvasRenderer {
	
	
	/**
	 * The canvas context that the everything is drawn to
	 * @property context
	 * @type Canvas 2d Context
	 */
	public var context:CanvasRenderingContext2D;
	public var count:Int;
	
	/**
	 * The height of the canvas view
	 *
	 * @property height
	 * @type Number
	 * @default 600
	 */
	public var height:Int;
	public var refresh:Bool;
	public var transparent:Bool;
	
	/**
	 * The canvas element that the everything is drawn to
	 *
	 * @property view
	 * @type Canvas
	 */
	public var view:CanvasElement;
	
	/**
	 * The width of the canvas view
	 *
	 * @property width
	 * @type Number
	 * @default 800
	 */
	public var width:Int;
	
	
	/**
	 * the CanvasRenderer draws the stage and all its content onto a 2d canvas. This renderer should be used for browsers that do not support webGL.
	 * Dont forget to add the view to your DOM or you will not see anything :)
	 *
	 * @class CanvasRenderer
	 * @constructor
	 * @param width=0 {Number} the width of the canvas view
	 * @param height=0 {Number} the height of the canvas view
	 * @param view {Canvas} the canvas to use as a view, optional
	 * @param transparent=false {Boolean} the transparency of the render view, default false
	 */
	public function new (width:Int = 800, height:Int = 600, view:Dynamic = null, transparent:Bool = false) {
		
		this.transparent = transparent;
		this.width = width;
		this.height = height;

		if (view == null) {
			
			view = js.Browser.document.createElement ("canvas");
			
		}
		this.view = view;
		this.context = this.view.getContext ("2d");
		this.refresh = true;
		
		// hack to enable some hardware acceleration!
		//this.view.style["transform"] = "translatez(0)";
		
	    this.view.width = this.width;
		this.view.height = this.height;  
		this.count = 0;
		
	}
	
	
	/**
	 * Renders the stage to its canvas view
	 *
	 * @method render
	 * @param stage {Stage} the Stage element to be rendered
	 */
	public function render (stage:Stage):Void {
		
		//stage.__childrenAdded = [];
		//stage.__childrenRemoved = [];
		
		// update textures if need be
		Pixi.texturesToUpdate = [];
		Pixi.texturesToDestroy = [];
		
		Pixi.visibleCount++;
		stage.updateTransform();
		
		// update the background color
		if(this.view.style.backgroundColor!=stage.backgroundColorString && !this.transparent)this.view.style.backgroundColor = stage.backgroundColorString;
		
		this.context.setTransform(1,0,0,1,0,0); 
		this.context.clearRect(0, 0, this.width, this.height);
		this.renderDisplayObject(stage);
		//as
		
		// run interaction!
		if(stage.interactive)
		{
			//need to add some events!
			if(!stage._interactiveEventsAdded)
			{
				stage._interactiveEventsAdded = true;
				stage.interactionManager.setTarget(this);
			}
		}
		
		// remove frame updates..
		if(Texture.frameUpdates.length > 0)
		{
			Texture.frameUpdates = [];
		}
		
		
	}
	
	
	/**
	 * Renders a display object
	 *
	 * @method renderDisplayObject
	 * @param displayObject {DisplayObject} The displayObject to render
	 * @private
	 */
	private function renderDisplayObject (displayObject:DisplayObject):Void {
		
		// no loger recurrsive!
		var transform;
		var context = this.context;
		
		context.globalCompositeOperation = 'source-over';
		
		// one the display object hits this. we can break the loop	
		var testObject:Dynamic = displayObject.last._iNext;
		displayObject = displayObject.first;
		
		do
		{
			transform = displayObject.worldTransform;
			
			if(!displayObject.visible)
			{
				displayObject = displayObject.last._iNext;
				continue;
			}
			
			if(!displayObject.renderable)
			{
				displayObject = displayObject._iNext;
				continue;
			}
			
			if(Std.is (displayObject, Sprite))
			{
				
				var frame = cast (displayObject, Sprite).texture.frame;
				
				if(frame != null)
				{
					context.globalAlpha = cast (displayObject, Sprite).worldAlpha;
					
					context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
						
					context.drawImage(cast (displayObject, Sprite).texture.baseTexture.source, 
									frame.x,
									frame.y,
									frame.width,
									frame.height,
									(cast (displayObject, Sprite).anchor.x) * -frame.width, 
									(cast (displayObject, Sprite).anchor.y) * -frame.height,
									frame.width,
									frame.height);
				}					   
			}
			else if(Std.is (displayObject, Strip))
			{
				context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
				this.renderStrip(cast displayObject);
			}
			else if(Std.is (displayObject, TilingSprite))
			{
				context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
				this.renderTilingSprite(cast displayObject);
			}
			else if(Std.is (displayObject, CustomRenderable))
			{
				cast (displayObject, CustomRenderable).renderCanvas(this);
			}
			else if(Std.is (displayObject, Graphics))
			{
				context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
				CanvasGraphics.renderGraphics(cast displayObject, cast context);
			}
			else if(Std.is (displayObject, FilterBlock))
			{
				if(cast (displayObject, FilterBlock).open)
				{
					context.save();
					
					var cacheAlpha = displayObject.mask.alpha;
					var maskTransform = displayObject.mask.worldTransform;
					
					context.setTransform(maskTransform[0], maskTransform[3], maskTransform[1], maskTransform[4], maskTransform[2], maskTransform[5]);
					
					displayObject.mask.worldAlpha = 0.5;
					
					untyped __js__("context.worldAlpha = 0");
					
					CanvasGraphics.renderGraphicsMask(displayObject.mask, cast context);
					context.clip();
					
					displayObject.mask.worldAlpha = cacheAlpha;
				}
				else
				{
					context.restore();
				}
			}
		//	count++
			displayObject = displayObject._iNext;
			
			
		}
		while(displayObject != testObject);
		
	}
	
	
	/**
	 * Renders a strip
	 *
	 * @method renderStrip
	 * @param strip {Strip} The Strip to render
	 * @private
	 */
	private function renderStrip (strip:Strip):Void {
		
		var context = this.context;
		
		// draw triangles!!
		var verticies = strip.verticies;
		var uvs = strip.uvs;
		
		var length = verticies.length/2;
		this.count++;
		var i = 1;
		while (i < length - 2)
		{
			// draw some triangles!
			var index = i*2;
			
			var x0 = verticies[index],   x1 = verticies[index+2], x2 = verticies[index+4];
			var y0 = verticies[index+1], y1 = verticies[index+3], y2 = verticies[index+5];
			
			var u0 = uvs[index] * strip.texture.width,   u1 = uvs[index+2] * strip.texture.width, u2 = uvs[index+4]* strip.texture.width;
			var v0 = uvs[index+1]* strip.texture.height, v1 = uvs[index+3] * strip.texture.height, v2 = uvs[index+5]* strip.texture.height;
			
			context.save();
			context.beginPath();
			context.moveTo(x0, y0);
			context.lineTo(x1, y1);
			context.lineTo(x2, y2);
			context.closePath();
			
			context.clip();
			
			// Compute matrix transform
			var delta = u0*v1 + v0*u2 + u1*v2 - v1*u2 - v0*u1 - u0*v2;
			var delta_a = x0*v1 + v0*x2 + x1*v2 - v1*x2 - v0*x1 - x0*v2;
			var delta_b = u0*x1 + x0*u2 + u1*x2 - x1*u2 - x0*u1 - u0*x2;
			var delta_c = u0*v1*x2 + v0*x1*u2 + x0*u1*v2 - x0*v1*u2 - v0*u1*x2 - u0*x1*v2;
			var delta_d = y0*v1 + v0*y2 + y1*v2 - v1*y2 - v0*y1 - y0*v2;
			var delta_e = u0*y1 + y0*u2 + u1*y2 - y1*u2 - y0*u1 - u0*y2;
			var delta_f = u0*v1*y2 + v0*y1*u2 + y0*u1*v2 - y0*v1*u2 - v0*u1*y2 - u0*y1*v2;
			
			context.transform(delta_a/delta, delta_d/delta,
							delta_b/delta, delta_e/delta,
							delta_c/delta, delta_f/delta);
			
			context.drawImage(strip.texture.baseTexture.source, 0, 0);
			context.restore();
			
			i++;
			
		}
		
	}
	
	
	/**
	 * Renders a flat strip
	 *
	 * @method renderStripFlat
	 * @param strip {Strip} The Strip to render
	 * @private
	 */
	private function renderStripFlat (strip:Strip):Void {
		
		var context = this.context;
		var verticies = strip.verticies;
		var uvs = strip.uvs;
		
		var length = verticies.length/2;
		this.count++;
		
		context.beginPath();
		var i = 1;
		while (i < length - 2)
		{
			
			// draw some triangles!
			var index = i*2;
			
			 var x0 = verticies[index],   x1 = verticies[index+2], x2 = verticies[index+4];
	 		 var y0 = verticies[index+1], y1 = verticies[index+3], y2 = verticies[index+5];
	 		 
			context.moveTo(x0, y0);
			context.lineTo(x1, y1);
			context.lineTo(x2, y2);
			i++;
			
		};	
		
		context.fillStyle = "#FF0000";
		context.fill();
		context.closePath();
		
	}
	
	
	/**
	 * Renders a tiling sprite
	 *
	 * @method renderTilingSprite
	 * @param sprite {TilingSprite} The tilingsprite to render
	 * @private
	 */
	private function renderTilingSprite (sprite:TilingSprite):Void {
		
		var context = this.context;
		
		context.globalAlpha = sprite.worldAlpha;
		
	 	if(sprite.__tilePattern == null) sprite.__tilePattern = context.createPattern(sprite.texture.baseTexture.source, "repeat");
	 	
		context.beginPath();
		
		var tilePosition = sprite.tilePosition;
		var tileScale = sprite.tileScale;
		
		// offset
		context.scale(tileScale.x,tileScale.y);
		context.translate(tilePosition.x, tilePosition.y);
			
		context.fillStyle = sprite.__tilePattern;
		context.fillRect(-tilePosition.x,-tilePosition.y,sprite.width / tileScale.x, sprite.height / tileScale.y);
		
		context.scale(1/tileScale.x, 1/tileScale.y);
		context.translate(-tilePosition.x, -tilePosition.y);
		
		context.closePath();
		
	}
	
	
	/**
	 * resizes the canvas view to the specified width and height
	 *
	 * @method resize
	 * @param width {Number} the new width of the canvas view
	 * @param height {Number} the new height of the canvas view
	 */
	public function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
		this.view.width = width;
		this.view.height = height;
		
	}
	
	
}