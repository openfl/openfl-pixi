package flash.display;


import flash.display.BitmapData;
import flash.geom.Point;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class Bitmap extends DisplayObjectContainer {
	
	
	/**
	 * The anchor sets the origin point of the texture.
	 * The default is 0,0 this means the textures origin is the top left 
	 * Setting than anchor to 0.5,0.5 means the textures origin is centered
	 * Setting the anchor to 1,1 would mean the textures origin points will be the bottom right
	 *
     * @property anchor
     * @type Point
     */
	public var anchor:Point;
	
	public var batch:Dynamic;
	
	/**
	 * The blend mode of sprite.
	 * currently supports PIXI.blendModes.NORMAL and PIXI.blendModes.SCREEN
	 *
	 * @property blendMode
	 * @type Number
	 */
	public var blendMode:BlendMode;
	
	/**
	 * The height of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property height
	 * @type Number
	 */
	public var height (get, set):Float;
	
	/**
	 * The texture that the sprite is using
	 *
	 * @property texture
	 * @type Texture
	 */
	public var bitmapData:BitmapData;
	public var textureChange:Bool;
	public var updateFrame:Bool;
	
	/**
	 * The width of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property width
	 * @type Number
	 */
	public var width (get, set):Float;
	
	private var _width:Float;
	private var _height:Float;
	
	
	/**
	 * The Sprite object is the base for all textured objects that are rendered to the screen
	 *
	 * @class Sprite
	 * @extends DisplayObjectContainer
	 * @constructor
	 * @param texture {Texture} The texture for this sprite
	 * @type String
	 */
	public function new (bitmapData:BitmapData) {
		
		super ();
		
		this.anchor = new Point();
		this.bitmapData = bitmapData;
		this.blendMode = BlendMode.NORMAL;
		this._width = 0;
		this._height = 0;
		
		if(bitmapData.baseTexture.hasLoaded)
		{
			this.updateFrame = true;
		}
		else
		{
			this.bitmapData.addEventListener( 'update', onTextureUpdate);
		}
		
		this.renderable = true;
		
	}
	
	
	/**
	 * When the texture is updated, this event will fire to update the scale and frame
	 *
	 * @method onTextureUpdate
	 * @param event
	 * @private
	 */
	private function onTextureUpdate (event:Dynamic):Void {
		
		//this.texture.removeEventListener( 'update', this.onTextureUpdateBind );
		
		// so if _width is 0 then width was not set..
		if(this._width > 0)this.scale.x = this._width / this.bitmapData.frame.width;
		if(this._height > 0)this.scale.y = this._height / this.bitmapData.frame.height;
		
		this.updateFrame = true;
		
	}
	
	
	/**
	 * Sets the texture of the sprite
	 *
	 * @method setTexture
	 * @param texture {Texture} The PIXI texture that is displayed by the sprite
	 */
	public function setTexture (bitmapData:BitmapData):Void {
		
		// stop current texture;
		if(this.bitmapData.baseTexture != bitmapData.baseTexture)
		{
			this.textureChange = true;	
			this.bitmapData = bitmapData;
			
			if(this.__renderGroup != null)
			{
				this.__renderGroup.updateTexture(this);
			}
		}
		else
		{
			this.bitmapData = bitmapData;
		}
		
		this.updateFrame = true;
		
	}
	
	// some helper functions..
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture from the TextureCache based on the frameId
	 * The frame ids are created when a Texture packer file has been loaded
	 *
	 * @method fromFrame
	 * @static
	 * @param frameId {String} The frame Id of the texture in the cache
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the frameId
	 */
	public static function fromFrame (frameId:String):Bitmap {
		
		var bitmapData = BitmapData.TextureCache[frameId];
		if(bitmapData == null)throw ("The frameId '"+ frameId +"' does not exist in the texture cache");
		return new Bitmap(bitmapData);
		
	}
	
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture based on an image url
	 * If the image is not in the texture cache it will be loaded
	 *
	 * @method fromImage
	 * @static
	 * @param imageId {String} The image url of the texture
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the image id
	 */
	public static function fromImage (imageId:String):Bitmap {
		
		var bitmapData = BitmapData.fromImage(imageId);
		return new Bitmap(bitmapData);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_height ():Float {
		
		return this.scale.y * this.bitmapData.frame.height;
		
	}
	
	private function set_height (value:Float):Float {
		
		this.scale.y = value / this.bitmapData.frame.height;
		this._height = value;
		return value;
		
	}
	
	
	private function get_width ():Float {
		
		return this.scale.x * this.bitmapData.frame.width;
		
	}
	
	private function set_width (value:Float):Float {
		
		this.scale.x = value / this.bitmapData.frame.width;
		this._width = value;
		return value;
		
	}
	
	
}