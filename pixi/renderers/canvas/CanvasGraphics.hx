package pixi.renderers.canvas;


import js.html.CanvasRenderingContext2D;
import pixi.primitives.Graphics;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class CanvasGraphics {
	
	
	/**
	 * A set of functions used by the canvas renderer to draw the primitive graphics data
	 *
	 * @class CanvasGraphics
	 */
	public function new () {
		
		
		
	}
	
	
	/*
	 * Renders the graphics object
	 *
	 * @static
	 * @private
	 * @method renderGraphics
	 * @param graphics {Graphics}
	 * @param context {Context2D}
	 */
	public static function renderGraphics (graphics:Graphics, context:CanvasRenderingContext2D):Void {
		
		var worldAlpha = graphics.worldAlpha;
		
		for (i in 0...graphics.graphicsData.length) 
		{
			var data = graphics.graphicsData[i];
			var points = data.points;
			var color = "";
			
			context.strokeStyle = color = '#' + StringTools.hex (data.lineColor, 6);
			
			context.lineWidth = data.lineWidth;
			
			if(data.type == Graphics.POLY)
			{
				context.beginPath();
				
				context.moveTo(points[0], points[1]);
				
				for (j in 1...Math.round(points.length/2))
				{
					context.lineTo(points[j * 2], points[j * 2 + 1]);
				} 
				
				// if the first and last point are the same close the path - much neater :)
				if(points[0] == points[points.length-2] && points[1] == points[points.length-1])
				{
					context.closePath();
				}
				
				if(data.fill)
				{
					context.globalAlpha = data.fillAlpha * worldAlpha;
					context.fillStyle = color = '#' + StringTools.hex (data.fillColor, 6);
					context.fill();
				}
				if(data.lineWidth > 0)
				{
					context.globalAlpha = data.lineAlpha * worldAlpha;
					context.stroke();
				}
			}
			else if(data.type == Graphics.RECT)
			{
					
				// TODO - need to be Undefined!
				if(true /*data.fillColor*/)
				{
					context.globalAlpha = data.fillAlpha * worldAlpha;
					context.fillStyle = color = '#' + StringTools.hex (data.fillColor, 6);
					context.fillRect(points[0], points[1], points[2], points[3]);
					
				}
				if(data.lineWidth > 0)
				{
					context.globalAlpha = data.lineAlpha * worldAlpha;
					context.strokeRect(points[0], points[1], points[2], points[3]);
				}
				
			}
			else if(data.type == Graphics.CIRC)
			{
				// TODO - need to be Undefined!
				context.beginPath();
				context.arc(points[0], points[1], points[2],0,2*Math.PI, false);
				context.closePath();
				
				if(data.fill)
				{
					context.globalAlpha = data.fillAlpha * worldAlpha;
					context.fillStyle = color = '#' + StringTools.hex (data.fillColor, 6);
					context.fill();
				}
				if(data.lineWidth > 0)
				{
					context.globalAlpha = data.lineAlpha * worldAlpha;
					context.stroke();
				}
			}
			else if(data.type == Graphics.ELIP)
			{
				
				// elipse code taken from: http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas
				
				var elipseData =  data.points;
				
				var w = elipseData[2] * 2;
				var h = elipseData[3] * 2;
				
				var x = elipseData[0] - w/2;
				var y = elipseData[1] - h/2;
				
				context.beginPath();
				
				var kappa = .5522848,
				ox = (w / 2) * kappa, // control point offset horizontal
				oy = (h / 2) * kappa, // control point offset vertical
				xe = x + w,           // x-end
				ye = y + h,           // y-end
				xm = x + w / 2,       // x-middle
				ym = y + h / 2;       // y-middle
				
				context.moveTo(x, ym);
				context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
				context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
				context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
				context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
				
				context.closePath();
				
				if(data.fill)
				{
					context.globalAlpha = data.fillAlpha * worldAlpha;
					context.fillStyle = color = '#' + StringTools.hex (data.fillColor, 6);
					context.fill();
				}
				if(data.lineWidth > 0)
				{
					context.globalAlpha = data.lineAlpha * worldAlpha;
					context.stroke();
				}
			}
			
		}
		
	}
	
	
	/*
	 * Renders a graphics mask
	 *
	 * @static
	 * @private
	 * @method renderGraphicsMask
	 * @param graphics {Graphics}
	 * @param context {Context2D}
	 */
	public static function renderGraphicsMask (graphics:Graphics, context:CanvasRenderingContext2D):Void {
		
		var worldAlpha = graphics.worldAlpha;
		
		var len = graphics.graphicsData.length;
		if(len > 1)
		{
			len = 1;
			trace ("Pixi.js warning: masks in canvas can only mask using the first path in the graphics object");
		}
		
		for (i in 0...1) 
		{
			var data = graphics.graphicsData[i];
			var points = data.points;
			
			if(data.type == Graphics.POLY)
			{
				context.beginPath();
				context.moveTo(points[0], points[1]);
				
				for (j in 1...Math.round (points.length/2))
				{
					context.lineTo(points[j * 2], points[j * 2 + 1]);
				} 
				
				// if the first and last point are the same close the path - much neater :)
				if(points[0] == points[points.length-2] && points[1] == points[points.length-1])
				{
					context.closePath();
				}
				
			}
			else if(data.type == Graphics.RECT)
			{
				context.beginPath();
				context.rect(points[0], points[1], points[2], points[3]);
				context.closePath();
			}
			else if(data.type == Graphics.CIRC)
			{
				// TODO - need to be Undefined!
				context.beginPath();
				context.arc(points[0], points[1], points[2],0,2*Math.PI, false);
				context.closePath();
			}
			else if(data.type == Graphics.ELIP)
			{
				
				// elipse code taken from: http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas
				var elipseData =  data.points;
				
				var w = elipseData[2] * 2;
				var h = elipseData[3] * 2;
				
				var x = elipseData[0] - w/2;
				var y = elipseData[1] - h/2;
				
				context.beginPath();
				
				var kappa = .5522848,
				ox = (w / 2) * kappa, // control point offset horizontal
				oy = (h / 2) * kappa, // control point offset vertical
				xe = x + w,           // x-end
				ye = y + h,           // y-end
				xm = x + w / 2,       // x-middle
				ym = y + h / 2;       // y-middle
				
				context.moveTo(x, ym);
				context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
				context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
				context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
				context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
				context.closePath();
			}
			
			
		}
		
	}
	
	
}