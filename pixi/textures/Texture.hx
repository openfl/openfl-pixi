package pixi.textures;

import pixi.core.Point;
import pixi.core.Rectangle;
import pixi.utils.EventTarget;
import pixi.Pixi;

/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */

//PIXI.TextureCache = {};
//PIXI.FrameCache = {};

/**
 * A texture stores the information that represents an image or part of an image. It cannot be added
 * to the display list directly. To do this use PIXI.Sprite. If no frame is provided then the whole image is used
 *
 * @class Texture
 * @uses EventTarget
 * @constructor
 * @param baseTexture {BaseTexture} The base texture source to create the texture from
 * @param frmae {Rectangle} The rectangle frame of the texture to show
 */
class Texture extends EventTarget {
	
	public var baseTexture:BaseTexture;
	public var frame:Rectangle;
	public var noFrame:Bool;
	public var trim:Point;
	public var scope:Dynamic;
	public static var frameUpdates:Array<Dynamic> = [];
	public var width:Float;
	public var height:Float;
	public var updateFrame:Bool;
	public var onLoaded:Dynamic;
	
	
public function new (baseTexture:BaseTexture, frame:Rectangle = null)
{
	//PIXI.EventTarget.call( this );
	super();

	if(frame == null)
	{
		this.noFrame = true;
		frame = new Rectangle(0,0,1,1);
	}

	if(Std.is (baseTexture, Texture))
		baseTexture = cast (baseTexture, Texture).baseTexture;

	/**
	 * The base texture of this texture
	 *
	 * @property baseTexture
	 * @type BaseTexture
	 */
	this.baseTexture = baseTexture;

	/**
	 * The frame specifies the region of the base texture that this texture uses
	 *
	 * @property frame
	 * @type Rectangle
	 */
	this.frame = frame;

	/**
	 * The trim point
	 *
	 * @property trim
	 * @type Point
	 */
	this.trim = new Point();

	this.scope = this;

	if(baseTexture.hasLoaded)
	{
		if(this.noFrame)frame = new Rectangle(0,0, baseTexture.width, baseTexture.height);
		//console.log(frame)
		
		this.setFrame(frame);
	}
	else
	{
		//var scope = this;
		//baseTexture.addEventListener( 'loaded', function(){ scope.onBaseTextureLoaded();} );
		baseTexture.addEventListener( 'loaded', onBaseTextureLoaded );
	}
}

//PIXI.Texture.prototype.constructor = PIXI.Texture;

/**
 * Called when the base texture is loaded
 *
 * @method onBaseTextureLoaded
 * @param event
 * @private
 */
private function onBaseTextureLoaded (?event)
{
	var baseTexture = this.baseTexture;
	baseTexture.removeEventListener( 'loaded', this.onLoaded );

	if(this.noFrame)this.frame = new Rectangle(0,0, baseTexture.width, baseTexture.height);
	this.noFrame = false;
	this.width = this.frame.width;
	this.height = this.frame.height;

	this.scope.dispatchEvent( { type: 'update', content: this } );
}

/**
 * Destroys this texture
 *
 * @method destroy
 * @param destroyBase {Boolean} Whether to destroy the base texture as well
 */
public function destroy (destroyBase)
{
	if(destroyBase)this.baseTexture.destroy();
}

/**
 * Specifies the rectangle region of the baseTexture
 *
 * @method setFrame
 * @param frame {Rectangle} The frame of the texture to set it to
 */
public function setFrame (frame)
{
	this.frame = frame;
	this.width = frame.width;
	this.height = frame.height;

	if(frame.x + frame.width > this.baseTexture.width || frame.y + frame.height > this.baseTexture.height)
	{
		throw ("Texture Error: frame does not fit inside the base Texture dimensions " + this);
	}

	this.updateFrame = true;

	Texture.frameUpdates.push(this);
	//this.dispatchEvent( { type: 'update', content: this } );
}

/**
 * Helper function that returns a texture based on an image url
 * If the image is not in the texture cache it will be  created and loaded
 *
 * @static
 * @method fromImage
 * @param imageUrl {String} The image url of the texture
 * @param crossorigin {Boolean} Whether requests should be treated as crossorigin
 * @return Texture
 */
public static function fromImage (imageUrl:String, crossorigin:Bool = false)
{
	var texture = Pixi.TextureCache.get (imageUrl);
	
	if(texture == null)
	{
		texture = new Texture(BaseTexture.fromImage(imageUrl, crossorigin));
		Pixi.TextureCache[imageUrl] = texture;
	}
	
	return texture;
}

/**
 * Helper function that returns a texture based on a frame id
 * If the frame id is not in the texture cache an error will be thrown
 *
 * @static
 * @method fromFrame
 * @param frameId {String} The frame id of the texture
 * @return Texture
 */
public static function fromFrame (frameId)
{
	var texture = Pixi.TextureCache.get (frameId);
	if(texture == null)throw ("The frameId '"+ frameId +"' does not exist in the texture cache");
	return texture;
}

/**
 * Helper function that returns a texture based on a canvas element
 * If the canvas is not in the texture cache it will be  created and loaded
 *
 * @static
 * @method fromCanvas
 * @param canvas {Canvas} The canvas element source of the texture
 * @return Texture
 */
public static function fromCanvas (canvas)
{
	var	baseTexture = new BaseTexture(canvas);
	return new Texture(baseTexture);
}


/**
 * Adds a texture to the textureCache.
 *
 * @static
 * @method addTextureToCache
 * @param texture {Texture}
 * @param id {String} the id that the texture will be stored against.
 */
public static function addTextureToCache (texture, id)
{
	Pixi.TextureCache.set (id, texture);
}

/**
 * Remove a texture from the textureCache. 
 *
 * @static
 * @method removeTextureFromCache
 * @param id {String} the id of the texture to be removed
 * @return {Texture} the texture that was removed
 */
public static function removeTextureFromCache (id)
{
	var texture = Pixi.TextureCache.get (id);
	Pixi.TextureCache.set (id, null);
	return texture;
}

// this is more for webGL.. it contains updated frames..
//PIXI.Texture.frameUpdates = [];

}