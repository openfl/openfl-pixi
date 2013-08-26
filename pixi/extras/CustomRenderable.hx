package pixi.extras;


import pixi.display.DisplayObject;

/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */


/**
 * This object is one that will allow you to specify custom rendering functions based on render type
 *
 * @class CustomRenderable 
 * @extends DisplayObject
 * @constructor
 */
class CustomRenderable extends DisplayObject {
	
public function new ()
{
	//PIXI.DisplayObject.call( this );
	super ();
}

// constructor
//PIXI.CustomRenderable.prototype = Object.create( PIXI.DisplayObject.prototype );
//PIXI.CustomRenderable.prototype.constructor = PIXI.CustomRenderable;

/**
 * If this object is being rendered by a CanvasRenderer it will call this callback
 *
 * @method renderCanvas
 * @param renderer {CanvasRenderer} The renderer instance
 */
public function renderCanvas (renderer)
{
	// override!
}

/**
 * If this object is being rendered by a WebGLRenderer it will call this callback to initialize
 *
 * @method initWebGL
 * @param renderer {WebGLRenderer} The renderer instance
 */
public function initWebGL (renderer)
{
	// override!
}

/**
 * If this object is being rendered by a WebGLRenderer it will call this callback
 *
 * @method renderWebGL
 * @param renderer {WebGLRenderer} The renderer instance
 */
public function renderWebGL (renderGroup, projectionMatrix)
{
	// not sure if both needed? but ya have for now!
	// override!
}

}