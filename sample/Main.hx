package ;


import pixi.display.Sprite;
import pixi.display.Stage;
import pixi.renderers.canvas.CanvasRenderer;
import pixi.textures.Texture;
import js.Browser;


class Main {
    
    
    private static var bunny:Sprite;
    private static var renderer:CanvasRenderer;
    private static var stage:Stage;
    
    
    public static function main () {
    	
    	stage = new Stage (0x66FF99);
        //var renderer = PIXI.autoDetectRenderer(400, 300);
        renderer = new CanvasRenderer (400, 300);
        
        Browser.document.body.appendChild (renderer.view);
        //requestAnimFrame (animate);
        
        var texture = Texture.fromImage ("bunny.png");
        bunny = new Sprite (texture);
        
        bunny.anchor.x = 0.5;
        bunny.anchor.y = 0.5;
        
        bunny.position.x = 200;
        bunny.position.y = 150;
        
        stage.addChild (bunny);
        
        Browser.window.requestAnimationFrame (cast animate);
    	
    }
    
    
    private static function animate () {
        
        Browser.window.requestAnimationFrame (cast animate);
        
        bunny.rotation += 0.1;  
        renderer.render (stage);
        
    }
    
    
}