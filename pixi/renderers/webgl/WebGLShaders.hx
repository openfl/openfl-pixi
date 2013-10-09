package pixi.renderers.webgl;


import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import js.Lib;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class WebGLShaders {
	
	
	/*
	 * the default suoer fast shader!
	 */
	
	public static var shaderFragmentSrc = [
		"precision mediump float;",
		"varying vec2 vTextureCoord;",
		"varying float vColor;",
		"uniform sampler2D uSampler;",
		"void main(void) {",
			"gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y));",
			"gl_FragColor = gl_FragColor * vColor;",
		"}"
	];
	
	public static var shaderVertexSrc = [
		"attribute vec2 aVertexPosition;",
		"attribute vec2 aTextureCoord;",
		"attribute float aColor;",
		//"uniform mat4 uMVMatrix;",
		
		"uniform vec2 projectionVector;",
		"varying vec2 vTextureCoord;",
		"varying float vColor;",
		"void main(void) {",
		 // "gl_Position = uMVMatrix * vec4(aVertexPosition, 1.0, 1.0);",
			"gl_Position = vec4( aVertexPosition.x / projectionVector.x -1.0, aVertexPosition.y / -projectionVector.y + 1.0 , 0.0, 1.0);",
			"vTextureCoord = aTextureCoord;",
			"vColor = aColor;",
		"}"
	];
	
	/*
	 * the triangle strip shader..
	 */
	
	public static var stripShaderFragmentSrc = [
		"precision mediump float;",
		"varying vec2 vTextureCoord;",
		"varying float vColor;",
		"uniform float alpha;",
		"uniform sampler2D uSampler;",
		"void main(void) {",
			"gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y));",
			"gl_FragColor = gl_FragColor * alpha;",
		"}"
	];
	
	public static var stripShaderVertexSrc = [
		"attribute vec2 aVertexPosition;",
		"attribute vec2 aTextureCoord;",
		"attribute float aColor;",
		"uniform mat3 translationMatrix;",
		"uniform vec2 projectionVector;",
		"varying vec2 vTextureCoord;",
		"varying float vColor;",
		"void main(void) {",
		"vec3 v = translationMatrix * vec3(aVertexPosition, 1.0);",
			"gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);",
			"vTextureCoord = aTextureCoord;",
			"vColor = aColor;",
		"}"
	];
	
	/*
	 * primitive shader..
	 */
	
	public static var primitiveShaderFragmentSrc = [
		"precision mediump float;",
		"varying vec4 vColor;",
		"void main(void) {",
			"gl_FragColor = vColor;",
		"}"
	];
	
	public static var primitiveShaderVertexSrc = [
		"attribute vec2 aVertexPosition;",
		"attribute vec4 aColor;",
		"uniform mat3 translationMatrix;",
		"uniform vec2 projectionVector;",
		"uniform float alpha;",
		"varying vec4 vColor;",
		"void main(void) {",
			"vec3 v = translationMatrix * vec3(aVertexPosition, 1.0);",
			"gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);",
			"vColor = aColor	* alpha;",
		"}"
	];
	
	
	public static var primitiveProgram:Program;
	public static var shaderProgram:Program;
	public static var stripShaderProgram:Program;
	
	
	public static function activateDefaultShader ():Void {
		
		var gl = WebGLRenderer.gl;
		var shaderProgram = WebGLShaders.shaderProgram;
		
		gl.useProgram(shaderProgram);
		
		gl.enableVertexAttribArray(untyped (shaderProgram).vertexPositionAttribute);
		gl.enableVertexAttribArray(untyped (shaderProgram).textureCoordAttribute);
		gl.enableVertexAttribArray(untyped (shaderProgram).colorAttribute);
		
	}
	
	
	public static function activatePrimitiveShader ():Void {
		
		var gl = WebGLRenderer.gl;
		
		gl.disableVertexAttribArray(untyped (shaderProgram).textureCoordAttribute);
		gl.disableVertexAttribArray(untyped (shaderProgram).colorAttribute);
		
		gl.useProgram(primitiveProgram);
		
		gl.enableVertexAttribArray(untyped (primitiveProgram).vertexPositionAttribute);
		gl.enableVertexAttribArray(untyped (primitiveProgram).colorAttribute);
		
	} 
	
	
	private static function CompileFragmentShader (gl:GL, shaderSrc:Array<String>):Shader {
		
		return _CompileShader(gl, shaderSrc, GL.FRAGMENT_SHADER);
		
	}
	
	
	public static function compileProgram (vertexSrc:Array<String>, fragmentSrc:Array<String>):Program {
		
		var gl = WebGLRenderer.gl;
		var fragmentShader = CompileFragmentShader(gl, fragmentSrc);
		var vertexShader = CompileVertexShader(gl, vertexSrc);
		
		var shaderProgram = gl.createProgram();
		
		gl.attachShader(shaderProgram, vertexShader);
		gl.attachShader(shaderProgram, fragmentShader);
		gl.linkProgram(shaderProgram);
		
		if (gl.getProgramParameter(shaderProgram, GL.LINK_STATUS) == 0) {
			Lib.alert("Could not initialise shaders");
		}
		
		return shaderProgram;
		
	} 
	
	
	private static function CompileVertexShader (gl:GL, shaderSrc:Array<String>):Shader {
		
		return _CompileShader(gl, shaderSrc, GL.VERTEX_SHADER);
		
	}
	
	
	public static function initDefaultShader ():Void {
		
		var gl = WebGLRenderer.gl;
		var shaderProgram = compileProgram(shaderVertexSrc, shaderFragmentSrc);
		
		gl.useProgram(shaderProgram);
		
		untyped (shaderProgram).vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
		untyped (shaderProgram).projectionVector = gl.getUniformLocation(shaderProgram, "projectionVector");
		untyped (shaderProgram).textureCoordAttribute = gl.getAttribLocation(shaderProgram, "aTextureCoord");
		untyped (shaderProgram).colorAttribute = gl.getAttribLocation(shaderProgram, "aColor");
		
		//shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
		untyped (shaderProgram).samplerUniform = gl.getUniformLocation(shaderProgram, "uSampler");
		
		WebGLShaders.shaderProgram = shaderProgram;
		
	}
	
	
	public static function initDefaultStripShader ():Void {
		
		var gl = WebGLRenderer.gl;
		var shaderProgram = compileProgram(stripShaderVertexSrc, stripShaderFragmentSrc);
		
		gl.useProgram(shaderProgram);
		
		untyped (shaderProgram).vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
		untyped (shaderProgram).projectionVector = gl.getUniformLocation(shaderProgram, "projectionVector");
		untyped (shaderProgram).textureCoordAttribute = gl.getAttribLocation(shaderProgram, "aTextureCoord");
		untyped (shaderProgram).translationMatrix = gl.getUniformLocation(shaderProgram, "translationMatrix");
		untyped (shaderProgram).alpha = gl.getUniformLocation(shaderProgram, "alpha");
		
		untyped (shaderProgram).colorAttribute = gl.getAttribLocation(shaderProgram, "aColor");
		
		untyped (shaderProgram).projectionVector = gl.getUniformLocation(shaderProgram, "projectionVector");
		
		untyped (shaderProgram).samplerUniform = gl.getUniformLocation(shaderProgram, "uSampler");
		
		stripShaderProgram = shaderProgram;
		
	}
	
	
	public static function initPrimitiveShader ():Void {
		
		var gl = WebGLRenderer.gl;
		
		var shaderProgram = compileProgram(primitiveShaderVertexSrc, primitiveShaderFragmentSrc);
		
		gl.useProgram(shaderProgram);
		
		untyped (shaderProgram).vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
		untyped (shaderProgram).colorAttribute = gl.getAttribLocation(shaderProgram, "aColor");
		
		untyped (shaderProgram).projectionVector = gl.getUniformLocation(shaderProgram, "projectionVector");
		untyped (shaderProgram).translationMatrix = gl.getUniformLocation(shaderProgram, "translationMatrix");
		
		untyped (shaderProgram).alpha = gl.getUniformLocation(shaderProgram, "alpha");
		
		primitiveProgram = shaderProgram;
		
	}
	
	
	private static function _CompileShader (gl:GL, shaderSrc:Array<String>, shaderType:Int):Shader {
		
		var src = shaderSrc.join("\n");
		var shader = gl.createShader(shaderType);
		gl.shaderSource(shader, src);
		gl.compileShader(shader);
		
		if (gl.getShaderParameter(shader, GL.COMPILE_STATUS) == 0) {
			Lib.alert(gl.getShaderInfoLog(shader));
			return null;
		}
		
		return shader;
		
	}
	
	
}