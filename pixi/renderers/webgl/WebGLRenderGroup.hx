package pixi.renderers.webgl;


import js.html.webgl.GL;
import js.html.webgl.Shader;
import js.html.Float32Array;
import js.html.Uint16Array;
import pixi.core.Matrix;
import pixi.core.Point;
import pixi.display.DisplayObject;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.extras.CustomRenderable;
import pixi.extras.Strip;
import pixi.extras.TilingSprite;
import pixi.filters.FilterBlock;
import pixi.primitives.Graphics;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class WebGLRenderGroup {
	
	
	public var backgroundColor:Array<Float>;
	public var batchs:Array<Dynamic>;
	public var gl:GL;
	public var root:Dynamic;
	public var shaderProgram:Shader;
	public var toRemove:Array<Dynamic>;
	
	
	/**
	 * A WebGLBatch Enables a group of sprites to be drawn using the same settings.
	 * if a group of sprites all have the same baseTexture and blendMode then they can be
	 * grouped into a batch. All the sprites in a batch can then be drawn in one go by the
	 * GPU which is hugely efficient. ALL sprites in the webGL renderer are added to a batch
	 * even if the batch only contains one sprite. Batching is handled automatically by the
	 * webGL renderer. A good tip is: the smaller the number of batchs there are, the faster
	 * the webGL renderer will run.
	 *
	 * @class WebGLBatch
	 * @contructor
	 * @param gl {WebGLContext} An instance of the webGL context
	 */
	public function new (gl:GL) {
		
		this.gl = gl;
		this.root;
		
		this.backgroundColor;
		this.batchs = [];
		this.toRemove = [];
		
	}
	
	
	/**
	 * Adds a display object and children to the webgl context
	 *
	 * @method addDisplayObjectAndChildren
	 * @param displayObject {DisplayObject}
	 * @private
	 */
	private function addDisplayObjectAndChildren (displayObject:DisplayObject):Void {
		
		if(displayObject.__renderGroup)displayObject.__renderGroup.removeDisplayObjectAndChildren(displayObject);
		
		/*
		 *  LOOK FOR THE PREVIOUS RENDERABLE
		 *  This part looks for the closest previous sprite that can go into a batch
		 *  It keeps going back until it finds a sprite or the stage
		 */
		
		var previousRenderable:Dynamic = displayObject.first;
		while(previousRenderable != this.root.first)
		{
			previousRenderable = previousRenderable._iPrev;
			if(previousRenderable.renderable && previousRenderable.__renderGroup)break;
		}
		
		/*
		 *  LOOK FOR THE NEXT SPRITE
		 *  This part looks for the closest next sprite that can go into a batch
		 *  it keeps looking until it finds a sprite or gets to the end of the display
		 *  scene graph
		 */
		var nextRenderable:Dynamic = displayObject.last;
		while(nextRenderable._iNext != null)
		{
			nextRenderable = nextRenderable._iNext;
			if(nextRenderable.renderable && nextRenderable.__renderGroup)break;
		}
		
		// one the display object hits this. we can break the loop	
		
		var tempObject:Dynamic = displayObject.first;
		var testObject:Dynamic = displayObject.last._iNext;
		do	
		{
			tempObject.__renderGroup = this;
			
			if(tempObject.renderable)
			{
			
				this.insertObject(tempObject, previousRenderable, nextRenderable);
				previousRenderable = tempObject;
			}
			
			tempObject = tempObject._iNext;
		}
		while(tempObject != testObject);
		
	}
	
	
	/**
	 * Adds filter blocks
	 *
	 * @method addFilterBlocks
	 * @param start {FilterBlock}
	 * @param end {FilterBlock}
	 * @private
	 */
	private function addFilterBlocks (start:FilterBlock, end:FilterBlock):Void {
		
		start.__renderGroup = this;
		end.__renderGroup = this;
		/*
		 *  LOOK FOR THE PREVIOUS RENDERABLE
		 *  This part looks for the closest previous sprite that can go into a batch
		 *  It keeps going back until it finds a sprite or the stage
		 */
		var previousRenderable:Dynamic = start;
		while(previousRenderable != this.root)
		{
			previousRenderable = previousRenderable._iPrev;
			if(previousRenderable.renderable && previousRenderable.__renderGroup)break;
		}
		this.insertAfter(start, previousRenderable);
		
		/*
		 *  LOOK FOR THE NEXT SPRITE
		 *  This part looks for the closest next sprite that can go into a batch
		 *  it keeps looking until it finds a sprite or gets to the end of the display
		 *  scene graph
		 */
		var previousRenderable2:Dynamic = end;
		while(previousRenderable2 != this.root)
		{
			previousRenderable2 = previousRenderable2._iPrev;
			if(previousRenderable2.renderable && previousRenderable2.__renderGroup)break;
		}
		this.insertAfter(end, previousRenderable2);
		
	}
	
	
	/**
	 * Renders the stage to its webgl view
	 *
	 * @method handleFilter
	 * @param filter {FilterBlock}
	 * @private
	 */
	private function handleFilter (filter:FilterBlock, projection:Point):Void {
		
		
		
	}
	
	
	/**
	 * Initializes a strip to be rendered
	 *
	 * @method initStrip
	 * @param strip {Strip} The strip to initialize
	 * @private
	 */
	private function initStrip (strip:Strip):Void {
		
		// build the strip!
		var gl = this.gl;
		var shaderProgram = this.shaderProgram;
		
		strip._vertexBuffer = gl.createBuffer();
		strip._indexBuffer = gl.createBuffer();
		strip._uvBuffer = gl.createBuffer();
		strip._colorBuffer = gl.createBuffer();
		
		gl.bindBuffer(GL.ARRAY_BUFFER, strip._vertexBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, strip.verticies, GL.DYNAMIC_DRAW);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, strip._uvBuffer);
		gl.bufferData(GL.ARRAY_BUFFER,  strip.uvs, GL.STATIC_DRAW);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, strip._colorBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, strip.colors, GL.STATIC_DRAW);
		
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, strip._indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, strip.indices, GL.STATIC_DRAW);
		
	}
	
	
	/**
	 * Initializes a tiling sprite
	 *
	 * @method initTilingSprite
	 * @param sprite {TilingSprite} The tiling sprite to initialize
	 * @private
	 */
	private function initTilingSprite (sprite:TilingSprite):Void {
		
		var gl = this.gl;
		
		// make the texture tilable..
		
		sprite.verticies = new Float32Array([0, 0,
											  sprite.width, 0,
											  sprite.width,  sprite.height,
											 0,  sprite.height]);
		
		sprite.uvs = new Float32Array([0, 0,
										1, 0,
										1, 1,
										0, 1]);
					
		sprite.colors = new Float32Array([1,1,1,1]);
		
		sprite.indices =  new Uint16Array([0, 1, 3,2]); //, 2]);
		
		sprite._vertexBuffer = gl.createBuffer();
		sprite._indexBuffer = gl.createBuffer();
		sprite._uvBuffer = gl.createBuffer();
		sprite._colorBuffer = gl.createBuffer();
		
		gl.bindBuffer(GL.ARRAY_BUFFER, sprite._vertexBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, sprite.verticies, GL.STATIC_DRAW);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, sprite._uvBuffer);
		gl.bufferData(GL.ARRAY_BUFFER,  sprite.uvs, GL.DYNAMIC_DRAW);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, sprite._colorBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, sprite.colors, GL.STATIC_DRAW);
		
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, sprite._indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, sprite.indices, GL.STATIC_DRAW);
		
		//return ( (x > 0) && ((x & (x - 1)) == 0) );
		
		if(sprite.texture.baseTexture._glTexture != null)
		{
			gl.bindTexture(GL.TEXTURE_2D, sprite.texture.baseTexture._glTexture);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
			sprite.texture.baseTexture._powerOf2 = true;
		}
		else
		{
			sprite.texture.baseTexture._powerOf2 = true;
		}
		
	}
	
	
	/**
	 * Inserts a displayObject into the linked list
	 *
	 * @method insertAfter
	 * @param item {DisplayObject}
	 * @param displayObject {DisplayObject} The object to insert
	 * @private
	 */
	private function insertAfter (item:Dynamic, displayObject:DisplayObject):Void {
		
		if(Std.is (displayObject, Sprite))
		{
			var previousBatch:Dynamic = cast (displayObject, Sprite).batch;
			
			if(previousBatch != null)
			{
				// so this object is in a batch!
				
				// is it not? need to split the batch
				if(previousBatch.tail == displayObject)
				{
					// is it tail? insert in to batchs	
					var index = -1;
					for (i in 0...this.batchs.length) {
						if (this.batchs[i] == previousBatch) index = i;
					}
					this.batchs.insert(index+1, item);
				}
				else
				{
					// TODO MODIFY ADD / REMOVE CHILD TO ACCOUNT FOR FILTERS (also get prev and next) //
					
					// THERE IS A SPLIT IN THIS BATCH! //
					var splitBatch = previousBatch.split(displayObject.__next);
					
					// COOL!
					// add it back into the array	
					/*
					 * OOPS!
					 * seems the new sprite is in the middle of a batch
					 * lets split it.. 
					 */
					var index = -1;
					for (i in 0...this.batchs.length) {
						if (this.batchs[i] == previousBatch) index = i;
					}
					this.batchs.insert(index+1, item);
					this.batchs.insert(index+2, splitBatch);
				}
			}
			else
			{
				this.batchs.push(item);
			}
		}
		else
		{
			var index = -1;
			for (i in 0...this.batchs.length) {
				if (this.batchs[i] == displayObject) index = i;
			}
			this.batchs.insert(index+1, item);
		}
		
	}
	
	
	/**
	 * Inserts a displayObject into the linked list
	 *
	 * @method insertObject
	 * @param displayObject {DisplayObject}
	 * @param previousObject {DisplayObject}
	 * @param nextObject {DisplayObject}
	 * @private
	 */
	private function insertObject (displayObject:DisplayObject, previousObject:DisplayObject, nextObject:DisplayObject):Void {
		
		// while looping below THE OBJECT MAY NOT HAVE BEEN ADDED
		var previousSprite:Dynamic = previousObject;
		var nextSprite:Dynamic = nextObject;
		
		/*
		 * so now we have the next renderable and the previous renderable
		 * 
		 */
		if(Std.is (displayObject, Sprite))
		{
			var previousBatch:Dynamic;
			var nextBatch:Dynamic;
			
			if(Std.is (previousSprite, Sprite))
			{
				previousBatch = previousSprite.batch;
				if(previousBatch != null)
				{
					if(previousBatch.texture == cast (displayObject, Sprite).texture.baseTexture && previousBatch.blendMode == cast (displayObject, Sprite).blendMode)
					{
						previousBatch.insertAfter(displayObject, previousSprite);
						return;
					}
				}
			}
			else
			{
				// TODO reword!
				previousBatch = previousSprite;
			}
			
			if(nextSprite != null)
			{
				if(Std.is (nextSprite, Sprite))
				{
					nextBatch = nextSprite.batch;
					
					//batch may not exist if item was added to the display list but not to the webGL
					if(nextBatch != null)
					{
						if(nextBatch.texture == cast (displayObject, Sprite).texture.baseTexture && nextBatch.blendMode == cast (displayObject, Sprite).blendMode)
						{
							nextBatch.insertBefore(displayObject, nextSprite);
							return;
						}
						else
						{
							if(nextBatch == previousBatch)
							{
								// THERE IS A SPLIT IN THIS BATCH! //
								var splitBatch = previousBatch.split(nextSprite);
								// COOL!
								// add it back into the array	
								/*
								 * OOPS!
								 * seems the new sprite is in the middle of a batch
								 * lets split it.. 
								 */
								var batch = WebGLRenderer.getBatch();
								
								var index = -1;
								for (i in 0...batchs.length) {
									if (batchs[i] == previousBatch) index = i;
								}
								
								batch.init(cast displayObject);
								
								this.batchs.insert (index+1, batch);
								this.batchs.insert (index+2, splitBatch);
								return;
								
							}
						}
					}
				}
				else
				{
					// TODO re-word!
					
					nextBatch = nextSprite;
				}
			}
			
			/*
			 * looks like it does not belong to any batch!
			 * but is also not intersecting one..
			 * time to create anew one!
			 */
			
			var batch =  WebGLRenderer.getBatch();
			batch.init(cast displayObject);
			
			if(previousBatch != null) // if this is invalid it means 
			{
				var index = -1;
				for (i in 0...this.batchs.length) {
					if (this.batchs[i] == previousBatch) index = i;
				}
				this.batchs.insert(index+1, batch);
			}
			else
			{
				this.batchs.push(batch);
			}
			
			return;
			
		}
		else if(Std.is (displayObject, TilingSprite))
		{
			// add to a batch!!
			this.initTilingSprite(cast displayObject);
		//	this.batchs.push(displayObject);
			
		}
		else if(Std.is (displayObject, Strip))
		{
			// add to a batch!!
			this.initStrip(cast displayObject);
		//	this.batchs.push(displayObject);
		}
		else if(displayObject != null)// instanceof PIXI.Graphics)
		{
			//displayObject.initWebGL(this);
			
			// add to a batch!!
			//this.initStrip(displayObject);
			//this.batchs.push(displayObject);
		}
		
		this.insertAfter(displayObject, previousSprite);
		
		// insert and SPLIT!
		
	}
	
	
	/**
	 * Removes a display object and children to the webgl context
	 *
	 * @method removeDisplayObjectAndChildren
	 * @param displayObject {DisplayObject}
	 * @private
	 */
	private function removeDisplayObjectAndChildren (displayObject:DisplayObject):Void {
		
		if(displayObject.__renderGroup != this)return;
			
		//var displayObject = displayObject.first;
		var lastObject = displayObject.last;
		do	
		{
			displayObject.__renderGroup = null;
			if(displayObject.renderable)this.removeObject(displayObject);
			displayObject = displayObject._iNext;
		}
		while(displayObject != null);
		
	}
	
	
	/**
	 * Remove filter blocks
	 *
	 * @method removeFilterBlocks
	 * @param start {FilterBlock}
	 * @param end {FilterBlock}
	 * @private
	 */
	private function removeFilterBlocks (start:FilterBlock, end:FilterBlock):Void {
		
		this.removeObject(start);
		this.removeObject(end);
		
	}
	
	
	/**
	 * Removes a displayObject from the linked list
	 *
	 * @method removeObject
	 * @param displayObject {DisplayObject} The object to remove
	 * @private
	 */
	private function removeObject (displayObject:Dynamic):Void {
		
		// loop through children..
		// display object //
		
		// add a child from the render group..
		// remove it and all its children!
		//displayObject.cacheVisible = false;//displayObject.visible;
		
		/*
		 * removing is a lot quicker..
		 * 
		 */
		var batchToRemove:Dynamic = null;
		
		if(Std.is (displayObject, Sprite))
		{
			// should always have a batch!
			var batch:Dynamic = cast (displayObject, Sprite).batch;
			if(batch == null)return; // this means the display list has been altered befre rendering
			
			batch.remove(displayObject);
			
			if(batch.size==0)
			{
				batchToRemove = batch;
			}
		}
		else
		{
			batchToRemove = displayObject;
		}
		
		/*
		 * Looks like there is somthing that needs removing!
		 */
		if(batchToRemove != null)	
		{
			var index = -1;
			for (i in 0...this.batchs.length) {
				if (this.batchs[i] == batchToRemove) index = i;
			}
			if(index == -1)return;// this means it was added then removed before rendered
			
			// ok so.. check to see if you adjacent batchs should be joined.
			// TODO may optimise?
			if(index == 0 || index == this.batchs.length-1)
			{
				// wha - eva! just get of the empty batch!
				this.batchs.splice(index, 1);
				if(Std.is (batchToRemove, WebGLBatch))WebGLRenderer.returnBatch(batchToRemove);
			
				return;
			}
			
			if(Std.is (this.batchs[index-1], WebGLBatch) && Std.is(this.batchs[index+1], WebGLBatch))
			{
				if(this.batchs[index-1].texture == this.batchs[index+1].texture && this.batchs[index-1].blendMode == this.batchs[index+1].blendMode)
				{
					//console.log("MERGE")
					this.batchs[index-1].merge(this.batchs[index+1]);
					
					if(Std.is (batchToRemove, WebGLBatch))WebGLRenderer.returnBatch(batchToRemove);
					WebGLRenderer.returnBatch(this.batchs[index+1]);
					this.batchs.splice(index, 2);
					return;
				}
			}
			
			this.batchs.splice(index, 1);
			if(Std.is (batchToRemove, WebGLBatch)) WebGLRenderer.returnBatch(batchToRemove);
		}
	}
	
	
	/**
	 * Renders the stage to its webgl view
	 *
	 * @method render
	 * @param projection {Object}
	 */
	public function render (projection:Point):Void {
		
		WebGLRenderer.updateTextures();
		
		var gl = this.gl;
		
		gl.uniform2f(untyped (WebGLShaders.shaderProgram).projectionVector, projection.x, projection.y);
		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
		
		// will render all the elements in the group
		var renderable:DisplayObject;
		
		for (i in 0...this.batchs.length) 
		{
			renderable = this.batchs[i];
			if(Std.is (renderable, WebGLBatch))
			{
				this.batchs[i].render();
				continue;
			}
			
			// non sprite batch..
			var worldVisible = (renderable.vcount == Pixi.visibleCount);
			
			if(Std.is (renderable, TilingSprite))
			{
				if(worldVisible)this.renderTilingSprite(cast renderable, projection);
			}
			else if(Std.is (renderable, Strip))
			{
				if(worldVisible)this.renderStrip(cast renderable, projection);
			}
			else if(Std.is (renderable, Graphics))
			{
				if(worldVisible && renderable.renderable) WebGLGraphics.renderGraphics(cast renderable, projection);//, projectionMatrix);
			}
			else if(Std.is (renderable, FilterBlock))
			{
				/*
				 * for now only masks are supported..
				 */
				if(cast (renderable, FilterBlock).open)
				{
					gl.enable(GL.STENCIL_TEST);
					
					gl.colorMask(false, false, false, false);
					gl.stencilFunc(GL.ALWAYS,1,0xff);
					gl.stencilOp(GL.KEEP,GL.KEEP,GL.REPLACE);
					
					WebGLGraphics.renderGraphics(cast (renderable, FilterBlock).mask, projection);
					
					gl.colorMask(true, true, true, false);
					gl.stencilFunc(GL.NOTEQUAL,0,0xff);
					gl.stencilOp(GL.KEEP,GL.KEEP,GL.KEEP);
				}
				else
				{
					gl.disable(GL.STENCIL_TEST);
				}
			}
		}
		
	}
	
	
	/**
	 * Renders a specific renderable
	 *
	 * @method renderSpecial
	 * @param renderable {DisplayObject}
	 * @param projection {Object}
	 * @private
	 */
	private function renderSpecial (renderable:DisplayObject, projection:Point):Void {
		
		var worldVisible = (renderable.vcount == Pixi.visibleCount);
		
		if(Std.is (renderable, TilingSprite))
		{
			if(worldVisible)this.renderTilingSprite(cast renderable, projection);
		}
		else if(Std.is (renderable, Strip))
		{
			if(worldVisible)this.renderStrip(cast renderable, projection);
		}
		else if(Std.is (renderable, CustomRenderable))
		{
			if(worldVisible) cast (renderable, CustomRenderable).renderWebGL(this, projection);
		}
		else if(Std.is (renderable, Graphics))
		{
			if(worldVisible && renderable.renderable) WebGLGraphics.renderGraphics(cast renderable, projection);
		}
		else if(Std.is (renderable, FilterBlock))
		{
			/*
			 * for now only masks are supported..
			 */
			 
			var gl = Pixi.gl;
			
			if(cast (renderable, FilterBlock).open)
			{
				gl.enable(GL.STENCIL_TEST);
				
				gl.colorMask(false, false, false, false);
				gl.stencilFunc(GL.ALWAYS,1,0xff);
				gl.stencilOp(GL.KEEP,GL.KEEP,GL.REPLACE);
				
				WebGLGraphics.renderGraphics(cast (renderable, FilterBlock).mask, projection);
				
				// we know this is a render texture so enable alpha too..
				gl.colorMask(true, true, true, true);
				gl.stencilFunc(GL.NOTEQUAL,0,0xff);
				gl.stencilOp(GL.KEEP,GL.KEEP,GL.KEEP);
			}
			else
			{
				gl.disable(GL.STENCIL_TEST);
			}
		}
		
	}
	
	
	/**
	 * Renders a specific displayObject
	 *
	 * @method renderSpecific
	 * @param displayObject {DisplayObject}
	 * @param projection {Object}
	 * @private
	 */
	private function renderSpecific (displayObject:DisplayObject, projection:Point):Void {
		
		WebGLRenderer.updateTextures();
		
		var gl = this.gl;
		
		gl.uniform2f(untyped (WebGLShaders.shaderProgram).projectionVector, projection.x, projection.y);
		
		// to do!
		// render part of the scene...
		
		var startIndex = -1;
		var startBatchIndex = -1;
		
		var endIndex = -1;
		var endBatchIndex = -1;
		
		/*
		 *  LOOK FOR THE NEXT SPRITE
		 *  This part looks for the closest next sprite that can go into a batch
		 *  it keeps looking until it finds a sprite or gets to the end of the display
		 *  scene graph
		 */
		var nextRenderable:Dynamic = displayObject.first;
		while(nextRenderable._iNext != null)
		{
			nextRenderable = nextRenderable._iNext;
			if(nextRenderable.renderable && nextRenderable.__renderGroup)break;
		}
		var startBatch:Dynamic = nextRenderable.batch;
		
		if(Std.is (nextRenderable, Sprite))
		{
			startBatch = nextRenderable.batch;
			
			var head:Dynamic = startBatch.head;
			var next = head;
			
			// ok now we have the batch.. need to find the start index!
			if(head == nextRenderable)
			{
				startIndex = 0;
			}
			else
			{
				startIndex = 1;
				
				while(head.__next != nextRenderable)
				{
					startIndex++;
					head = head.__next;
				}
			}
		}
		else
		{
			startBatch = nextRenderable;
		}
		
		// Get the LAST renderable object
		var lastRenderable = displayObject;
		var endBatch:Dynamic;
		var lastItem = displayObject;
		while(Std.is (lastItem, DisplayObjectContainer) && cast (lastItem, DisplayObjectContainer).children.length > 0)
		{
			lastItem = cast (lastItem, DisplayObjectContainer).children[cast (lastItem, DisplayObjectContainer).children.length-1];
			if(lastItem.renderable)lastRenderable = lastItem;
		}
		
		if(Std.is (lastRenderable, Sprite))
		{
			endBatch = cast(lastRenderable, Sprite).batch;
			
			var head = endBatch.head;
			
			if(head == lastRenderable)
			{
				endIndex = 0;
			}
			else
			{
				endIndex = 1;
				
				while(head.__next != lastRenderable)
				{
					endIndex++;
					head = head.__next;
				}
			}
		}
		else
		{
			endBatch = lastRenderable;
		}
		
		// TODO - need to fold this up a bit!
		
		if(startBatch == endBatch)
		{
			if(Std.is (startBatch, WebGLBatch))
			{
				startBatch.render(startIndex, endIndex+1);
			}
			else
			{
				this.renderSpecial(startBatch, projection);
			}
			return;
		}
		
		// now we have first and last!
		startBatchIndex = -1;
		endBatchIndex = -1;
		for (i in 0...this.batchs.length) {
			if (this.batchs[i] == startBatch) startBatchIndex = i;
			if (this.batchs[i] == endBatch) endBatchIndex = i;
		}
		
		// DO the first batch
		if(Std.is (startBatch, WebGLBatch))
		{
			startBatch.render(startIndex);
		}
		else
		{
			this.renderSpecial(startBatch, projection);
		}
		
		// DO the middle batchs..
		for (i in (startBatchIndex+1)...endBatchIndex) 
		{
			var renderable = this.batchs[i];
		
			if(Std.is (renderable, WebGLBatch))
			{
				this.batchs[i].render();
			}
			else
			{
				this.renderSpecial(renderable, projection);
			}
		}
		
		// DO the last batch..
		if(Std.is (endBatch, WebGLBatch))
		{
			endBatch.render(0, endIndex+1);
		}
		else
		{
			this.renderSpecial(endBatch, projection);
		}
		
	}
	
	
	/**
	 * Renders a Strip
	 *
	 * @method renderStrip
	 * @param strip {Strip} The strip to render
	 * @param projection {Object}
	 * @private
	 */
	private function renderStrip (strip:Strip, projection:Point):Void {
		
		var gl = this.gl;
		var shaderProgram = WebGLShaders.shaderProgram;
		//	mat
		//var mat4Real = PIXI.mat3.toMat4(strip.worldTransform);
		//PIXI.mat4.transpose(mat4Real);
		//PIXI.mat4.multiply(projectionMatrix, mat4Real, mat4Real )
		
		gl.useProgram(WebGLShaders.stripShaderProgram);
		
		var m = Mat3.clone(strip.worldTransform);
		
		Mat3.transpose(m);
		
		// set the matrix transform for the 
	 	gl.uniformMatrix3fv(untyped (WebGLShaders.stripShaderProgram).translationMatrix, false, m);
		gl.uniform2f(untyped (WebGLShaders.stripShaderProgram).projectionVector, projection.x, projection.y);
		gl.uniform1f(untyped (WebGLShaders.stripShaderProgram).alpha, strip.worldAlpha);
		
		/*
		if(strip.blendMode == PIXI.blendModes.NORMAL)
		{
			gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
		}
		else
		{
			gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_COLOR);
		}
		*/
		
		if(!strip.dirty)
		{
			
			gl.bindBuffer(GL.ARRAY_BUFFER, strip._vertexBuffer);
			gl.bufferSubData(GL.ARRAY_BUFFER, 0, strip.verticies);
			gl.vertexAttribPointer(untyped (shaderProgram).vertexPositionAttribute, 2, GL.FLOAT, false, 0, 0);
			
			// update the uvs
		   	gl.bindBuffer(GL.ARRAY_BUFFER, strip._uvBuffer);
			gl.vertexAttribPointer(untyped (shaderProgram).textureCoordAttribute, 2, GL.FLOAT, false, 0, 0);
			
			gl.activeTexture(GL.TEXTURE0);
			gl.bindTexture(GL.TEXTURE_2D, strip.texture.baseTexture._glTexture);
			
			gl.bindBuffer(GL.ARRAY_BUFFER, strip._colorBuffer);
			gl.vertexAttribPointer(untyped (shaderProgram).colorAttribute, 1, GL.FLOAT, false, 0, 0);
			
			// dont need to upload!
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, strip._indexBuffer);
			
		}
		else
		{
			strip.dirty = false;
			gl.bindBuffer(GL.ARRAY_BUFFER, strip._vertexBuffer);
			gl.bufferData(GL.ARRAY_BUFFER, strip.verticies, GL.STATIC_DRAW);
			gl.vertexAttribPointer(untyped (shaderProgram).vertexPositionAttribute, 2, GL.FLOAT, false, 0, 0);
			
			// update the uvs
		   	gl.bindBuffer(GL.ARRAY_BUFFER, strip._uvBuffer);
		   	gl.bufferData(GL.ARRAY_BUFFER, strip.uvs, GL.STATIC_DRAW);
			gl.vertexAttribPointer(untyped (shaderProgram).textureCoordAttribute, 2, GL.FLOAT, false, 0, 0);
			
			gl.activeTexture(GL.TEXTURE0);
			gl.bindTexture(GL.TEXTURE_2D, strip.texture.baseTexture._glTexture);
			
			gl.bindBuffer(GL.ARRAY_BUFFER, strip._colorBuffer);
			gl.bufferData(GL.ARRAY_BUFFER, strip.colors, GL.STATIC_DRAW);
			gl.vertexAttribPointer(untyped (shaderProgram).colorAttribute, 1, GL.FLOAT, false, 0, 0);
			
			// dont need to upload!
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, strip._indexBuffer);
			gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, strip.indices, GL.STATIC_DRAW);
			
		}
		//console.log(GL.TRIANGLE_STRIP);
		
		gl.drawElements(GL.TRIANGLE_STRIP, strip.indices.length, GL.UNSIGNED_SHORT, 0);
		
	  	gl.useProgram(WebGLShaders.shaderProgram);
	  	
	}
	
	
	/**
	 * Renders a TilingSprite
	 *
	 * @method renderTilingSprite
	 * @param sprite {TilingSprite} The tiling sprite to render
	 * @param projectionMatrix {Object}
	 * @private
	 */
	private function renderTilingSprite (sprite:TilingSprite, projectionMatrix:Point):Void {
		
		var gl = this.gl;
		var shaderProgram = WebGLShaders.shaderProgram;
		
		var tilePosition = sprite.tilePosition;
		var tileScale = sprite.tileScale;
		
		var offsetX =  tilePosition.x/sprite.texture.baseTexture.width;
		var offsetY =  tilePosition.y/sprite.texture.baseTexture.height;
		
		var scaleX =  (sprite.width / sprite.texture.baseTexture.width)  / tileScale.x;
		var scaleY =  (sprite.height / sprite.texture.baseTexture.height) / tileScale.y;
		
		sprite.uvs[0] = 0 - offsetX;
		sprite.uvs[1] = 0 - offsetY;
		
		sprite.uvs[2] = (1 * scaleX)  -offsetX;
		sprite.uvs[3] = 0 - offsetY;
		
		sprite.uvs[4] = (1 *scaleX) - offsetX;
		sprite.uvs[5] = (1 *scaleY) - offsetY;
		
		sprite.uvs[6] = 0 - offsetX;
		sprite.uvs[7] = (1 *scaleY) - offsetY;
		
		gl.bindBuffer(GL.ARRAY_BUFFER, sprite._uvBuffer);
		gl.bufferSubData(GL.ARRAY_BUFFER, 0, sprite.uvs);
		
		this.renderStrip(cast sprite, projectionMatrix);
		
	}
	
	
	/**
	 * Add a display object to the webgl renderer
	 *
	 * @method setRenderable
	 * @param displayObject {DisplayObject}
	 * @private 
	 */
	public function setRenderable (displayObject:DisplayObject):Void {
		
		// has this changed??
		if(this.root)this.removeDisplayObjectAndChildren(this.root);
		
		displayObject.worldVisible = displayObject.visible;
		
		// soooooo //
		// to check if any batchs exist already??
		
		// TODO what if its already has an object? should remove it
		this.root = displayObject;
		this.addDisplayObjectAndChildren(displayObject);
		
	}
	
	
	/**
	 * Updates a webgl texture
	 *
	 * @method updateTexture
	 * @param displayObject {DisplayObject}
	 * @private
	 */
	private function updateTexture (displayObject:DisplayObject):Void {
		
		// TODO definitely can optimse this function..
		
		this.removeObject(displayObject);
		
		/*
		 *  LOOK FOR THE PREVIOUS RENDERABLE
		 *  This part looks for the closest previous sprite that can go into a batch
		 *  It keeps going back until it finds a sprite or the stage
		 */
		var previousRenderable:Dynamic = displayObject.first;
		while(previousRenderable != this.root)
		{
			previousRenderable = previousRenderable._iPrev;
			if(previousRenderable.renderable && previousRenderable.__renderGroup)break;
		}
		
		/*
		 *  LOOK FOR THE NEXT SPRITE
		 *  This part looks for the closest next sprite that can go into a batch
		 *  it keeps looking until it finds a sprite or gets to the end of the display
		 *  scene graph
		 */
		var nextRenderable:Dynamic = displayObject.last;
		while(nextRenderable._iNext)
		{
			nextRenderable = nextRenderable._iNext;
			if(nextRenderable.renderable && nextRenderable.__renderGroup)break;
		}
		
		this.insertObject(displayObject, previousRenderable, nextRenderable);
		
	}
	
	
}