package pixi.extras;


import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;
import js.html.webgl.Buffer;
import js.html.Float32Array;
import js.html.Uint16Array;


/**
 * @author Mat Groves http://matgroves.com/
 * @author Joshua Granick
 */
class TilingSprite extends DisplayObjectContainer {
	
	
	public var blendMode:BlendMode;
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
	public var bitmapData:BitmapData;
	
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
	public function new (bitmapData:BitmapData, width:Float, height:Float) {
		
		super ();
		
		this.bitmapData = bitmapData;
		this.width = width;
		this.height = height;
		
		this.tileScale = new Point(1,1);
		this.tilePosition = new Point(0,0);
		this.renderable = true;
		this.blendMode = BlendMode.NORMAL;
		
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
	public function setTexture (bitmapData:BitmapData):Void {
		
		//TODO SET THE TEXTURES
		//TODO VISIBILITY
		
		// stop current texture 
		this.bitmapData = bitmapData;
		this.updateFrame = true;
		
	}
	
	
}