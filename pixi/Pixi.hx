package pixi;


class Pixi {
	
	
	public static var gl:js.html.webgl.GL = null;
	public static var visibleCount:Int = 0;
	//public static var BaseTextureCache:Dynamic = {};
	public static var BaseTextureCache = new Map <String, pixi.textures.BaseTexture> ();
	public static var texturesToUpdate:Array<Dynamic> = [];
	public static var texturesToDestroy:Array<Dynamic> = [];
	//public static var TextureCache:Dynamic = {};
	public static var TextureCache = new Map <String, pixi.textures.Texture> ();
	public static var FrameCache:Dynamic = {};
	
}

enum BlendModes { NORMAL; SCREEN; }