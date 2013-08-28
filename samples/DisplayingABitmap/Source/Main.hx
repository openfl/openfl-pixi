package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		#if pixi
		var bitmapData = BitmapData.fromImage ("assets/openfl.png");
		#else
		var bitmapData = openfl.Assets.getBitmapData ("assets/openfl.png");
		#end
		
		var bitmap = new Bitmap (bitmapData);
		addChild (bitmap);
		
	}
	
	
}