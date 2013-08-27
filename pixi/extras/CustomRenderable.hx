package pixi.extras;


import pixi.display.DisplayObject;
import pixi.renderers.canvas.CanvasRenderer;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class CustomRenderable extends DisplayObject {
	
	
	/**
	 * This object is one that will allow you to specify custom rendering functions based on render type
	 *
	 * @class CustomRenderable 
	 * @extends DisplayObject
	 * @constructor
	 */
	public function new () {
		
		super ();
		
	}
	
	
	/**
	 * If this object is being rendered by a WebGLRenderer it will call this callback to initialize
	 *
	 * @method initWebGL
	 * @param renderer {WebGLRenderer} The renderer instance
	 */
	public function initWebGL (renderer) {
		
		// override!
		
	}
	
	
	/**
	 * If this object is being rendered by a CanvasRenderer it will call this callback
	 *
	 * @method renderCanvas
	 * @param renderer {CanvasRenderer} The renderer instance
	 */
	public function renderCanvas (renderer:CanvasRenderer):Void {
		
		// override!
		
	}
	
	
	/**
	 * If this object is being rendered by a WebGLRenderer it will call this callback
	 *
	 * @method renderWebGL
	 * @param renderer {WebGLRenderer} The renderer instance
	 */
	public function renderWebGL (renderGroup, projectionMatrix) {
		
		// not sure if both needed? but ya have for now!
		// override!
		
	}
	
	
}