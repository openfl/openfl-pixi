package pixi.extras;


import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObjectContainer;
import js.html.webgl.Buffer;
import js.html.Float32Array;
import js.html.Uint16Array;


/**
 * @author Mat Groves http://matgroves.com/
 * @author Joshua Granick
 */
class Strip extends DisplayObjectContainer {
	
	
	public var blendMode:BlendMode;
	public var colors:Float32Array;
	public var dirty:Bool;
	public var height:Float;
	public var indices:Uint16Array;
	public var bitmapData:BitmapData;
	public var updateFrame:Bool;
	public var uvs:Float32Array;
	public var verticies:Float32Array;
	public var width:Float;
	
	public var _colorBuffer:Buffer;
	public var _indexBuffer:Buffer;
	public var _uvBuffer:Buffer;
	public var _vertexBuffer:Buffer;
	
	
	public function new (bitmapData:BitmapData, width:Float, height:Float) {
		
		super ();
		
		this.bitmapData = bitmapData;
		this.blendMode = BlendMode.NORMAL;
		
		try {
			
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
		catch (error:Dynamic)
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
		if(bitmapData.baseTexture.hasLoaded)
		{
			this.width = this.bitmapData.frame.width;
			this.height = this.bitmapData.frame.height;
			this.updateFrame = true;
		}
		else
		{
			this.bitmapData.addEventListener ('update', this.onTextureUpdate);
		}
		
		this.renderable = true;
	}
	
	
	public function onTextureUpdate (event:Dynamic):Void {
		
		this.updateFrame = true;
		
	}
	
	
	public function setTexture (bitmapData:BitmapData):Void {
		
		//TODO SET THE TEXTURES
		//TODO VISIBILITY
		
		// stop current texture 
		this.bitmapData = bitmapData;
		this.width   = bitmapData.frame.width;
		this.height  = bitmapData.frame.height;
		this.updateFrame = true;
		
	}
	
	
}