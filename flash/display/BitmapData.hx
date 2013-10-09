package flash.display;


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import js.html.CanvasElement;
import pixi.textures.BaseTexture;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class BitmapData extends EventDispatcher {
	
	
	public static var TextureCache = new Map <String, BitmapData> ();
	
	public static var frameUpdates:Array<Dynamic> = [];
	
	/**
	 * The base texture of this texture
	 *
	 * @property baseTexture
	 * @type BaseTexture
	 */
	public var baseTexture:BaseTexture;
	
	/**
	 * The frame specifies the region of the base texture that this texture uses
	 *
	 * @property frame
	 * @type Rectangle
	 */
	public var frame:Rectangle;
	public var height:Float;
	public var noFrame:Bool;
	public var onLoaded:Dynamic;
	
	/**
	 * The trim point
	 *
	 * @property trim
	 * @type Point
	 */
	public var trim:Point;
	public var updateFrame:Bool;
	public var width:Float;
	
	
	/**
	 * A texture stores the information that represents an image or part of an image. It cannot be added
	 * to the display list directly. To do this use PIXI.Sprite. If no frame is provided then the whole image is used
	 *
	 * @class Texture
	 * @uses EventTarget
	 * @constructor
	 * @param baseTexture {BaseTexture} The base texture source to create the texture from
	 * @param frame {Rectangle} The rectangle frame of the texture to show
	 */
	public function new (baseTexture:BaseTexture, frame:Rectangle = null) {
		
		super();
		
		if(frame == null)
		{
			this.noFrame = true;
			frame = new Rectangle(0,0,1,1);
		}
		
		if(Std.is (baseTexture, BitmapData))
			baseTexture = cast (baseTexture, BitmapData).baseTexture;
			
		this.baseTexture = baseTexture;
		this.frame = frame;
		this.trim = new Point();
		
		if(baseTexture.hasLoaded)
		{
			if(this.noFrame)frame = new Rectangle(0,0, baseTexture.width, baseTexture.height);
			//console.log(frame)
			
			this.setFrame(frame);
		}
		else
		{
			baseTexture.addEventListener('loaded', onBaseTextureLoaded);
		}
		
	}
	
	
	/**
	 * Adds a texture to the textureCache.
	 *
	 * @static
	 * @method addTextureToCache
	 * @param texture {Texture}
	 * @param id {String} the id that the texture will be stored against.
	 */
	public static function addTextureToCache (bitmapData:BitmapData, id:String):Void {
		
		BitmapData.TextureCache.set (id, bitmapData);
		
	}
	
	
	/**
	 * Destroys this texture
	 *
	 * @method destroy
	 * @param destroyBase {Boolean} Whether to destroy the base texture as well
	 */
	public function destroy (destroyBase:Bool):Void {
		
		if(destroyBase)this.baseTexture.destroy();
		
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
	public static function fromCanvas (canvas:CanvasElement):BitmapData {
		
		var	baseTexture = new BaseTexture(canvas);
		return new BitmapData(baseTexture);
		
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
	public static function fromFrame (frameId:String):BitmapData {
		
		var texture = BitmapData.TextureCache.get (frameId);
		if(texture == null)throw ("The frameId '"+ frameId +"' does not exist in the texture cache");
		return texture;
		
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
	public static function fromImage (imageUrl:String, crossorigin:Bool = false):BitmapData {
		
		var bitmapData = BitmapData.TextureCache.get (imageUrl);
		
		if(bitmapData == null)
		{
			bitmapData = new BitmapData(BaseTexture.fromImage(imageUrl, crossorigin));
			BitmapData.TextureCache[imageUrl] = bitmapData;
		}
		
		return bitmapData;
		
	}
	
	
	/**
	 * Called when the base texture is loaded
	 *
	 * @method onBaseTextureLoaded
	 * @param event
	 * @private
	 */
	private function onBaseTextureLoaded (?event:Dynamic):Void {
		
		var baseTexture = this.baseTexture;
		baseTexture.removeEventListener( 'loaded', this.onLoaded );
		
		if(this.noFrame)this.frame = new Rectangle(0,0, baseTexture.width, baseTexture.height);
		this.noFrame = false;
		this.width = this.frame.width;
		this.height = this.frame.height;
		
		dispatchEvent (new Event ("update"));
		//dispatchEvent( { type: 'update', content: this } );
		
	}
	
	
	/**
	 * Remove a texture from the textureCache. 
	 *
	 * @static
	 * @method removeTextureFromCache
	 * @param id {String} the id of the texture to be removed
	 * @return {Texture} the texture that was removed
	 */
	public static function removeTextureFromCache (id:String):BitmapData {
		
		var texture = BitmapData.TextureCache.get (id);
		BitmapData.TextureCache.set (id, null);
		return texture;
		
	}
	
	
	/**
	 * Specifies the rectangle region of the baseTexture
	 *
	 * @method setFrame
	 * @param frame {Rectangle} The frame of the texture to set it to
	 */
	public function setFrame (frame:Rectangle):Void {
		
		this.frame = frame;
		this.width = frame.width;
		this.height = frame.height;
		
		if(frame.x + frame.width > this.baseTexture.width || frame.y + frame.height > this.baseTexture.height)
		{
			throw ("Texture Error: frame does not fit inside the base Texture dimensions " + this);
		}
		
		this.updateFrame = true;
		
		BitmapData.frameUpdates.push(this);
		//this.dispatchEvent( { type: 'update', content: this } );
		
	}
	
	
}