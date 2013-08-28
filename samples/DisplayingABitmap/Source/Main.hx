package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


class Main extends Sprite {
	
	
	private var bitmap:Bitmap;
	
	
	public function new () {
		
		super ();
		
		#if pixi
		
		bitmap = new Bitmap (BitmapData.fromImage ("assets/openfl.png"));
		bitmap.position.x = 100;
		bitmap.position.y = 100;
		
		#else
		
		var bitmap = new Bitmap (openfl.Assets.getBitmapData ("assets/openfl.png"));
		bitmap.x = 100;
		bitmap.y = 200;
		
		#end
		
		addChild (bitmap);
		
		addEventListener ("enterFrame", this_onEnterFrame);
		
	}
	
	
	private function this_onEnterFrame (event) {
		
		bitmap.rotation += 1 #if pixi * (Math.PI / 180) #end;
		
	}
	
	
}