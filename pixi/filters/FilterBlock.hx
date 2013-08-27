package pixi.filters;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class FilterBlock {
	
	
	public var graphics:Dynamic;
	public var visible:Bool;
	public var renderable:Bool;
	
	public var first:Dynamic;
	public var last:Dynamic;
	public var mask:Dynamic;
	public var open:Dynamic;
	public var _iPrev:Dynamic;
	public var _iNext:Dynamic;
	public var __renderGroup:Dynamic;
	
	
	public function new (mask = null) {
		
		this.graphics = mask;
		this.visible = true;
		this.renderable = true;
		
	}
	
	
}