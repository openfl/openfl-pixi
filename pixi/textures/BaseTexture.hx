package pixi.textures;


import js.html.Image;
import pixi.utils.EventTarget;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class BaseTexture extends EventTarget {
	
	
	/**
	 * [read-only] Describes if the base texture has loaded or not
	 *
	 * @property hasLoaded
	 * @type Boolean
	 * @readOnly
	 */
	public var hasLoaded (default, null):Bool;
	
	/**
	 * [read-only] The height of the base texture set when the image has loaded
	 *
	 * @property height
	 * @type Number
	 * @readOnly
	 */
	public var height (default, null):Float;
	
	/**
	 * The source that is loaded to create the texture
	 *
	 * @property source
	 * @type Image
	 */
	public var source:Dynamic;
	
	/**
	 * [read-only] The width of the base texture set when the image has loaded
	 *
	 * @property width
	 * @type Number
	 * @readOnly
	 */
	public var width (default, null):Float;
	
	private var _powerOf2:Bool;
	
	
	/**
	 * A texture stores the information that represents an image. All textures have a base texture
	 *
	 * @class BaseTexture
	 * @uses EventTarget
	 * @constructor
	 * @param source {String} the source object (image or canvas)
	 */
	public function new (source:Dynamic) {
		
		super ();
		
		this.width = 100;
		this.height = 100;
		this.hasLoaded = false;
		this.source = source;
		
		if(source == null)return;
		
		if(untyped __js__("this.source instanceof Image || this.source instanceof HTMLImageElement"))
		{
			if(this.source.complete)
			{
				this.hasLoaded = true;
				this.width = this.source.width;
				this.height = this.source.height;
				
				Pixi.texturesToUpdate.push(this);
			}
			else
			{
				
				var scope = this;
				this.source.onload = function(){
					
					scope.hasLoaded = true;
					scope.width = scope.source.width;
					scope.height = scope.source.height;
				
					// add it to somewhere...
					Pixi.texturesToUpdate.push(scope);
					scope.dispatchEvent( { type: 'loaded', content: scope } );
				}
				//	this.image.src = imageUrl;
			}
		}
		else
		{
			this.hasLoaded = true;
			this.width = this.source.width;
			this.height = this.source.height;
				
			Pixi.texturesToUpdate.push(this);
		}
		
		this._powerOf2 = false;
		
	}
	
	
	/**
	 * Destroys this base texture
	 *
	 * @method destroy
	 */
	public function destroy ():Void {
		
		if(untyped __js__ ("this.source instanceof Image"))
		{
			this.source.src = null;
		}
		this.source = null;
		Pixi.texturesToDestroy.push(this);
		
	}
	
	
	/**
	 * Helper function that returns a base texture based on an image url
	 * If the image is not in the base texture cache it will be  created and loaded
	 *
	 * @static
	 * @method fromImage
	 * @param imageUrl {String} The image url of the texture
	 * @return BaseTexture
	 */
	public static function fromImage (imageUrl:String, crossorigin:Bool = false):BaseTexture {
		
		var baseTexture = Pixi.BaseTextureCache.get (imageUrl);
		if(baseTexture == null)
		{
			// new Image() breaks tex loading in some versions of Chrome.
			// See https://code.google.com/p/chromium/issues/detail?id=238071
			var image = new Image();//document.createElement('img'); 
			if (crossorigin)
			{
				image.crossOrigin = '';
			}
			image.src = imageUrl;
			baseTexture = new BaseTexture(image);
			Pixi.BaseTextureCache.set (imageUrl, baseTexture);
		}

		return baseTexture;
		
	}
	
	
}