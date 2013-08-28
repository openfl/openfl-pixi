package flash.display;


class Stage extends pixi.display.Stage {
	
	
	public var stageHeight (get, null):Int;
	public var stageWidth (get, null):Int;
	
	
	public function new (backgroundColor:Int, interactive:Bool = false) {
		
		super (backgroundColor, interactive);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_stageHeight ():Int {
		
		return DocumentClass.__renderer.height;
		
	}
	
	
	private function get_stageWidth ():Int {
		
		return DocumentClass.__renderer.width;
		
	}
	
	
}