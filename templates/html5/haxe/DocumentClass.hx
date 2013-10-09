import ::APP_MAIN_PACKAGE::::APP_MAIN_CLASS::;
import flash.display.Stage;
import flash.events.Event;
import js.Browser;
import pixi.utils.Detector;


class DocumentClass extends ::APP_MAIN_CLASS:: {
	
	
	public static var __renderer:Dynamic;
	public static var __stage:Stage;
	
	
	public function new () {
		
		if (__stage == null) {
			
			__stage = new Stage (0x::WIN_FLASHBACKGROUND::);
        	__renderer = Detector.autoDetectRenderer (::WIN_WIDTH::, ::WIN_HEIGHT::);
        	Browser.document.body.appendChild (__renderer.view);
        	
    	}
    	
    	this.stage = __stage;
        
		super ();
		
		__stage.addChild (this);
		Browser.window.requestAnimationFrame (__enterFrame);
		
	}
	
	
	private function __enterFrame (_) {
		
        Browser.window.requestAnimationFrame (__enterFrame);
        dispatchEvent (new Event (Event.ENTER_FRAME));
        __renderer.render (__stage);
        
        return true;
		
	}
	
	
}