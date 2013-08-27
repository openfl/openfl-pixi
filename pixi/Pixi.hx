package pixi;


import js.html.webgl.GL;
import js.html.webgl.Shader;
import pixi.core.Rectangle;
import pixi.textures.BaseTexture;
import pixi.textures.Texture;


class Pixi {
	
	
	// catch-all for some global properties and methods, which 
	// should probably be refactored as statics elsewhere
	
	public static var BaseTextureCache = new Map <String, BaseTexture> ();
	public static var FrameCache:Dynamic = {};
	public static var TextureCache = new Map <String, Texture> ();
	
	public static var gl:GL = null;
	public static var texturesToDestroy:Array<Dynamic> = [];
	public static var texturesToUpdate:Array<Dynamic> = [];
	public static var visibleCount:Int = 0;
	public static var _defaultFrame = new Rectangle(0,0,1,1);
	
	
}


enum BlendModes {
	
	NORMAL;
	SCREEN;
	
}