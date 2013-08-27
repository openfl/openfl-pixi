package pixi.renderers.webgl;


import js.html.webgl.GL;
import js.html.Float32Array;
import js.html.Uint16Array;
import pixi.core.Matrix;
import pixi.core.Point;
import pixi.primitives.Graphics;
import pixi.utils.PolyK;
import pixi.utils.Utils;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class WebGLGraphics {
	
	
	/**
	 * A set of functions used by the webGL renderer to draw the primitive graphics data
	 *
	 * @class CanvasGraphics
	 */
	public function new () {
		
		
		
	}
	
	
	/**
	 * Builds a circle to draw
	 *
	 * @static
	 * @private
	 * @method buildCircle
	 * @param graphics {Graphics}
	 * @param webGLData {Object}
	 */
	private static function buildCircle (graphicsData:Graphics, webGLData:Dynamic):Void {
		
		// --- //
		// need to convert points to a nice regular data
		// 
		var rectData:Array<Dynamic> = graphicsData.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		var totalSegs = 40;
		var seg = (Math.PI * 2) / totalSegs ;
			
		if(true /*graphicsData.fill*/)
		{
			var color = Utils.HEXtoRGB(graphicsData.fillColor);
			var alpha = graphicsData.fillAlpha;
			
			var r = color[0] * alpha;
			var g = color[1] * alpha;
			var b = color[2] * alpha;
			
			var verts:Array<Dynamic> = webGLData.points;
			var indices:Array<Dynamic> = webGLData.indices;
			
			var vecPos = verts.length/6;
			
			indices.push(vecPos);
			
			for (i in 0...(totalSegs + 1)) 
			{
				verts = verts.concat([x,y, r, g, b, alpha]);
				
				verts = verts.concat([x + Math.sin(seg * i) * width,
						   y + Math.cos(seg * i) * height,
						   r, g, b, alpha]);
				
				indices.push (vecPos++);
				indices.push (vecPos++);
			};
			
			indices.push(vecPos-1);
		}
		
		if(graphicsData.lineWidth > 0)
		{
			graphicsData.points = [];
			
			for (i in 0...(totalSegs + 1)) 
			{
				graphicsData.points.push(x + Math.sin(seg * i) * width);
				graphicsData.points.push(y + Math.cos(seg * i) * height);
			};
			
			WebGLGraphics.buildLine(graphicsData, webGLData);
		}
		
	}
	
	
	/**
	 * Builds a line to draw
	 *
	 * @static
	 * @private
	 * @method buildLine
	 * @param graphics {Graphics}
	 * @param webGLData {Object}
	 */
	private static function buildLine (graphicsData:Graphics, webGLData:Dynamic):Void {
		
		// TODO OPTIMISE!
		
		var wrap = true;
		var points:Array<Dynamic> = graphicsData.points;
		if(points.length == 0)return;
		
		// get first and last point.. figure out the middle!
		var firstPoint = new Point( points[0], points[1] );
		var lastPoint = new Point( points[points.length - 2], points[points.length - 1] );
		
		// if the first point is the last point - goona have issues :)
		if(firstPoint.x == lastPoint.x && firstPoint.y == lastPoint.y)
		{
			points.pop();
			points.pop();
			
			lastPoint = new Point( points[points.length - 2], points[points.length - 1] );
			
			var midPointX = lastPoint.x + (firstPoint.x - lastPoint.x) *0.5;
			var midPointY = lastPoint.y + (firstPoint.y - lastPoint.y) *0.5;
			
			points.unshift(midPointY);
			points.unshift(midPointX);
			points.push(midPointX);
			points.push(midPointY);
		}
		
		var verts:Array<Dynamic> = webGLData.points;
		var indices:Array<Dynamic> = webGLData.indices;
		var length = Std.int(points.length / 2);
		var indexCount = points.length;
		var indexStart = verts.length/6;
		
		// DRAW the Line
		var width = graphicsData.lineWidth / 2;
		
		// sort color
		var color = Utils.HEXtoRGB(graphicsData.lineColor);
		var alpha = graphicsData.lineAlpha;
		var r = color[0] * alpha;
		var g = color[1] * alpha;
		var b = color[2] * alpha;
		
		var px, py, p1x, p1y, p2x, p2y, p3x, p3y;
		var perpx:Float, perpy:Float, perp2x:Float, perp2y:Float, perp3x:Float, perp3y:Float;
		var ipx, ipy;
		var a1, b1, c1, a2, b2, c2;
		var denom, pdist, dist;
		
		p1x = points[0];
		p1y = points[1];
		
		p2x = points[2];
		p2y = points[3];
		
		perpx = -(p1y - p2y);
		perpy =  p1x - p2x;
		
		dist = Math.sqrt(perpx*perpx + perpy*perpy);
		
		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;
		
		// start
		verts = verts.concat([p1x - perpx , p1y - perpy,
					r, g, b, alpha]);
		
		verts = verts.concat([p1x + perpx , p1y + perpy,
					r, g, b, alpha]);
		
		for (i in 1...length-1) 
		{
			p1x = points[(i-1)*2];
			p1y = points[(i-1)*2 + 1];
			
			p2x = points[(i)*2];
			p2y = points[(i)*2 + 1];
			
			p3x = points[(i+1)*2];
			p3y = points[(i+1)*2 + 1];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			
			dist = Math.sqrt(perpx*perpx + perpy*perpy);
			perpx /= dist;
			perpy /= dist;
			perpx *= width;
			perpy *= width;
			
			perp2x = -(p2y - p3y);
			perp2y = p2x - p3x;
			
			dist = Math.sqrt(perp2x*perp2x + perp2y*perp2y);
			perp2x /= dist;
			perp2y /= dist;
			perp2x *= width;
			perp2y *= width;
			
			a1 = (-perpy + p1y) - (-perpy + p2y);
			b1 = (-perpx + p2x) - (-perpx + p1x);
			c1 = (-perpx + p1x) * (-perpy + p2y) - (-perpx + p2x) * (-perpy + p1y);
			a2 = (-perp2y + p3y) - (-perp2y + p2y);
			b2 = (-perp2x + p2x) - (-perp2x + p3x);
			c2 = (-perp2x + p3x) * (-perp2y + p2y) - (-perp2x + p2x) * (-perp2y + p3y);
			
			denom = a1*b2 - a2*b1;
			
			if (denom == 0) {
				denom+=1;
			}
			
			px = (b1*c2 - b2*c1)/denom;
			py = (a2*c1 - a1*c2)/denom;
			
			pdist = (px -p2x) * (px -p2x) + (py -p2y) + (py -p2y);
			
			if(pdist > 140 * 140)
			{
				perp3x = perpx - perp2x;
				perp3y = perpy - perp2y;
				
				dist = Math.sqrt(perp3x*perp3x + perp3y*perp3y);
				perp3x /= dist;
				perp3y /= dist;
				perp3x *= width;
				perp3y *= width;
				
				verts = verts.concat([p2x - perp3x, p2y -perp3y]);
				verts = verts.concat([r, g, b, alpha]);
				
				verts = verts.concat([p2x + perp3x, p2y +perp3y]);
				verts = verts.concat([r, g, b, alpha]);
				
				verts = verts.concat([p2x - perp3x, p2y -perp3y]);
				verts = verts.concat([r, g, b, alpha]);
				
				indexCount++;
			}
			else
			{
				verts = verts.concat([px , py]);
				verts = verts.concat([r, g, b, alpha]);
				
				verts = verts.concat([p2x - (px-p2x), p2y - (py - p2y)]);
				verts = verts.concat([r, g, b, alpha]);
			}
		}
		
		p1x = points[(length-2)*2];
		p1y = points[(length-2)*2 + 1];
		
		p2x = points[(length-1)*2];
		p2y = points[(length-1)*2 + 1];
		
		perpx = -(p1y - p2y);
		perpy = p1x - p2x;
		
		dist = Math.sqrt(perpx*perpx + perpy*perpy);
		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;
		
		verts = verts.concat([p2x - perpx , p2y - perpy]);
		verts = verts.concat([r, g, b, alpha]);
		
		verts = verts.concat([p2x + perpx , p2y + perpy]);
		verts = verts.concat([r, g, b, alpha]);
		
		indices.push(indexStart);
		
		for (i in 0...indexCount) 
		{
			indices.push(indexStart++);
		};
		
		indices.push(indexStart-1);
		
	}
	
	
	/**
	 * Builds a polygon to draw
	 *
	 * @static
	 * @private
	 * @method buildPoly
	 * @param graphics {Graphics}
	 * @param webGLData {Object}
	 */
	private static function buildPoly (graphicsData:Graphics, webGLData:Dynamic):Void {
		
		var points:Array<Float> = graphicsData.points;
		if(points.length < 6)return;
		
		// get first and last point.. figure out the middle!
		var verts:Array<Dynamic> = webGLData.points;
		var indices:Array<Dynamic> = webGLData.indices;
		
		var length = Std.int (points.length / 2);
		
		// sort color
		var color = Utils.HEXtoRGB(graphicsData.fillColor);
		var alpha = graphicsData.fillAlpha;
		var r = color[0] * alpha;
		var g = color[1] * alpha;
		var b = color[2] * alpha;
		
		var triangles = PolyK.Triangulate(points);
		
		var vertPos = verts.length / 6;
		
		var i = 0;
		while (i < triangles.length) 
		{
			indices.push(triangles[i] + vertPos);
			indices.push(triangles[i] + vertPos);
			indices.push(triangles[i+1] + vertPos);
			indices.push(triangles[i+2] +vertPos);
			indices.push(triangles[i+2] + vertPos);
			i+=3;
		};
		
		for (i in 0...length) 
		{
			verts = verts.concat ([ points[i * 2], points[i * 2 + 1],
					   r, g, b, alpha ]);
		};
		
	}
	
	
	/**
	 * Builds a rectangle to draw
	 *
	 * @static
	 * @private
	 * @method buildRectangle
	 * @param graphics {Graphics}
	 * @param webGLData {Object}
	 */
	private static function buildRectangle (graphicsData:Graphics, webGLData:Dynamic):Void {
		
		// --- //
		// need to convert points to a nice regular data
		// 
		var rectData:Array<Dynamic> = graphicsData.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		if(true /*graphicsData.fill*/)
		{
			var color = Utils.HEXtoRGB(graphicsData.fillColor);
			var alpha = graphicsData.fillAlpha;
			
			var r = color[0] * alpha;
			var g = color[1] * alpha;
			var b = color[2] * alpha;
		
			var verts:Array<Dynamic> = webGLData.points;
			var indices:Array<Dynamic> = webGLData.indices;
		
			var vertPos = verts.length/6;
			
			// start
			verts = verts.concat([x, y]);
			verts = verts.concat([r, g, b, alpha]);
			
			verts = verts.concat([x + width, y]);
			verts = verts.concat([r, g, b, alpha]);
			
			verts = verts.concat([x , y + height]);
			verts = verts.concat([r, g, b, alpha]);
			
			verts = verts.concat([x + width, y + height]);
			verts = verts.concat([r, g, b, alpha]);
			
			// insert 2 dead triangles..
			indices = indices.concat([vertPos, vertPos, vertPos+1, vertPos+2, vertPos+3, vertPos+3]);
		}
		
		if(graphicsData.lineWidth > 0)
		{
			graphicsData.points = [x, y,
					  x + width, y,
					  x + width, y + height,
					  x, y + height,
					  x, y];
		
			WebGLGraphics.buildLine(graphicsData, webGLData);
		}
		
	}
	
	
	/**
	 * Renders the graphics object
	 *
	 * @static
	 * @private
	 * @method renderGraphics
	 * @param graphics {Graphics}
	 * @param projection {Object}
	 */
	public static function renderGraphics (graphics:Graphics, projection:Point):Void {
		
		var gl = Pixi.gl;
		
		if(!graphics._webGL)graphics._webGL = {points:[], indices:[], lastIndex:0, 
											   buffer:gl.createBuffer(),
											   indexBuffer:gl.createBuffer()};
		
		if(graphics.dirty)
		{
			graphics.dirty = false;
			
			if(graphics.clearDirty)
			{
				graphics.clearDirty = false;
				
				graphics._webGL.lastIndex = 0;
				graphics._webGL.points = [];
				graphics._webGL.indices = [];
				
			}
			
			WebGLGraphics.updateGraphics(graphics);
		}
		
		WebGLShaders.activatePrimitiveShader();
		
		// This  could be speeded up fo sure!
		var m = Mat3.clone(graphics.worldTransform);
		
		Mat3.transpose(m);
		
		// set the matrix transform for the 
	 	gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	 	
	 	gl.uniformMatrix3fv(untyped (WebGLShaders.primitiveProgram).translationMatrix, false, m);
	 	
		gl.uniform2f(untyped (WebGLShaders.primitiveProgram).projectionVector, projection.x, projection.y);
		
		gl.uniform1f(untyped (WebGLShaders.primitiveProgram).alpha, graphics.worldAlpha);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, graphics._webGL.buffer);
		
		// WHY DOES THIS LINE NEED TO BE THERE???
		gl.vertexAttribPointer(untyped (WebGLShaders.primitiveProgram).vertexPositionAttribute, 2, GL.FLOAT, false, 0, 0);
		// its not even used.. but need to be set or it breaks?
		// only on pc though..
		
		gl.vertexAttribPointer(untyped (WebGLShaders.primitiveProgram).vertexPositionAttribute, 2, GL.FLOAT, false, 4 * 6, 0);
		gl.vertexAttribPointer(untyped (WebGLShaders.primitiveProgram).colorAttribute, 4, GL.FLOAT, false,4 * 6, 2 * 4);
		
		// set the index buffer!
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, graphics._webGL.indexBuffer);
		
		gl.drawElements(GL.TRIANGLE_STRIP,  graphics._webGL.indices.length, GL.UNSIGNED_SHORT, 0 );
		
		// return to default shader...
		WebGLShaders.activateDefaultShader();
		
	}
	
	
	/**
	 * Updates the graphics object
	 *
	 * @static
	 * @private
	 * @method updateGraphics
	 * @param graphics {Graphics}
	 */
	public static function updateGraphics (graphics:Graphics):Void {
		
		for (i in graphics._webGL.lastIndex...graphics.graphicsData.length) 
		{
			var data:Graphics = graphics.graphicsData[i];
			
			if(data.type == Graphics.POLY)
			{
				if(true /*data.fill*/)
				{
					if(data.points.length>3) 
					WebGLGraphics.buildPoly(data, graphics._webGL);
				}
				
				if(data.lineWidth > 0)
				{
					WebGLGraphics.buildLine(data, graphics._webGL);
				}
			}
			else if(data.type == Graphics.RECT)
			{
				WebGLGraphics.buildRectangle(data, graphics._webGL);
			}
			else if(data.type == Graphics.CIRC || data.type == Graphics.ELIP)
			{
				WebGLGraphics.buildCircle(data, graphics._webGL);
			}
		};
		
		graphics._webGL.lastIndex = graphics.graphicsData.length;
		
		var gl = Pixi.gl;
		
		graphics._webGL.glPoints = new Float32Array(graphics._webGL.points);
		
		gl.bindBuffer(GL.ARRAY_BUFFER, graphics._webGL.buffer);
		gl.bufferData(GL.ARRAY_BUFFER, graphics._webGL.glPoints, GL.STATIC_DRAW);
		
		graphics._webGL.glIndicies = new Uint16Array(graphics._webGL.indices);
		
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, graphics._webGL.indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, graphics._webGL.glIndicies, GL.STATIC_DRAW);
		
	}
	
	
}