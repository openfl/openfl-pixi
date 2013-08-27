package pixi.utils;


import js.html.CanvasElement;
import pixi.renderers.canvas.CanvasRenderer;
import pixi.renderers.webgl.WebGLRenderer;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class Detector {
	
	
	/**
	 * This helper function will automatically detect which renderer you should be using.
	 * WebGL is the preferred renderer as it is a lot fastest. If webGL is not supported by
	 * the browser then this function will return a canvas renderer
	 *
	 * @method autoDetectRenderer
	 * @static
	 * @param width {Number} the width of the renderers view
	 * @param height {Number} the height of the renderers view
	 * @param view {Canvas} the canvas to use as a view, optional
	 * @param transparent=false {Boolean} the transparency of the render view, default false
	 * @param antialias=false {Boolean} sets antialias (only applicable in webGL chrome at the moment)
	 * 
	 * antialias
	 */
	public static function autoDetectRenderer (width:Int = 800, height:Int = 600, view:CanvasElement = null, transparent:Bool = false, antialias:Bool = false):Dynamic {
		
		// BORROWED from Mr Doob (mrdoob.com)
		var webgl = untyped __js__("( function () { try { return !! window.WebGLRenderingContext && !! document.createElement( 'canvas' ).getContext( 'experimental-webgl' ); } catch( e ) { return false; } } )()");
		
		//console.log(webgl);
		if( webgl )
		{
			return new WebGLRenderer(width, height, view, transparent, antialias);
		}

		return new CanvasRenderer(width, height, view, transparent);
		
	}
	
	
}