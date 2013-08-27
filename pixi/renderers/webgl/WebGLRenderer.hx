package pixi.renderers.webgl;


import js.html.webgl.GL;
import js.html.CanvasElement;
import js.Browser;
import pixi.core.Point;
import pixi.display.Stage;
import pixi.textures.BaseTexture;
import pixi.textures.Texture;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class WebGLRenderer {
	
	
	public var gl:GL;
	public static var projection:Point;
	
	public var batch:WebGLBatch;
	public var contextLost:Bool;
	public var height:Int;
	public var stageRenderGroup:WebGLRenderGroup;
	public var transparent:Bool;
	public var view:CanvasElement;
	public var width:Int;
	
	private var batchs:Array<WebGLBatch>;
	private var __stage:Stage;
	
	
	/**
	 * the WebGLRenderer is draws the stage and all its content onto a webGL enabled canvas. This renderer
	 * should be used for browsers support webGL. This Render works by automatically managing webGLBatchs.
	 * So no need for Sprite Batch's or Sprite Cloud's
	 * Dont forget to add the view to your DOM or you will not see anything :)
	 *
	 * @class WebGLRenderer
	 * @constructor
	 * @param width=0 {Number} the width of the canvas view
	 * @param height=0 {Number} the height of the canvas view
	 * @param view {Canvas} the canvas to use as a view, optional
	 * @param transparent=false {Boolean} the transparency of the render view, default false
	 * @param antialias=false {Boolean} sets antialias (only applicable in chrome at the moment)
	 * 
	 */
	public function new (width:Int = 800, height:Int = 600, view:CanvasElement = null, transparent:Bool = false, antialias:Bool = false) {
		
		// do a catch.. only 1 webGL renderer..
		
		this.transparent = transparent;
		
		this.width = width;
		this.height = height;
		
		if (view == null) {
			
			view = cast Browser.document.createElement ("canvas");
			
		}
		
		this.view = view; 
		this.view.width = this.width;
		this.view.height = this.height;
		
		this.view.addEventListener('webglcontextlost', handleContextLost, false);
		this.view.addEventListener('webglcontextrestored', handleContextRestored, false);
		
		this.batchs = [];
		
		try 
	 	{
			Pixi.gl = this.gl = untyped __js__('this.view.getContext("experimental-webgl",  {  	
				 alpha: this.transparent,
				 antialias: antialias, // SPEED UP??
				 premultipliedAlpha:false,
				 stencil:true
			})');
		} 
		catch (e:Dynamic) 
		{
			throw (" This browser does not support webGL. Try using the canvas renderer" + this);
		}

		WebGLShaders.initPrimitiveShader();
		WebGLShaders.initDefaultShader();
		WebGLShaders.initDefaultStripShader();

		WebGLShaders.activateDefaultShader();

		//var gl = this.gl;
		//WebGLRenderer.gl = gl;

		this.batch = new WebGLBatch(gl);
	   	gl.disable(GL.DEPTH_TEST);
	   	gl.disable(GL.CULL_FACE);

		gl.enable(GL.BLEND);
		gl.colorMask(true, true, true, this.transparent); 

		projection = new Point(400, 300);

		this.resize(this.width, this.height);
		this.contextLost = false;

		this.stageRenderGroup = new WebGLRenderGroup(this.gl);
		
	}
	
	
	/**
	 * Destroys a loaded webgl texture
	 *
	 * @method destroyTexture
	 * @param texture {Texture} The texture to update
	 * @private
	 */
	private static function destroyTexture (texture:BaseTexture):Void {
		
		//TODO break this out into a texture manager...
		var gl = Pixi.gl;

		if(texture._glTexture != null)
		{
			texture._glTexture = cast gl.createTexture();
			//gl.deleteTexture(GL.TEXTURE_2D, texture._glTexture);
			gl.deleteTexture(texture._glTexture);
		}
		
	}
	
	
	/**
	 * Gets a new WebGLBatch from the pool
	 *
	 * @static
	 * @method getBatch
	 * @return {WebGLBatch}
	 * @private 
	 */
	public static function getBatch ():WebGLBatch {
		
		if(WebGLBatch._batchs.length == 0)
		{
			return new WebGLBatch(Pixi.gl);
		}
		else
		{
			return WebGLBatch._batchs.pop();
		}
		
	}
	
	
	/**
	 * Handles a lost webgl context
	 *
	 * @method handleContextLost
	 * @param event {Event}
	 * @private
	 */
	public function handleContextLost (event:Dynamic):Void {
		
		event.preventDefault();
		this.contextLost = true;
		
	}
	
	
	/**
	 * Handles a restored webgl context
	 *
	 * @method handleContextRestored
	 * @param event {Event}
	 * @private
	 */
	public function handleContextRestored (event:Dynamic):Void {
		
		this.gl = untyped __js__('this.view.getContext("experimental-webgl",  {  	
			alpha: true
		})');
		
		//this.initShaders();	
		
		for(key in Pixi.TextureCache.keys ()) 
		{
				var texture = Pixi.TextureCache.get (key).baseTexture;
				texture._glTexture = null;
				WebGLRenderer.updateTexture(texture);
		};
		
		for (i in 0...this.batchs.length) 
		{
			this.batchs[i].restoreLostContext(this.gl);
			this.batchs[i].dirty = true;
		};
		
		WebGLBatch._restoreBatchs(this.gl);
		
		this.contextLost = false;
	}
	
	
	/**
	 * Renders the stage to its webGL view
	 *
	 * @method render
	 * @param stage {Stage} the Stage element to be rendered
	 */
	public function render (stage:Stage):Void {
		
		if(this.contextLost)return;
		
		// if rendering a new stage clear the batchs..
		if(this.__stage != stage)
		{
			// TODO make this work
			// dont think this is needed any more?
			this.__stage = stage;
			this.stageRenderGroup.setRenderable(stage);
		}
		
		// TODO not needed now... 
		// update children if need be
		// best to remove first!
		/*for (var i=0; i < stage.__childrenRemoved.length; i++)
		{
			var group = stage.__childrenRemoved[i].__renderGroup
			if(group)group.removeDisplayObject(stage.__childrenRemoved[i]);
		}*/
		
		// update any textures	
		WebGLRenderer.updateTextures();
			
		// update the scene graph	
		Pixi.visibleCount++;
		stage.updateTransform();
		
		var gl = this.gl;
		
		// -- Does this need to be set every frame? -- //
		gl.colorMask(true, true, true, this.transparent); 
		gl.viewport(0, 0, this.width, this.height);	
		
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		
		gl.clearColor(stage.backgroundColorSplit[0],stage.backgroundColorSplit[1],stage.backgroundColorSplit[2], this.transparent ? 0 : 1);	 
		gl.clear(GL.COLOR_BUFFER_BIT);
		
		// HACK TO TEST
		
		this.stageRenderGroup.backgroundColor = stage.backgroundColorSplit;
		this.stageRenderGroup.render(WebGLRenderer.projection);
		
		// interaction
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
		
		// after rendering lets confirm all frames that have been uodated..
		if(Texture.frameUpdates.length > 0)
		{
			for (i in 0...Texture.frameUpdates.length) 
			{
			  	Texture.frameUpdates[i].updateFrame = false;
			};
			
			Texture.frameUpdates = [];
		}
		
	}
	
	
	/**
	 * resizes the webGL view to the specified width and height
	 *
	 * @method resize
	 * @param width {Number} the new width of the webGL view
	 * @param height {Number} the new height of the webGL view
	 */
	public function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
		this.view.width = width;
		this.view.height = height;
		
		this.gl.viewport(0, 0, this.width, this.height);	
		
		//var projectionMatrix = this.projectionMatrix;
		
		WebGLRenderer.projection.x =  this.width/2;
		WebGLRenderer.projection.y =  this.height/2;
		
		//projectionMatrix[0] = 2/this.width;
		//projectionMatrix[5] = -2/this.height;
		//projectionMatrix[12] = -1;
		//projectionMatrix[13] = 1;
		
	}
	
	
	/**
	 * Puts a batch back into the pool
	 *
	 * @static
	 * @method returnBatch
	 * @param batch {WebGLBatch} The batch to return
	 * @private
	 */
	public static function returnBatch (batch:WebGLBatch):Void {
		
		batch.clean();	
		WebGLBatch._batchs.push(batch);
		
	}
	
	
	/**
	 * Updates a loaded webgl texture
	 *
	 * @static
	 * @method updateTexture
	 * @param texture {Texture} The texture to update
	 * @private
	 */
	public static function updateTexture (texture:BaseTexture):Void {
		
		//TODO break this out into a texture manager...
		var gl = Pixi.gl;
		
		if(texture._glTexture == null)
		{
			texture._glTexture = gl.createTexture();
		}
		
		if(texture.hasLoaded)
		{
			gl.bindTexture(GL.TEXTURE_2D, texture._glTexture);
		 	gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
		 	
			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, texture.source);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
			
			// reguler...
			
			if(!texture._powerOf2)
			{
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			}
			else
			{
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
			}
			
			gl.bindTexture(GL.TEXTURE_2D, null);
		}
		
	}
	
	
	/**
	 * Updates the textures loaded into this webgl renderer
	 *
	 * @static
	 * @method updateTextures
	 * @private
	 */
	public static function updateTextures ():Void {
		
		//TODO break this out into a texture manager...
		for (i in 0...Pixi.texturesToUpdate.length) WebGLRenderer.updateTexture(Pixi.texturesToUpdate[i]);
		for (i in 0...Pixi.texturesToDestroy.length) WebGLRenderer.destroyTexture(Pixi.texturesToDestroy[i]);
		Pixi.texturesToUpdate = [];
		Pixi.texturesToDestroy = [];
		
	}
	
	
}