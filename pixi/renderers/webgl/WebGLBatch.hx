package pixi.renderers.webgl;


import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import js.html.webgl.Buffer;
import js.html.webgl.GL;
import js.html.Float32Array;
import js.html.Uint16Array;
import pixi.textures.BaseTexture;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class WebGLBatch {
	
	
	public static var _batchs:Array<WebGLBatch> = [];
	
	public var blendMode:BlendMode;
	public var colorBuffer:Buffer;
	public var colorIndex:Int;
	public var colors:Float32Array;
	public var dirty:Bool;
	public var dirtyColors:Bool;
	public var dirtyUVS:Bool;
	public var dynamicSize:Int;
	public var indexBuffer:Buffer;
	public var indices:Uint16Array;
	public var size:Int;
	public var texture:BaseTexture;
	public var uvBuffer:Buffer;
	public var uvs:Float32Array;
	public var vertexBuffer:Buffer;
	public var verticies:Float32Array;
	
	private var gl:GL;
	private var head:Dynamic;
	private var last:Dynamic;
	private var tail:Dynamic;
	
	
	/**
	 * A WebGLBatch Enables a group of sprites to be drawn using the same settings.
	 * if a group of sprites all have the same baseTexture and blendMode then they can be grouped into a batch.
	 * All the sprites in a batch can then be drawn in one go by the GPU which is hugely efficient. ALL sprites
	 * in the webGL renderer are added to a batch even if the batch only contains one sprite. Batching is handled
	 * automatically by the webGL renderer. A good tip is: the smaller the number of batchs there are, the faster
	 * the webGL renderer will run.
	 *
	 * @class WebGLBatch
	 * @constructor
	 * @param gl {WebGLContext} an instance of the webGL context
	 */
	public function new (gl:GL) {
		
		this.gl = gl;
		
		this.size = 0;
		
		this.vertexBuffer =  gl.createBuffer();
		this.indexBuffer =  gl.createBuffer();
		this.uvBuffer =  gl.createBuffer();
		this.colorBuffer =  gl.createBuffer();
		this.blendMode = BlendMode.NORMAL;
		this.dynamicSize = 1;
		
	}
	
	
	/**
	 * Cleans the batch so that is can be returned to an object pool and reused
	 *
	 * @method clean
	 */
	public function clean ():Void {
		
		this.verticies = new Float32Array ([]);
		this.uvs = new Float32Array ([]);
		this.indices = new Uint16Array ([]);
		this.colors = new Float32Array ([]);
		this.dynamicSize = 1;
		this.texture = null;
		this.last = null;
		this.size = 0;
		this.head;
		this.tail;
		
	}
	
	
	/**
	 * Grows the size of the batch. As the elements in the batch cannot have a dynamic size this
	 * function is used to increase the size of the batch. It also creates a little extra room so
	 * that the batch does not need to be resized every time a sprite is added
	 *
	 * @method growBatch
	 */
	public function growBatch ():Void {
		
		var gl = this.gl;
		if( this.size == 1)
		{
			this.dynamicSize = 1;
		}
		else
		{
			this.dynamicSize = Std.int (this.size * 1.5);
		}
		// grow verts
		this.verticies = new Float32Array(this.dynamicSize * 8);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
		gl.bufferData(GL.ARRAY_BUFFER,this.verticies , GL.DYNAMIC_DRAW);
		
		this.uvs  = new Float32Array( this.dynamicSize * 8 );
		gl.bindBuffer(GL.ARRAY_BUFFER, this.uvBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this.uvs , GL.DYNAMIC_DRAW);
		
		this.dirtyUVS = true;
		
		this.colors  = new Float32Array( this.dynamicSize * 4 );
		gl.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this.colors , GL.DYNAMIC_DRAW);
		
		this.dirtyColors = true;
		
		this.indices = new Uint16Array(this.dynamicSize * 6); 
		var length = Std.int(this.indices.length/6);
		
		for (i in 0...length) 
		{
			var index2 = i * 6;
			var index3 = i * 4;
			this.indices[index2 + 0] = index3 + 0;
			this.indices[index2 + 1] = index3 + 1;
			this.indices[index2 + 2] = index3 + 2;
			this.indices[index2 + 3] = index3 + 0;
			this.indices[index2 + 4] = index3 + 2;
			this.indices[index2 + 5] = index3 + 3;
		};
		
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, this.indices, GL.STATIC_DRAW);
		
	}
	
	
	/**
	 * inits the batch's texture and blend mode based if the supplied sprite
	 *
	 * @method init
	 * @param sprite {Sprite} the first sprite to be added to the batch. Only sprites with
	 *		the same base texture and blend mode will be allowed to be added to this batch
	 */	
	public function init (sprite:Bitmap):Void {
		
		sprite.batch = this;
		this.dirty = true;
		this.blendMode = sprite.blendMode;
		this.texture = sprite.bitmapData.baseTexture;
		this.head = sprite;
		this.tail = sprite;
		this.size = 1;
		
		this.growBatch();
		
	}
	
	
	/**
	 * inserts a sprite after the specified sprite
	 *
	 * @method insertAfter
	 * @param sprite {Sprite} the sprite to be added
	 * @param  previousSprite {Sprite} the first sprite will be inserted after this sprite
	 */	
	public function insertAfter (sprite:Bitmap, previousSprite:Bitmap):Void {
		
		this.size++;
		
		sprite.batch = this;
		this.dirty = true;
		
		var tempNext = previousSprite.__next;
		previousSprite.__next = sprite;
		sprite.__prev = previousSprite;
		
		if(tempNext != null)
		{
			sprite.__next = tempNext;
			tempNext.__prev = sprite;
		}
		else
		{
			this.tail = sprite;
		}
		
	}
	
	
	/**
	 * inserts a sprite before the specified sprite
	 *
	 * @method insertBefore
	 * @param sprite {Sprite} the sprite to be added
	 * @param nextSprite {nextSprite} the first sprite will be inserted before this sprite
	 */	
	public function insertBefore (sprite:Bitmap, nextSprite:Bitmap):Void {
		
		this.size++;
		
		sprite.batch = this;
		this.dirty = true;
		var tempPrev = nextSprite.__prev;
		nextSprite.__prev = sprite;
		sprite.__next = nextSprite;
		
		if(tempPrev != null)
		{
			sprite.__prev = tempPrev;
			tempPrev.__next = sprite;
		}
		else
		{
			this.head = sprite;
		}
		
	}
	
	
	/**
	 * Merges two batchs together
	 *
	 * @method merge
	 * @param batch {WebGLBatch} the batch that will be merged 
	 */
	public function merge (batch:WebGLBatch):Void {
		
		this.dirty = true;
		
		this.tail.__next = batch.head;
		batch.head.__prev = this.tail;
		
		this.size += batch.size;
		
		this.tail = batch.tail;
		
		var sprite:Dynamic = batch.head;
		while(sprite != null)
		{
			sprite.batch = this;
			sprite = sprite.__next;
		}
		
	}
	
	
	/**
	 * Refresh's all the data in the batch and sync's it with the webGL buffers
	 *
	 * @method refresh
	 */
	public function refresh ():Void {
		
		var gl = this.gl;
		
		if (this.dynamicSize < this.size)
		{
			this.growBatch();
		}
		
		var indexRun = 0;
		var worldTransform, width, height, aX, aY, w0, w1, h0, h1, index;
		var a, b, c, d, tx, ty;
		
		var displayObject:Dynamic = this.head;
		
		while(displayObject != null)
		{
			index = indexRun * 8;
			
			var bitmapData = displayObject.bitmapData;
			
			var frame = bitmapData.frame;
			var tw = bitmapData.baseTexture.width;
			var th = bitmapData.baseTexture.height;
			
			this.uvs[index + 0] = frame.x / tw;
			this.uvs[index +1] = frame.y / th;
			
			this.uvs[index +2] = (frame.x + frame.width) / tw;
			this.uvs[index +3] = frame.y / th;
			
			this.uvs[index +4] = (frame.x + frame.width) / tw;
			this.uvs[index +5] = (frame.y + frame.height) / th; 
			
			this.uvs[index +6] = frame.x / tw;
			this.uvs[index +7] = (frame.y + frame.height) / th;
			
			displayObject.updateFrame = false;
			
			colorIndex = indexRun * 4;
			this.colors[colorIndex] = this.colors[colorIndex + 1] = this.colors[colorIndex + 2] = this.colors[colorIndex + 3] = displayObject.worldAlpha;
			
			displayObject = displayObject.__next;
			
			indexRun ++;
		}
		
		this.dirtyUVS = true;
		this.dirtyColors = true;
		
	}	
	
	
	/**
	 * removes a sprite from the batch
	 *
	 * @method remove
	 * @param sprite {Sprite} the sprite to be removed
	 */	
	public function remove (sprite:Bitmap):Void {
		
		this.size--;
		
		if(this.size == 0)
		{
			sprite.batch = null;
			sprite.__prev = null;
			sprite.__next = null;
			return;
		}
		
		if(sprite.__prev != null)
		{
			sprite.__prev.__next = sprite.__next;
		}
		else
		{
			this.head = sprite.__next;
			this.head.__prev = null;
		}
		
		if(sprite.__next != null)
		{
			sprite.__next.__prev = sprite.__prev;
		}
		else
		{
			this.tail = sprite.__prev;
			this.tail.__next = null;
		}
		
		sprite.batch = null;
		sprite.__next = null;
		sprite.__prev = null;
		this.dirty = true;
		
	}
	
	
	/**
	 * Draws the batch to the frame buffer
	 *
	 * @method render
	 */
	public function render (start:Int = 0, end:Null<Int> = null) {
		
		if(end == null)end = this.size;
		
		if(this.dirty)
		{
			this.refresh();
			this.dirty = false;
		}
		
		if (this.size == 0)return;
		
		this.update();
		var gl = this.gl;
		
		//TODO optimize this!
		
		var shaderProgram = WebGLShaders.shaderProgram;
		gl.useProgram(shaderProgram);
		
		// update the verts..
		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
		// ok..
		gl.bufferSubData(GL.ARRAY_BUFFER, 0, this.verticies);
		gl.vertexAttribPointer(untyped (shaderProgram).vertexPositionAttribute, 2, GL.FLOAT, false, 0, 0);
		// update the uvs
	   	gl.bindBuffer(GL.ARRAY_BUFFER, this.uvBuffer);
	   	
		if(this.dirtyUVS)
		{
			this.dirtyUVS = false;
			gl.bufferSubData(GL.ARRAY_BUFFER,  0, this.uvs);
		}
		
		gl.vertexAttribPointer(untyped (shaderProgram).textureCoordAttribute, 2, GL.FLOAT, false, 0, 0);
		
		gl.activeTexture(GL.TEXTURE0);
		gl.bindTexture(GL.TEXTURE_2D, this.texture._glTexture);
		
		// update color!
		gl.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
		
		if(this.dirtyColors)
		{
			this.dirtyColors = false;
			gl.bufferSubData(GL.ARRAY_BUFFER, 0, this.colors);
		}
		
		gl.vertexAttribPointer(untyped (shaderProgram).colorAttribute, 1, GL.FLOAT, false, 0, 0);
		
		// dont need to upload!
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		
		var len = end - start;
		
		// DRAW THAT this!
		gl.drawElements(GL.TRIANGLES, len * 6, GL.UNSIGNED_SHORT, start * 2 * 6 );
		
	}
	
	
	/**
	 * Recreates the buffers in the event of a context loss
	 *
	 * @method restoreLostContext
	 * @param gl {WebGLContext}
	 */
	public function restoreLostContext (gl:GL):Void {
		
		this.gl = gl;
		this.vertexBuffer = gl.createBuffer();
		this.indexBuffer = gl.createBuffer();
		this.uvBuffer = gl.createBuffer();
		this.colorBuffer = gl.createBuffer();
		
	}
	
	
	/**
	 * Splits the batch into two with the specified sprite being the start of the new batch.
	 *
	 * @method split
	 * @param sprite {Sprite} the sprite that indicates where the batch should be split
	 * @return {WebGLBatch} the new batch
	 */
	public function split (sprite:Bitmap):WebGLBatch {
		
		this.dirty = true;
		
		var batch = new WebGLBatch(this.gl);
		batch.init(sprite);
		batch.texture = this.texture;
		batch.tail = this.tail;
		
		this.tail = sprite.__prev;
		this.tail.__next = null;
		
		sprite.__prev = null;
		// return a splite batch!
		
		// TODO this size is wrong!
		// need to recalculate :/ problem with a linked list!
		// unless it gets calculated in the "clean"?
		
		// need to loop through items as there is no way to know the length on a linked list :/
		var tempSize = 0;
		while(sprite != null)
		{
			tempSize++;
			sprite.batch = batch;
			sprite = sprite.__next;
		}
		
		batch.size = tempSize;
		this.size -= tempSize;
		
		return batch;
		
	}
	
	
	/**
	 * Updates all the relevant geometry and uploads the data to the GPU
	 *
	 * @method update
	 */
	public function update ():Void {
		
		var gl = this.gl;
		var worldTransform, width, height, aX, aY, w0, w1, h0, h1, index, index2, index3;
		
		var a, b, c, d, tx, ty;
		
		var indexRun = 0;
		
		var displayObject:Dynamic = this.head;
		
		while(displayObject != null)
		{
			if(displayObject.vcount == DisplayObject.visibleCount)
			{
				width = displayObject.bitmapData.frame.width;
				height = displayObject.bitmapData.frame.height;
				
				// TODO trim??
				aX = displayObject.anchor.x;// - displayObject.texture.trim.x
				aY = displayObject.anchor.y; //- displayObject.texture.trim.y
				w0 = width * (1-aX);
				w1 = width * -aX;
				
				h0 = height * (1-aY);
				h1 = height * -aY;
				
				index = indexRun * 8;
				
				worldTransform = displayObject.worldTransform;
				
				a = worldTransform[0];
				b = worldTransform[3];
				c = worldTransform[1];
				d = worldTransform[4];
				tx = worldTransform[2];
				ty = worldTransform[5];
				
				this.verticies[index + 0 ] = a * w1 + c * h1 + tx; 
				this.verticies[index + 1 ] = d * h1 + b * w1 + ty;
				
				this.verticies[index + 2 ] = a * w0 + c * h1 + tx; 
				this.verticies[index + 3 ] = d * h1 + b * w0 + ty; 
				
				this.verticies[index + 4 ] = a * w0 + c * h0 + tx; 
				this.verticies[index + 5 ] = d * h0 + b * w0 + ty; 
				
				this.verticies[index + 6] =  a * w1 + c * h0 + tx; 
				this.verticies[index + 7] =  d * h0 + b * w1 + ty; 
				
				if(displayObject.updateFrame || displayObject.bitmapData.updateFrame)
				{
					this.dirtyUVS = true;
					
					var bitmapData = displayObject.bitmapData;
					
					var frame = bitmapData.frame;
					var tw = bitmapData.baseTexture.width;
					var th = bitmapData.baseTexture.height;
					
					this.uvs[index + 0] = frame.x / tw;
					this.uvs[index +1] = frame.y / th;
					
					this.uvs[index +2] = (frame.x + frame.width) / tw;
					this.uvs[index +3] = frame.y / th;
					
					this.uvs[index +4] = (frame.x + frame.width) / tw;
					this.uvs[index +5] = (frame.y + frame.height) / th; 
					
					this.uvs[index +6] = frame.x / tw;
					this.uvs[index +7] = (frame.y + frame.height) / th;
					
					displayObject.updateFrame = false;
				}
				
				// TODO this probably could do with some optimisation....
				if(displayObject.cacheAlpha != displayObject.worldAlpha)
				{
					displayObject.cacheAlpha = displayObject.worldAlpha;
					
					var colorIndex = indexRun * 4;
					this.colors[colorIndex] = this.colors[colorIndex + 1] = this.colors[colorIndex + 2] = this.colors[colorIndex + 3] = displayObject.worldAlpha;
					this.dirtyColors = true;
				}
			}
			else
			{
				index = indexRun * 8;
				
				this.verticies[index + 0 ] = 0;
				this.verticies[index + 1 ] = 0;
				
				this.verticies[index + 2 ] = 0;
				this.verticies[index + 3 ] = 0;
				
				this.verticies[index + 4 ] = 0;
				this.verticies[index + 5 ] = 0;
				
				this.verticies[index + 6] = 0;
				this.verticies[index + 7] = 0;
			}
			
			indexRun++;
			displayObject = displayObject.__next;
			
		}
		
	}
	
	
	public static function _getBatch (gl:GL):WebGLBatch {
		
		if(_batchs.length == 0)
		{
			return new WebGLBatch(gl);
		}
		else
		{
			return _batchs.pop();
		}
		
	}
	
	
	public static function _returnBatch (batch:WebGLBatch):Void {
		
		batch.clean();	
		_batchs.push(batch);
		
	}
	
	
	public static function _restoreBatchs (gl:GL):Void {
		
		for (i in 0..._batchs.length) 
		{
  			_batchs[i].restoreLostContext(gl);
		}
		
	}
	
	
}
