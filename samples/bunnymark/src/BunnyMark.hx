package;


import js.html.CanvasElement;
import js.html.DivElement;
import js.html.ImageElement;
import js.Browser;
import pixi.display.DisplayObjectContainer;
import pixi.display.Sprite;
import pixi.display.Stage;
import pixi.renderers.webgl.WebGLRenderer;
import pixi.textures.Texture;
import pixi.utils.Detector;


class BunnyMark {
	
	
	public var canvas:CanvasElement;
	public var renderer:Dynamic;
	public var stage:Stage;
	public var width:Int;
	public var height:Int;
	
	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;
	private var bunniesRate:Int;
	private var bunnyTexture:Texture;
	private var clickImage:ImageElement;
	private var container:DisplayObjectContainer;
	private var counter:DivElement;
	private var maxX:Float;
	private var maxY:Float;
	private var minX:Float;
	private var minY:Float;
	private var numBunnies:Int;
	private var pixiLogo:ImageElement;
	private var stats:Dynamic;
	
	
	
	public function new () {
		
		initialize ();
		construct ();
		
	}
	
	
	private function construct () {
		
		canvas.width = width;
		canvas.height = height;
		
		if (Std.is (renderer, WebGLRenderer)) {
			
			bunniesRate = 10;
			
		} else {
			
			bunniesRate = 5;
			renderer.context.mozImageSmoothingEnabled = false;
			renderer.context.webkitImageSmoothingEnabled = false;
			
		}
		
		renderer.view.style.transform = "translatez(0)";
		renderer.view.style.position = "absolute";
		Browser.document.body.appendChild (renderer.view);
		stats.domElement.style.position = "absolute";
		stats.domElement.style.top = "0px";
		Browser.document.body.appendChild (stats.domElement);
		counter.innerHTML = "10 BUNNIES";
		counter.className = "counter";
		Browser.document.body.appendChild (counter);
		
		for (i in 0...10) {
			
			var bunny = new Bunny ();
			bunny.speedX = Math.random () * 10;
			bunny.speedY = (Math.random () * 10) - 5;
			bunny.anchor.x = 0.5;
			bunny.anchor.y = 1;
			bunnies.push (bunny);
			container.addChild (bunny);
			
		}
		
		stage.addChild (container);
		
		Browser.window.requestAnimationFrame (cast update);
		
		renderer.view.addEventListener ("mousedown", this_onTouchStart);
		renderer.view.addEventListener ("mouseup", this_onTouchEnd);
		Browser.document.addEventListener ("touchstart", this_onTouchStart, true);
		Browser.document.addEventListener ("touchend", this_onTouchEnd, true);
		Browser.window.addEventListener ("resize", this_onResize);
		
		resize ();
		
	}
	
	
	private function initialize () {
		
		numBunnies = 0;
		bunnies = new Array<Bunny> ();
		container = new DisplayObjectContainer ();
		renderer = Detector.autoDetectRenderer (800, 600);
		stage = new Stage (0xFFFFFF);
		stats = untyped __js__("new Stats ()");
		
		canvas = cast Browser.document.createElement ("canvas");
		counter = cast Browser.document.createElement ("div");
		pixiLogo = cast Browser.document.getElementById ("pixi");
		clickImage = cast Browser.document.getElementById ("clickImage");
		
	}
	
	
	private function resize () {
		
		var width = Browser.document.width; 
		var height = Browser.document.height; 
		
		if (width > 800) width  = 800;
		if (height > 600) height = 600;
		
		maxX = width;
		minX = 0;
		maxY = height;
		minY = 0;
		
		var w = Browser.document.width / 2 - width / 2;
		var h = Browser.document.height / 2 - height / 2;
		
		renderer.view.style.left = (Browser.document.width / 2 - width / 2) + "px";
		renderer.view.style.top = (Browser.document.height / 2 - height / 2) + "px";
		stats.domElement.style.left = w + "px";
		stats.domElement.style.top = h + "px";
		counter.style.left = w + "px";
		counter.style.top = h + 49 + "px";
		pixiLogo.style.right = w  + "px";
		pixiLogo.style.bottom = h + 8  + "px";
		clickImage.style.right = w + 108 + "px";
		clickImage.style.bottom = h + 17  + "px";
		
		renderer.resize (width, height);
		
	}
	
	
	private function update () {
		
		stats.begin ();
		
		if (addingBunnies) {
			
			for (i in 0...bunniesRate) {
				
				var bunny = new Bunny ();
				bunny.speedX = Math.random () * 10;
				bunny.speedY = (Math.random () * 10) - 5;
				bunny.anchor.y = 1;
				bunnies.push (bunny);
				bunny.scale.y = 1;
				container.addChild (bunny);
				numBunnies++;
				
			}
			
			counter.innerHTML = numBunnies + " BUNNIES";
			
		}
		
		for (i in 0...bunnies.length) {
			
			var bunny = bunnies[i];
			
			bunny.position.x += bunny.speedX;
			bunny.position.y += bunny.speedY;
			bunny.speedY += 0.75;
			
			if (bunny.position.x > maxX) {
				
				bunny.speedX *= -1;
				bunny.position.x = maxX;
				
			} else if (bunny.position.x < minX) {
				
				bunny.speedX *= -1;
				bunny.position.x = minX;
				
			}
			
			if (bunny.position.y > maxY) {
				
				bunny.speedY *= -0.85;
				bunny.position.y = maxY;
				bunny.spin = (Math.random () - 0.5) * 0.2;
				
				if (Math.random () > 0.5) {
					
					bunny.speedY -= Math.random () * 6;
					
				}
				
			} else if (bunny.position.y < minY) {
				
				bunny.speedY = 0;
				bunny.position.y = minY;
				
			}
			
		}

		renderer.render (stage);
		Browser.window.requestAnimationFrame (cast update);
		stats.end ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onResize (event) {
		
		resize ();
		
	}
	
	
	private function this_onTouchEnd (event) {
		
		addingBunnies = false;
		
	}
	
	
	private function this_onTouchStart (event) {
		
		addingBunnies = true;
		
	}
	
	
	
	
	// Entry Point
	
	
	
	
	public static function main () {
		
		new BunnyMark ();
			
	}
	
	
}




class Bunny extends Sprite {
	
	
	private static var bunnyTexture:Texture;
	
	public var speedX:Float;
	public var speedY:Float;
	public var spin:Float;
	
	
	public function new () {
		
		if (bunnyTexture == null) {
			
			bunnyTexture = Texture.fromImage ("bunny.png");
			
		}
		
		super (bunnyTexture);
		
	}
	
	
}