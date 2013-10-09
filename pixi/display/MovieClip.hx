package pixi.display;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class MovieClip extends Bitmap {
	
	
	/**
	 * The speed that the MovieClip will play at. Higher is faster, lower is slower
	 *
	 * @property animationSpeed
	 * @type Number
	 * @default 1
	 */
	public var animationSpeed:Float;
	
	/**
	 * [read-only] The index MovieClips current frame (this may not have to be a whole number)
	 *
	 * @property currentFrame
	 * @type Number
	 * @default 0
	 * @readOnly
	 */
	public var currentFrame (default, null):Int;
	
	/**
	 * Whether or not the movie clip repeats after playing.
	 *
	 * @property loop
	 * @type Boolean
	 * @default true
	 */
	public var loop:Bool;
	
	/**
	 * Function to call when a MovieClip finishes playing
	 *
	 * @property onComplete
	 * @type Function
	 */
	public var onComplete:Dynamic;
	
	/**
	 * [read-only] Indicates if the MovieClip is currently playing
	 *
	 * @property playing
	 * @type Boolean
	 * @readOnly
	 */
	public var playing (default, null):Bool;
	
	/**
	 * The array of textures that make up the animation
	 *
	 * @property textures
	 * @type Array
	 */
	public var textures:Array<Dynamic>;
	
	
	/**
	 * A MovieClip is a simple way to display an animation depicted by a list of textures.
	 *
	 * @class MovieClip
	 * @extends Sprite
	 * @constructor
	 * @param textures {Array<Texture>} an array of {Texture} objects that make up the animation
	 */
	public function new (textures:Array<Texture>) {
		
		super (textures[0]);
		
		this.textures = textures;
		this.animationSpeed = 1;
		this.loop = true;
		this.onComplete = null;
		this.currentFrame = 0; 
		this.playing = false;
		
	}
	
	
	/**
	 * Goes to a specific frame and begins playing the MovieClip
	 *
	 * @method gotoAndPlay
	 * @param frameNumber {Number} frame index to start at
	 */
	public function gotoAndPlay (frameNumber:Float):Void {
		
		this.currentFrame = frameNumber;
		this.playing = true;
		
	}
	
	
	/**
	 * Stops the MovieClip and goes to a specific frame
	 *
	 * @method gotoAndStop
	 * @param frameNumber {Number} frame index to stop at
	 */
	public function gotoAndStop (frameNumber:Float):Void {
		
		this.playing = false;
		this.currentFrame = frameNumber;
		var round = (this.currentFrame + 0.5) | 0;
		this.setTexture(this.textures[round % this.textures.length]);
		
	}
	
	
	/**
	 * Plays the MovieClip
	 *
	 * @method play
	 */
	public function play ():Void {
		
		this.playing = true;
		
	}
	
	
	/**
	 * Stops the MovieClip
	 *
	 * @method stop
	 */
	public function stop ():Void {
		
		this.playing = false;
		
	}
	
	
	/*
	 * Updates the object transform for rendering
	 *
	 * @method updateTransform
	 * @private
	 */
	private override function updateTransform ():Void {
		
		super.updateTransform(this);
		
		if(!this.playing)return;
		
		this.currentFrame += this.animationSpeed;
		
		var round = (this.currentFrame + 0.5) | 0;
		
		if(this.loop || round < this.textures.length)
		{
			this.setTexture(this.textures[round % this.textures.length]);
		}
		else if(round >= this.textures.length)
		{
			this.gotoAndStop(this.textures.length - 1);
			if(this.onComplete)
			{
				this.onComplete();
			}
		}
		
	}
	
	
}