package pixi.extras;


import js.html.webgl.Buffer;
import js.html.Float32Array;
import js.html.Uint16Array;
import pixi.core.Point;
import pixi.display.DisplayObjectContainer;
import pixi.textures.Texture;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/
 * @author Joshua Granick
 */
class TilingSprite extends DisplayObjectContainer {
	
	
	public var blendMode:BlendModes;
	public var colors:Float32Array;
	
	/**
	 * The height of the tiling sprite
	 *
	 * @property height
	 * @type Number
	 */
	public var height:Float;
	public var indices:Uint16Array;
	
	/**
	 * The texture that the sprite is using
	 *
	 * @property texture
	 * @type Texture
	 */
	public var texture:Texture;
	
	/**
	 * The offset position of the image that is being tiled
	 *
	 * @property tilePosition
	 * @type Point
	 */	
	public var tilePosition:Point;
	
	/**
	 * The scaling of the image that is being tiled
	 *
	 * @property tileScale
	 * @type Point
	 */	
	public var tileScale:Point;
	public var updateFrame:Bool;
	public var uvs:Float32Array;
	public var verticies:Float32Array;
	
	/**
	 * The width of the tiling sprite
	 *
	 * @property width
	 * @type Number
	 */
	public var width:Float;
	
	public var _colorBuffer:Buffer;
	public var _indexBuffer:Buffer;
	public var _uvBuffer:Buffer;
	public var _vertexBuffer:Buffer;
	public var __tilePattern:Dynamic;
	
	
	/**
	 * A tiling sprite is a fast way of rendering a tiling image
	 *
	 * @class TilingSprite
	 * @extends DisplayObjectContainer
	 * @constructor
	 * @param texture {Texture} the texture of the tiling sprite
	 * @param width {Number}  the width of the tiling sprite
	 * @param height {Number} the height of the tiling sprite
	 */
	public function new (texture:Texture, width:Float, height:Float) {
		
		super ();
		
		this.texture = texture;
		this.width = width;
		this.height = height;
		
		this.tileScale = new Point(1,1);
		this.tilePosition = new Point(0,0);
		this.renderable = true;
		this.blendMode = BlendModes.NORMAL;
		
	}
	
	
	/**
	 * When the texture is updated, this event will fire to update the frame
	 *
	 * @method onTextureUpdate
	 * @param event
	 * @private
	 */
	public function onTextureUpdate (event:Dynamic):Void {
		
		this.updateFrame = true;
		
	}
	
	
	/**
	 * Sets the texture of the tiling sprite
	 *
	 * @method setTexture
	 * @param texture {Texture} The PIXI texture that is displayed by the sprite
	 */
	public function setTexture (texture:Texture):Void {
		
		//TODO SET THE TEXTURES
		//TODO VISIBILITY
		
		// stop current texture 
		this.texture = texture;
		this.updateFrame = true;
		
	}
	
	
}