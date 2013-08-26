package pixi.extras;

import pixi.core.Point;
import pixi.display.DisplayObjectContainer;
import pixi.textures.Texture;
import pixi.Pixi;

/**
 * @author Mat Groves http://matgroves.com/
 */

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
class TilingSprite extends DisplayObjectContainer {

public var texture:Texture;
public var width:Float;
public var height:Float;
public var blendMode:BlendModes;
public var tilePosition:Point;
public var tileScale:Point;
public var updateFrame:Bool;
public var __tilePattern:Dynamic;

public function new (texture:Texture, width:Float, height:Float)
{
	//PIXI.DisplayObjectContainer.call( this );
	super ();

	/**
	 * The texture that the sprite is using
	 *
	 * @property texture
	 * @type Texture
	 */
	this.texture = texture;

	/**
	 * The width of the tiling sprite
	 *
	 * @property width
	 * @type Number
	 */
	this.width = width;

	/**
	 * The height of the tiling sprite
	 *
	 * @property height
	 * @type Number
	 */
	this.height = height;

	/**
	 * The scaling of the image that is being tiled
	 *
	 * @property tileScale
	 * @type Point
	 */	
	this.tileScale = new Point(1,1);

	/**
	 * The offset position of the image that is being tiled
	 *
	 * @property tilePosition
	 * @type Point
	 */	
	this.tilePosition = new Point(0,0);

	this.renderable = true;
	
	this.blendMode = BlendModes.NORMAL;
}

// constructor
//PIXI.TilingSprite.prototype = Object.create( PIXI.DisplayObjectContainer.prototype );
//PIXI.TilingSprite.prototype.constructor = PIXI.TilingSprite;

/**
 * Sets the texture of the tiling sprite
 *
 * @method setTexture
 * @param texture {Texture} The PIXI texture that is displayed by the sprite
 */
public function setTexture (texture:Texture)
{
	//TODO SET THE TEXTURES
	//TODO VISIBILITY
	
	// stop current texture 
	this.texture = texture;
	this.updateFrame = true;
}

/**
 * When the texture is updated, this event will fire to update the frame
 *
 * @method onTextureUpdate
 * @param event
 * @private
 */
public function onTextureUpdate (event)
{
	this.updateFrame = true;
}

}