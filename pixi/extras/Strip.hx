package pixi.extras;


import js.html.Float32Array;
import js.html.Uint16Array;
import pixi.display.DisplayObjectContainer;
import pixi.textures.Texture;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/
 */

class Strip extends DisplayObjectContainer {
	
	public var texture:Texture;
	public var blendMode:BlendModes;
	public var uvs:Float32Array;
	public var verticies:Float32Array;
	public var colors:Float32Array;
	public var indices:Uint16Array;
	public var width:Float;
	public var height:Float;
	public var updateFrame:Bool;
	public var onTextureUpdateBind:Dynamic;
	
	
public function new (texture:Texture, width:Float, height:Float)
{
	//PIXI.DisplayObjectContainer.call( this );
	super ();
	
	this.texture = texture;
	this.blendMode = BlendModes.NORMAL;
	
	try
	{
		this.uvs = new Float32Array([0, 1,
				1, 1,
				1, 0, 0,1]);
	
		this.verticies = new Float32Array([0, 0,
						  0,0,
						  0,0, 0,
						  0, 0]);
						  
		this.colors = new Float32Array([1, 1, 1, 1]);
		
		this.indices = new Uint16Array([0, 1, 2, 3]);
	}
	catch(error:Dynamic)
	{
		/*this.uvs = [0, 1,
				1, 1,
				1, 0, 0,1];
	
		this.verticies = [0, 0,
						  0,0,
						  0,0, 0,
						  0, 0];
						  
		this.colors = [1, 1, 1, 1];
		
		this.indices = [0, 1, 2, 3];*/
	}
	
	
	/*
	this.uvs = new Float32Array()
	this.verticies = new Float32Array()
	this.colors = new Float32Array()
	this.indices = new Uint16Array()
*/
	this.width = width;
	this.height = height;
	
	// load the texture!
	if(texture.baseTexture.hasLoaded)
	{
		this.width   = this.texture.frame.width;
		this.height  = this.texture.frame.height;
		this.updateFrame = true;
	}
	else
	{
		//this.onTextureUpdateBind = this.onTextureUpdate.bind(this);
		this.texture.addEventListener( 'update', this.onTextureUpdate );
	}
	
	this.renderable = true;
}

// constructor
//PIXI.Strip.prototype = Object.create( PIXI.DisplayObjectContainer.prototype );
//PIXI.Strip.prototype.constructor = PIXI.Strip;

public function setTexture (texture:Texture)
{
	//TODO SET THE TEXTURES
	//TODO VISIBILITY
	
	// stop current texture 
	this.texture = texture;
	this.width   = texture.frame.width;
	this.height  = texture.frame.height;
	this.updateFrame = true;
}

public function onTextureUpdate (event)
{
	this.updateFrame = true;
}
// some helper functions..

}