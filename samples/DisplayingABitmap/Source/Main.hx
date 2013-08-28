package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		#if pixi
		var bitmap = new Bitmap (BitmapData.fromImage ("assets/openfl.png"));
		bitmap.width = 400;
		bitmap.height = 400;
		#else
		var bitmap = new Bitmap (openfl.Assets.getBitmapData ("assets/openfl.png"));
		#end
		addChild (bitmap);
		
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;
		
	}
	
	
}