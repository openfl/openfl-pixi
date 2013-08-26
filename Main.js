(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	Main.stage = new pixi.display.Stage(6750105);
	Main.renderer = new pixi.renderers.canvas.CanvasRenderer(400,300);
	js.Browser.document.body.appendChild(Main.renderer.view);
	var texture = pixi.textures.Texture.fromImage("bunny.png");
	Main.bunny = new pixi.display.Sprite(texture);
	Main.bunny.anchor.x = 0.5;
	Main.bunny.anchor.y = 0.5;
	Main.bunny.position.x = 200;
	Main.bunny.position.y = 150;
	Main.stage.addChild(Main.bunny);
	js.Browser.window.requestAnimationFrame(Main.animate);
}
Main.animate = function() {
	js.Browser.window.requestAnimationFrame(Main.animate);
	Main.bunny.rotation += 0.1;
	Main.renderer.render(Main.stage);
}
var IMap = function() { }
IMap.__name__ = true;
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
var StringTools = function() { }
StringTools.__name__ = true;
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
var haxe = {}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Browser = function() { }
js.Browser.__name__ = true;
var pixi = {}
pixi.InteractionManager = function(stage) {
	this.stage = stage;
	this.mouse = new pixi.InteractionData();
	this.touchs = { };
	this.tempPoint = new pixi.core.Point();
	this.mouseoverEnabled = true;
	this.pool = [];
	this.interactiveItems = [];
	this.last = 0;
};
pixi.InteractionManager.__name__ = true;
pixi.InteractionManager.prototype = {
	onTouchEnd: function(event) {
		var rect = this.target.view.getBoundingClientRect();
		var changedTouches = event.changedTouches;
		var _g1 = 0, _g = changedTouches.length;
		while(_g1 < _g) {
			var i = _g1++;
			var touchEvent = changedTouches[i];
			var touchData = this.touchs[touchEvent.identifier];
			var up = false;
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top) * (this.target.height / rect.height);
			var length = this.interactiveItems.length;
			var _g2 = 0;
			while(_g2 < length) {
				var j = _g2++;
				var item = this.interactiveItems[j];
				var itemTouchData = item.__touchData;
				item.__hit = this.hitTest(item,touchData);
				if(itemTouchData == touchData) {
					touchData.originalEvent = event != null?event:js.Browser.window.event;
					if(item.touchend != null || item.tap != null) {
						if(item.__hit && !up) {
							if(item.touchend != null) item.touchend(touchData);
							if(item.__isDown) {
								if(item.tap != null) item.tap(touchData);
							}
							if(!item.interactiveChildren) up = true;
						} else if(item.__isDown) {
							if(item.touchendoutside != null) item.touchendoutside(touchData);
						}
						item.__isDown = false;
					}
					item.__touchData = null;
				} else {
				}
			}
			this.pool.push(touchData);
			this.touchs[touchEvent.identifier] = null;
		}
	}
	,onTouchStart: function(event) {
		var rect = this.target.view.getBoundingClientRect();
		var changedTouches = event.changedTouches;
		var _g1 = 0, _g = changedTouches.length;
		while(_g1 < _g) {
			var i = _g1++;
			var touchEvent = changedTouches[i];
			var touchData = this.pool.pop();
			if(!touchData) touchData = new pixi.InteractionData();
			touchData.originalEvent = event != null?event:js.Browser.window.event;
			this.touchs[touchEvent.identifier] = touchData;
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top) * (this.target.height / rect.height);
			var length = this.interactiveItems.length;
			var _g2 = 0;
			while(_g2 < length) {
				var j = _g2++;
				var item = this.interactiveItems[j];
				if(item.touchstart != null || item.tap != null) {
					item.__hit = this.hitTest(item,touchData);
					if(item.__hit) {
						if(item.touchstart != null) item.touchstart(touchData);
						item.__isDown = true;
						item.__touchData = touchData;
						if(!item.interactiveChildren) break;
					}
				}
			}
		}
	}
	,onTouchMove: function(event) {
		var rect = this.target.view.getBoundingClientRect();
		var changedTouches = event.changedTouches;
		var touchData = null;
		var _g1 = 0, _g = changedTouches.length;
		while(_g1 < _g) {
			var i = _g1++;
			var touchEvent = changedTouches[i];
			touchData = this.touchs[touchEvent.identifier];
			touchData.originalEvent = event != null?event:js.Browser.window.event;
			touchData.global.x = (touchEvent.clientX - rect.left) * (this.target.width / rect.width);
			touchData.global.y = (touchEvent.clientY - rect.top) * (this.target.height / rect.height);
		}
		var length = this.interactiveItems.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.touchmove != null) item.touchmove(touchData);
		}
	}
	,hitTest: function(item,interactionData) {
		var global = interactionData.global;
		if(item.vcount != pixi.Pixi.visibleCount) return false;
		var isSprite = js.Boot.__instanceof(item,pixi.display.Sprite), worldTransform = item.worldTransform, a00 = worldTransform[0], a01 = worldTransform[1], a02 = worldTransform[2], a10 = worldTransform[3], a11 = worldTransform[4], a12 = worldTransform[5], id = 1 / (a00 * a11 + a01 * -a10), x = a11 * id * global.x + -a01 * id * global.y + (a12 * a01 - a02 * a11) * id, y = a00 * id * global.y + -a10 * id * global.x + (-a12 * a00 + a02 * a10) * id;
		if(isSprite) interactionData.target = item;
		if(item.hitArea != null && item.hitArea.contains != null) {
			if(item.hitArea.contains(x,y)) {
				if(isSprite) interactionData.target = item;
				return true;
			}
			return false;
		} else if(isSprite) {
			var width = (js.Boot.__cast(item , pixi.display.Sprite)).texture.frame.width, height = (js.Boot.__cast(item , pixi.display.Sprite)).texture.frame.height, x1 = -width * (js.Boot.__cast(item , pixi.display.Sprite)).anchor.x, y1;
			if(x > x1 && x < x1 + width) {
				y1 = -height * (js.Boot.__cast(item , pixi.display.Sprite)).anchor.y;
				if(y > y1 && y < y1 + height) {
					interactionData.target = item;
					return true;
				}
			}
		}
		var length = (js.Boot.__cast(item , pixi.display.Sprite)).children.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var tempItem = (js.Boot.__cast(item , pixi.display.Sprite)).children[i];
			var hit = this.hitTest(tempItem,interactionData);
			if(hit) {
				interactionData.target = item;
				return true;
			}
		}
		return false;
	}
	,onMouseUp: function(event) {
		this.mouse.originalEvent = event != null?event:js.Browser.window.event;
		var global = this.mouse.global;
		var length = this.interactiveItems.length;
		var up = false;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.mouseup != null || item.mouseupoutside != null || item.click != null) {
				item.__hit = this.hitTest(item,this.mouse);
				if(item.__hit && !up) {
					if(item.mouseup != null) item.mouseup(this.mouse);
					if(item.__isDown != null) {
						if(item.click != null) item.click(this.mouse);
					}
					if(!item.interactiveChildren) up = true;
				} else if(item.__isDown) {
					if(item.mouseupoutside != null) item.mouseupoutside(this.mouse);
				}
				item.__isDown = false;
			}
		}
	}
	,onMouseOut: function(event) {
		var length = this.interactiveItems.length;
		this.target.view.style.cursor = "default";
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.__isOver) {
				this.mouse.target = item;
				if(item.mouseout != null) item.mouseout(this.mouse);
				item.__isOver = false;
			}
		}
	}
	,onMouseDown: function(event) {
		this.mouse.originalEvent = event != null?event:js.Browser.window.event;
		var length = this.interactiveItems.length;
		var global = this.mouse.global;
		var index = 0;
		var parent = this.stage;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.mousedown != null || item.click != null) {
				item.__mouseIsDown = true;
				item.__hit = this.hitTest(item,this.mouse);
				if(item.__hit != null) {
					if(item.mousedown != null) item.mousedown(this.mouse);
					item.__isDown = true;
					if(!item.interactiveChildren) break;
				}
			}
		}
	}
	,onMouseMove: function(event) {
		this.mouse.originalEvent = event != null?event:js.Browser.window.event;
		var rect = this.target.view.getBoundingClientRect();
		this.mouse.global.x = (event.clientX - rect.left) * (this.target.width / rect.width);
		this.mouse.global.y = (event.clientY - rect.top) * (this.target.height / rect.height);
		var length = this.interactiveItems.length;
		var global = this.mouse.global;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.mousemove != null) item.mousemove(this.mouse);
		}
	}
	,update: function() {
		if(!this.target) return;
		var now = new Date();
		var diff = now.getDate() - this.last;
		diff = diff * 30 / 1000;
		if(diff < 1) return;
		this.last = now.getDate();
		if(this.dirty) {
			this.dirty = false;
			var len = this.interactiveItems.length;
			var _g = 0;
			while(_g < len) {
				var i = _g++;
				this.interactiveItems[i].interactiveChildren = false;
			}
			this.interactiveItems = [];
			if(this.stage.get_interactive()) this.interactiveItems.push(this.stage);
			this.collectInteractiveSprite(this.stage,this.stage);
		}
		var length = this.interactiveItems.length;
		this.target.view.style.cursor = "default";
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var item = this.interactiveItems[i];
			if(item.mouseover != null || item.mouseout != null || item.buttonMode) {
				item.__hit = this.hitTest(item,this.mouse);
				this.mouse.target = item;
				if(item.__hit != null) {
					if(item.buttonMode) this.target.view.style.cursor = "pointer";
					if(!item.__isOver) {
						if(item.mouseover != null) item.mouseover(this.mouse);
						item.__isOver = true;
					}
				} else if(item.__isOver) {
					if(item.mouseout != null) item.mouseout(this.mouse);
					item.__isOver = false;
				}
			}
		}
	}
	,setTarget: function(target) {
		if(window.navigator.msPointerEnabled) {
			target.view.style["-ms-content-zooming"] = "none";
			target.view.style["-ms-touch-action"] = "none";
		}
		this.target = target;
		target.view.addEventListener("mousemove",$bind(this,this.onMouseMove),true);
		target.view.addEventListener("mousedown",$bind(this,this.onMouseDown),true);
		js.Browser.document.body.addEventListener("mouseup",$bind(this,this.onMouseUp),true);
		target.view.addEventListener("mouseout",$bind(this,this.onMouseOut),true);
		target.view.addEventListener("touchstart",$bind(this,this.onTouchStart),true);
		target.view.addEventListener("touchend",$bind(this,this.onTouchEnd),true);
		target.view.addEventListener("touchmove",$bind(this,this.onTouchMove),true);
	}
	,collectInteractiveSprite: function(displayObject,iParent) {
		var children = displayObject.children;
		var length = children.length;
		var i = length - 1;
		while(i >= 0) {
			var child = children[i];
			if(child.get_interactive()) {
				iParent.interactiveChildren = true;
				this.interactiveItems.push(child);
				if(js.Boot.__instanceof(child,pixi.display.DisplayObjectContainer) && (js.Boot.__cast(child , pixi.display.DisplayObjectContainer)).children.length > 0) this.collectInteractiveSprite(child,child);
			} else {
				child.__iParent = null;
				if(js.Boot.__instanceof(child,pixi.display.DisplayObjectContainer) && (js.Boot.__cast(child , pixi.display.DisplayObjectContainer)).children.length > 0) this.collectInteractiveSprite(child,iParent);
			}
			i--;
		}
	}
	,__class__: pixi.InteractionManager
}
pixi.InteractionData = function() {
	this.global = new pixi.core.Point();
	this.local = new pixi.core.Point();
	this.target;
	this.originalEvent;
};
pixi.InteractionData.__name__ = true;
pixi.InteractionData.prototype = {
	getLocalPosition: function(displayObject) {
		var worldTransform = displayObject.worldTransform;
		var global = this.global;
		var a00 = worldTransform[0], a01 = worldTransform[1], a02 = worldTransform[2], a10 = worldTransform[3], a11 = worldTransform[4], a12 = worldTransform[5], id = 1 / (a00 * a11 + a01 * -a10);
		return new pixi.core.Point(a11 * id * global.x + -a01 * id * global.y + (a12 * a01 - a02 * a11) * id,a00 * id * global.y + -a10 * id * global.x + (-a12 * a00 + a02 * a10) * id);
	}
	,__class__: pixi.InteractionData
}
pixi.Pixi = function() { }
pixi.Pixi.__name__ = true;
pixi.BlendModes = { __ename__ : true, __constructs__ : ["NORMAL","SCREEN"] }
pixi.BlendModes.NORMAL = ["NORMAL",0];
pixi.BlendModes.NORMAL.toString = $estr;
pixi.BlendModes.NORMAL.__enum__ = pixi.BlendModes;
pixi.BlendModes.SCREEN = ["SCREEN",1];
pixi.BlendModes.SCREEN.toString = $estr;
pixi.BlendModes.SCREEN.__enum__ = pixi.BlendModes;
pixi.core = {}
pixi.core.Mat3 = function() { }
pixi.core.Mat3.__name__ = true;
pixi.core.Mat3.create = function() {
	var matrix = new Float32Array(9);
	matrix[0] = 1;
	matrix[1] = 0;
	matrix[2] = 0;
	matrix[3] = 0;
	matrix[4] = 1;
	matrix[5] = 0;
	matrix[6] = 0;
	matrix[7] = 0;
	matrix[8] = 1;
	return matrix;
}
pixi.core.Mat3.identity = function(matrix) {
	matrix[0] = 1;
	matrix[1] = 0;
	matrix[2] = 0;
	matrix[3] = 0;
	matrix[4] = 1;
	matrix[5] = 0;
	matrix[6] = 0;
	matrix[7] = 0;
	matrix[8] = 1;
	return matrix;
}
pixi.core.Mat3.multiply = function(mat,mat2,dest) {
	if(dest == null) dest = mat;
	var a00 = mat[0], a01 = mat[1], a02 = mat[2], a10 = mat[3], a11 = mat[4], a12 = mat[5], a20 = mat[6], a21 = mat[7], a22 = mat[8], b00 = mat2[0], b01 = mat2[1], b02 = mat2[2], b10 = mat2[3], b11 = mat2[4], b12 = mat2[5], b20 = mat2[6], b21 = mat2[7], b22 = mat2[8];
	dest[0] = b00 * a00 + b01 * a10 + b02 * a20;
	dest[1] = b00 * a01 + b01 * a11 + b02 * a21;
	dest[2] = b00 * a02 + b01 * a12 + b02 * a22;
	dest[3] = b10 * a00 + b11 * a10 + b12 * a20;
	dest[4] = b10 * a01 + b11 * a11 + b12 * a21;
	dest[5] = b10 * a02 + b11 * a12 + b12 * a22;
	dest[6] = b20 * a00 + b21 * a10 + b22 * a20;
	dest[7] = b20 * a01 + b21 * a11 + b22 * a21;
	dest[8] = b20 * a02 + b21 * a12 + b22 * a22;
	return dest;
}
pixi.core.Mat3.clone = function(mat) {
	var matrix = new Float32Array(9);
	matrix[0] = mat[0];
	matrix[1] = mat[1];
	matrix[2] = mat[2];
	matrix[3] = mat[3];
	matrix[4] = mat[4];
	matrix[5] = mat[5];
	matrix[6] = mat[6];
	matrix[7] = mat[7];
	matrix[8] = mat[8];
	return matrix;
}
pixi.core.Mat3.transpose = function(mat,dest) {
	if(dest == null || mat == dest) {
		var a01 = mat[1], a02 = mat[2], a12 = mat[5];
		mat[1] = mat[3];
		mat[2] = mat[6];
		mat[3] = a01;
		mat[5] = mat[7];
		mat[6] = a02;
		mat[7] = a12;
		return mat;
	}
	dest[0] = mat[0];
	dest[1] = mat[3];
	dest[2] = mat[6];
	dest[3] = mat[1];
	dest[4] = mat[4];
	dest[5] = mat[7];
	dest[6] = mat[2];
	dest[7] = mat[5];
	dest[8] = mat[8];
	return dest;
}
pixi.core.Mat3.toMat4 = function(mat,dest) {
	if(dest == null) dest = pixi.core.Mat4.create();
	dest[15] = 1;
	dest[14] = 0;
	dest[13] = 0;
	dest[12] = 0;
	dest[11] = 0;
	dest[10] = mat[8];
	dest[9] = mat[7];
	dest[8] = mat[6];
	dest[7] = 0;
	dest[6] = mat[5];
	dest[5] = mat[4];
	dest[4] = mat[3];
	dest[3] = 0;
	dest[2] = mat[2];
	dest[1] = mat[1];
	dest[0] = mat[0];
	return dest;
}
pixi.core.Mat4 = function() { }
pixi.core.Mat4.__name__ = true;
pixi.core.Mat4.create = function() {
	var matrix = new Float32Array(16);
	matrix[0] = 1;
	matrix[1] = 0;
	matrix[2] = 0;
	matrix[3] = 0;
	matrix[4] = 0;
	matrix[5] = 1;
	matrix[6] = 0;
	matrix[7] = 0;
	matrix[8] = 0;
	matrix[9] = 0;
	matrix[10] = 1;
	matrix[11] = 0;
	matrix[12] = 0;
	matrix[13] = 0;
	matrix[14] = 0;
	matrix[15] = 1;
	return matrix;
}
pixi.core.Mat4.transpose = function(mat,dest) {
	if(dest == null || mat == dest) {
		var a01 = mat[1], a02 = mat[2], a03 = mat[3], a12 = mat[6], a13 = mat[7], a23 = mat[11];
		mat[1] = mat[4];
		mat[2] = mat[8];
		mat[3] = mat[12];
		mat[4] = a01;
		mat[6] = mat[9];
		mat[7] = mat[13];
		mat[8] = a02;
		mat[9] = a12;
		mat[11] = mat[14];
		mat[12] = a03;
		mat[13] = a13;
		mat[14] = a23;
		return mat;
	}
	dest[0] = mat[0];
	dest[1] = mat[4];
	dest[2] = mat[8];
	dest[3] = mat[12];
	dest[4] = mat[1];
	dest[5] = mat[5];
	dest[6] = mat[9];
	dest[7] = mat[13];
	dest[8] = mat[2];
	dest[9] = mat[6];
	dest[10] = mat[10];
	dest[11] = mat[14];
	dest[12] = mat[3];
	dest[13] = mat[7];
	dest[14] = mat[11];
	dest[15] = mat[15];
	return dest;
}
pixi.core.Mat4.multiply = function(mat,mat2,dest) {
	if(dest == null) dest = mat;
	var a00 = mat[0], a01 = mat[1], a02 = mat[2], a03 = mat[3];
	var a10 = mat[4], a11 = mat[5], a12 = mat[6], a13 = mat[7];
	var a20 = mat[8], a21 = mat[9], a22 = mat[10], a23 = mat[11];
	var a30 = mat[12], a31 = mat[13], a32 = mat[14], a33 = mat[15];
	var b0 = mat2[0], b1 = mat2[1], b2 = mat2[2], b3 = mat2[3];
	dest[0] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[1] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[2] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[3] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[4];
	b1 = mat2[5];
	b2 = mat2[6];
	b3 = mat2[7];
	dest[4] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[5] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[6] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[7] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[8];
	b1 = mat2[9];
	b2 = mat2[10];
	b3 = mat2[11];
	dest[8] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[9] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[10] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[11] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[12];
	b1 = mat2[13];
	b2 = mat2[14];
	b3 = mat2[15];
	dest[12] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[13] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[14] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[15] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	return dest;
}
pixi.core.Point = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
};
pixi.core.Point.__name__ = true;
pixi.core.Point.prototype = {
	clone: function() {
		return new pixi.core.Point(this.x,this.y);
	}
	,__class__: pixi.core.Point
}
pixi.core.Rectangle = function(x,y,width,height) {
	if(height == null) height = 0;
	if(width == null) width = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};
pixi.core.Rectangle.__name__ = true;
pixi.core.Rectangle.prototype = {
	contains: function(x,y) {
		if(this.width <= 0 || this.height <= 0) return false;
		var x1 = this.x;
		if(x >= x1 && x <= x1 + this.width) {
			var y1 = this.y;
			if(y >= y1 && y <= y1 + this.height) return true;
		}
		return false;
	}
	,clone: function() {
		return new pixi.core.Rectangle(this.x,this.y,this.width,this.height);
	}
	,__class__: pixi.core.Rectangle
}
pixi.display = {}
pixi.display.DisplayObject = function() {
	this.last = this;
	this.first = this;
	this.position = new pixi.core.Point();
	this.scale = new pixi.core.Point(1,1);
	this.pivot = new pixi.core.Point(0,0);
	this.rotation = 0;
	this.alpha = 1;
	this.visible = true;
	this.hitArea = null;
	this.buttonMode = false;
	this.renderable = false;
	this.parent = null;
	this.stage = null;
	this.worldAlpha = 1;
	this._interactive = false;
	this.worldTransform = pixi.core.Mat3.create();
	this.localTransform = pixi.core.Mat3.create();
	this.color = [];
	this.isDynamic = true;
	this._sr = 0;
	this._cr = 1;
};
pixi.display.DisplayObject.__name__ = true;
pixi.display.DisplayObject.prototype = {
	updateTransform: function() {
		if(this.rotation != this.rotationCache) {
			this.rotationCache = this.rotation;
			this._sr = Math.sin(this.rotation);
			this._cr = Math.cos(this.rotation);
		}
		var localTransform = this.localTransform;
		var parentTransform = this.parent.worldTransform;
		var worldTransform = this.worldTransform;
		localTransform[0] = this._cr * this.scale.x;
		localTransform[1] = -this._sr * this.scale.y;
		localTransform[3] = this._sr * this.scale.x;
		localTransform[4] = this._cr * this.scale.y;
		var px = this.pivot.x;
		var py = this.pivot.y;
		var a00 = localTransform[0], a01 = localTransform[1], a02 = this.position.x - localTransform[0] * px - py * localTransform[1], a10 = localTransform[3], a11 = localTransform[4], a12 = this.position.y - localTransform[4] * py - px * localTransform[3], b00 = parentTransform[0], b01 = parentTransform[1], b02 = parentTransform[2], b10 = parentTransform[3], b11 = parentTransform[4], b12 = parentTransform[5];
		localTransform[2] = a02;
		localTransform[5] = a12;
		worldTransform[0] = b00 * a00 + b01 * a10;
		worldTransform[1] = b00 * a01 + b01 * a11;
		worldTransform[2] = b00 * a02 + b01 * a12 + b02;
		worldTransform[3] = b10 * a00 + b11 * a10;
		worldTransform[4] = b10 * a01 + b11 * a11;
		worldTransform[5] = b10 * a02 + b11 * a12 + b12;
		this.worldAlpha = this.alpha * this.parent.worldAlpha;
		this.vcount = pixi.Pixi.visibleCount;
	}
	,removeFilter: function() {
		if(!this.filter) return;
		this.filter = false;
		var startBlock = this.first;
		var nextObject = startBlock._iNext;
		var previousObject = startBlock._iPrev;
		if(nextObject != null) nextObject._iPrev = previousObject;
		if(previousObject != null) previousObject._iNext = nextObject;
		this.first = startBlock._iNext;
		var lastBlock = this.last;
		var nextObject1 = lastBlock._iNext;
		var previousObject1 = lastBlock._iPrev;
		if(nextObject1 != null) nextObject1._iPrev = previousObject1;
		previousObject1._iNext = nextObject1;
		var tempLast = lastBlock._iPrev;
		var updateLast = this;
		while(updateLast.last == lastBlock) {
			updateLast.last = tempLast;
			updateLast = updateLast.parent;
			if(updateLast == null) break;
		}
		var mask = startBlock.mask;
		mask.renderable = true;
		if(this.__renderGroup != null) this.__renderGroup.removeFilterBlocks(startBlock,lastBlock);
	}
	,addFilter: function(mask) {
		if(this.filter) return;
		this.filter = true;
		var start = new pixi.filters.FilterBlock();
		var end = new pixi.filters.FilterBlock();
		start.mask = mask;
		end.mask = mask;
		start.first = start.last = this;
		end.first = end.last = this;
		start.open = true;
		var childFirst = start;
		var childLast = start;
		var nextObject;
		var previousObject;
		previousObject = this.first._iPrev;
		if(previousObject != null) {
			nextObject = previousObject._iNext;
			childFirst._iPrev = previousObject;
			previousObject._iNext = childFirst;
		} else nextObject = this;
		if(nextObject != null) {
			nextObject._iPrev = childLast;
			childLast._iNext = nextObject;
		}
		var childFirst1 = end;
		var childLast1 = end;
		var nextObject1 = null;
		var previousObject1 = null;
		previousObject1 = this.last;
		nextObject1 = previousObject1._iNext;
		if(nextObject1 != null) {
			nextObject1._iPrev = childLast1;
			childLast1._iNext = nextObject1;
		}
		childFirst1._iPrev = previousObject1;
		previousObject1._iNext = childFirst1;
		var updateLast = this;
		var prevLast = this.last;
		while(updateLast != null) {
			if(updateLast.last == prevLast) updateLast.last = end;
			updateLast = updateLast.parent;
		}
		this.first = start;
		if(this.__renderGroup != null) this.__renderGroup.addFilterBlocks(start,end);
		mask.renderable = false;
	}
	,set_mask: function(value) {
		this._mask = value;
		if(value != null) this.addFilter(value); else this.removeFilter();
		return value;
	}
	,get_mask: function() {
		return this._mask;
	}
	,set_interactive: function(value) {
		this._interactive = value;
		if(this.stage != null) this.stage.dirty = true;
		return value;
	}
	,get_interactive: function() {
		return this._interactive;
	}
	,setInteractive: function(interactive) {
		this.set_interactive(interactive);
	}
	,__class__: pixi.display.DisplayObject
}
pixi.display.DisplayObjectContainer = function() {
	pixi.display.DisplayObject.call(this);
	this.children = [];
};
pixi.display.DisplayObjectContainer.__name__ = true;
pixi.display.DisplayObjectContainer.__super__ = pixi.display.DisplayObject;
pixi.display.DisplayObjectContainer.prototype = $extend(pixi.display.DisplayObject.prototype,{
	updateTransform: function() {
		if(!this.visible) return;
		pixi.display.DisplayObject.prototype.updateTransform.call(this);
		var i = 0;
		var j = this.children.length;
		while(i < j) {
			this.children[i].updateTransform();
			i++;
		}
	}
	,removeChild: function(child) {
		var index = -1;
		var _g1 = 0, _g = this.children.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.children[i] == child) index = i;
		}
		if(index != -1) {
			var childFirst = child.first;
			var childLast = child.last;
			var nextObject = childLast._iNext;
			var previousObject = childFirst._iPrev;
			if(nextObject != null) nextObject._iPrev = previousObject;
			previousObject._iNext = nextObject;
			if(this.last == childLast) {
				var tempLast = childFirst._iPrev;
				var updateLast = this;
				while(updateLast.last == childLast.last) {
					updateLast.last = tempLast;
					updateLast = updateLast.parent;
					if(updateLast == null) break;
				}
			}
			childLast._iNext = null;
			childFirst._iPrev = null;
			if(this.stage != null) {
				var tmpChild = child;
				do {
					if(tmpChild.get_interactive()) this.stage.dirty = true;
					tmpChild.stage = null;
					tmpChild = tmpChild._iNext;
				} while(tmpChild != null);
			}
			if(child.__renderGroup != null) child.__renderGroup.removeDisplayObjectAndChildren(child);
			child.parent = null;
			this.children.splice(index,1);
		} else throw Std.string(child) + " The supplied DisplayObject must be a child of the caller " + Std.string(this);
	}
	,getChildAt: function(index) {
		if(index >= 0 && index < this.children.length) return this.children[index]; else throw index + " Both the supplied DisplayObjects must be a child of the caller " + Std.string(this);
	}
	,swapChildren: function(child,child2) {
		return;
	}
	,addChildAt: function(child,index) {
		if(index >= 0 && index <= this.children.length) {
			if(child.parent != null) child.parent.removeChild(child);
			child.parent = this;
			if(this.stage != null) {
				var tmpChild = child;
				do {
					if(tmpChild.get_interactive()) this.stage.dirty = true;
					tmpChild.stage = this.stage;
					tmpChild = tmpChild._iNext;
				} while(tmpChild != null);
			}
			var childFirst = child.first;
			var childLast = child.last;
			var nextObject;
			var previousObject;
			if(index == this.children.length) {
				previousObject = this.last;
				var updateLast = this;
				var prevLast = this.last;
				while(updateLast != null) {
					if(updateLast.last == prevLast) updateLast.last = child.last;
					updateLast = updateLast.parent;
				}
			} else if(index == 0) previousObject = this; else previousObject = this.children[index - 1].last;
			nextObject = previousObject._iNext;
			if(nextObject != null) {
				nextObject._iPrev = childLast;
				childLast._iNext = nextObject;
			}
			childFirst._iPrev = previousObject;
			previousObject._iNext = childFirst;
			this.children.splice(index,0,child);
			if(this.__renderGroup != null) {
				if(child.__renderGroup != null) child.__renderGroup.removeDisplayObjectAndChildren(child);
				this.__renderGroup.addDisplayObjectAndChildren(child);
			}
		} else throw Std.string(child) + " The index " + index + " supplied is out of bounds " + this.children.length;
	}
	,addChild: function(child) {
		if(child.parent != null) child.parent.removeChild(child);
		child.parent = this;
		this.children.push(child);
		if(this.stage != null) {
			var tmpChild = child;
			do {
				if(tmpChild.get_interactive()) this.stage.dirty = true;
				tmpChild.stage = this.stage;
				tmpChild = tmpChild._iNext;
			} while(tmpChild != null);
		}
		var childFirst = child.first;
		var childLast = child.last;
		var nextObject;
		var previousObject;
		if(this.filter) previousObject = this.last._iPrev; else previousObject = this.last;
		nextObject = previousObject._iNext;
		var updateLast = this;
		var prevLast = previousObject;
		while(updateLast != null) {
			if(updateLast.last == prevLast) updateLast.last = child.last;
			updateLast = updateLast.parent;
		}
		if(nextObject != null) {
			nextObject._iPrev = childLast;
			childLast._iNext = nextObject;
		}
		childFirst._iPrev = previousObject;
		previousObject._iNext = childFirst;
		if(this.__renderGroup != null) {
			if(child.__renderGroup != null) child.__renderGroup.removeDisplayObjectAndChildren(child);
			this.__renderGroup.addDisplayObjectAndChildren(child);
		}
	}
	,__class__: pixi.display.DisplayObjectContainer
});
pixi.display.Sprite = function(texture) {
	pixi.display.DisplayObjectContainer.call(this);
	this.anchor = new pixi.core.Point();
	this.texture = texture;
	this.blendMode = pixi.BlendModes.NORMAL;
	this._width = 0;
	this._height = 0;
	if(texture.baseTexture.hasLoaded) this.updateFrame = true; else this.texture.addEventListener("update",$bind(this,this.onTextureUpdate));
	this.renderable = true;
};
pixi.display.Sprite.__name__ = true;
pixi.display.Sprite.fromFrame = function(frameId) {
	var texture = pixi.Pixi.TextureCache.get(frameId);
	if(texture == null) throw "The frameId '" + frameId + "' does not exist in the texture cache";
	return new pixi.display.Sprite(texture);
}
pixi.display.Sprite.fromImage = function(imageId) {
	var texture = pixi.textures.Texture.fromImage(imageId);
	return new pixi.display.Sprite(texture);
}
pixi.display.Sprite.__super__ = pixi.display.DisplayObjectContainer;
pixi.display.Sprite.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	onTextureUpdate: function(event) {
		if(this._width > 0) this.scale.x = this._width / this.texture.frame.width;
		if(this._height > 0) this.scale.y = this._height / this.texture.frame.height;
		this.updateFrame = true;
	}
	,setTexture: function(texture) {
		if(this.texture.baseTexture != texture.baseTexture) {
			this.textureChange = true;
			this.texture = texture;
			if(this.__renderGroup != null) this.__renderGroup.updateTexture(this);
		} else this.texture = texture;
		this.updateFrame = true;
	}
	,set_height: function(value) {
		this.scale.y = value / this.texture.frame.height;
		this._height = value;
		return value;
	}
	,get_height: function() {
		return this.scale.y * this.texture.frame.height;
	}
	,set_width: function(value) {
		this.scale.x = value / this.texture.frame.width;
		this._width = value;
		return value;
	}
	,get_width: function() {
		return this.scale.x * this.texture.frame.width;
	}
	,__class__: pixi.display.Sprite
});
pixi.display.Stage = function(backgroundColor,interactive) {
	if(interactive == null) interactive = false;
	pixi.display.DisplayObjectContainer.call(this);
	this.worldTransform = pixi.core.Mat3.create();
	this.set_interactive(interactive);
	this.interactionManager = new pixi.InteractionManager(this);
	this.dirty = true;
	this.__childrenAdded = [];
	this.__childrenRemoved = [];
	this.stage = this;
	this.stage.hitArea = new pixi.core.Rectangle(0,0,100000,100000);
	this.setBackgroundColor(backgroundColor);
	this.worldVisible = true;
};
pixi.display.Stage.__name__ = true;
pixi.display.Stage.__super__ = pixi.display.DisplayObjectContainer;
pixi.display.Stage.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	getMousePosition: function() {
		return this.interactionManager.mouse.global;
	}
	,setBackgroundColor: function(backgroundColor) {
		if(backgroundColor == null) backgroundColor = 0;
		this.backgroundColor = backgroundColor;
		this.backgroundColorSplit = pixi.utils.Utils.HEXtoRGB(this.backgroundColor);
		var hex = StringTools.hex(this.backgroundColor,6);
		hex = HxOverrides.substr("000000",0,6 - hex.length) + hex;
		this.backgroundColorString = "#" + hex;
	}
	,updateTransform: function() {
		this.worldAlpha = 1;
		var i = 0;
		var j = this.children.length;
		while(i < j) {
			this.children[i].updateTransform();
			i++;
		}
		if(this.dirty) {
			this.dirty = false;
			this.interactionManager.dirty = true;
		}
		if(this.get_interactive()) this.interactionManager.update();
	}
	,__class__: pixi.display.Stage
});
pixi.extras = {}
pixi.extras.CustomRenderable = function() {
	pixi.display.DisplayObject.call(this);
};
pixi.extras.CustomRenderable.__name__ = true;
pixi.extras.CustomRenderable.__super__ = pixi.display.DisplayObject;
pixi.extras.CustomRenderable.prototype = $extend(pixi.display.DisplayObject.prototype,{
	renderWebGL: function(renderGroup,projectionMatrix) {
	}
	,initWebGL: function(renderer) {
	}
	,renderCanvas: function(renderer) {
	}
	,__class__: pixi.extras.CustomRenderable
});
pixi.extras.Strip = function(texture,width,height) {
	pixi.display.DisplayObjectContainer.call(this);
	this.texture = texture;
	this.blendMode = pixi.BlendModes.NORMAL;
	try {
		this.uvs = new Float32Array([0,1,1,1,1,0,0,1]);
		this.verticies = new Float32Array([0,0,0,0,0,0,0,0,0]);
		this.colors = new Float32Array([1,1,1,1]);
		this.indices = new Uint16Array([0,1,2,3]);
	} catch( error ) {
	}
	this.width = width;
	this.height = height;
	if(texture.baseTexture.hasLoaded) {
		this.width = this.texture.frame.width;
		this.height = this.texture.frame.height;
		this.updateFrame = true;
	} else this.texture.addEventListener("update",$bind(this,this.onTextureUpdate));
	this.renderable = true;
};
pixi.extras.Strip.__name__ = true;
pixi.extras.Strip.__super__ = pixi.display.DisplayObjectContainer;
pixi.extras.Strip.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	onTextureUpdate: function(event) {
		this.updateFrame = true;
	}
	,setTexture: function(texture) {
		this.texture = texture;
		this.width = texture.frame.width;
		this.height = texture.frame.height;
		this.updateFrame = true;
	}
	,__class__: pixi.extras.Strip
});
pixi.extras.TilingSprite = function(texture,width,height) {
	pixi.display.DisplayObjectContainer.call(this);
	this.texture = texture;
	this.width = width;
	this.height = height;
	this.tileScale = new pixi.core.Point(1,1);
	this.tilePosition = new pixi.core.Point(0,0);
	this.renderable = true;
	this.blendMode = pixi.BlendModes.NORMAL;
};
pixi.extras.TilingSprite.__name__ = true;
pixi.extras.TilingSprite.__super__ = pixi.display.DisplayObjectContainer;
pixi.extras.TilingSprite.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	onTextureUpdate: function(event) {
		this.updateFrame = true;
	}
	,setTexture: function(texture) {
		this.texture = texture;
		this.updateFrame = true;
	}
	,__class__: pixi.extras.TilingSprite
});
pixi.filters = {}
pixi.filters.FilterBlock = function(mask) {
	this.graphics = mask;
	this.visible = true;
	this.renderable = true;
};
pixi.filters.FilterBlock.__name__ = true;
pixi.filters.FilterBlock.prototype = {
	__class__: pixi.filters.FilterBlock
}
pixi.primitives = {}
pixi.primitives.Graphics = function() {
	pixi.display.DisplayObjectContainer.call(this);
	this.renderable = true;
	this.fillAlpha = 1;
	this.lineWidth = 0;
	this.lineColor = 0;
	this.graphicsData = [];
	this.currentPath = { points : []};
};
pixi.primitives.Graphics.__name__ = true;
pixi.primitives.Graphics.__super__ = pixi.display.DisplayObjectContainer;
pixi.primitives.Graphics.prototype = $extend(pixi.display.DisplayObjectContainer.prototype,{
	clear: function() {
		this.lineWidth = 0;
		this.filling = false;
		this.dirty = true;
		this.clearDirty = true;
		this.graphicsData = [];
	}
	,drawElipse: function(x,y,width,height) {
		if(this.currentPath.points.length == 0) this.graphicsData.pop();
		this.currentPath = { lineWidth : this.lineWidth, lineColor : this.lineColor, lineAlpha : this.lineAlpha, fillColor : this.fillColor, fillAlpha : this.fillAlpha, fill : this.filling, points : [x,y,width,height], type : pixi.primitives.Graphics.ELIP};
		this.graphicsData.push(this.currentPath);
		this.dirty = true;
	}
	,drawCircle: function(x,y,radius) {
		if(this.currentPath.points.length == 0) this.graphicsData.pop();
		this.currentPath = { lineWidth : this.lineWidth, lineColor : this.lineColor, lineAlpha : this.lineAlpha, fillColor : this.fillColor, fillAlpha : this.fillAlpha, fill : this.filling, points : [x,y,radius,radius], type : pixi.primitives.Graphics.CIRC};
		this.graphicsData.push(this.currentPath);
		this.dirty = true;
	}
	,drawRect: function(x,y,width,height) {
		if(this.currentPath.points.length == 0) this.graphicsData.pop();
		this.currentPath = { lineWidth : this.lineWidth, lineColor : this.lineColor, lineAlpha : this.lineAlpha, fillColor : this.fillColor, fillAlpha : this.fillAlpha, fill : this.filling, points : [x,y,width,height], type : pixi.primitives.Graphics.RECT};
		this.graphicsData.push(this.currentPath);
		this.dirty = true;
	}
	,endFill: function() {
		this.filling = false;
		this.fillColor = null;
		this.fillAlpha = 1;
	}
	,beginFill: function(color,alpha) {
		if(alpha == null) alpha = 1;
		if(color == null) color = 0;
		this.filling = true;
		this.fillColor = color;
		this.fillAlpha = alpha;
	}
	,lineTo: function(x,y) {
		this.currentPath.points.push(x,y);
		this.dirty = true;
	}
	,moveTo: function(x,y) {
		if(this.currentPath.points.length == 0) this.graphicsData.pop();
		this.currentPath = this.currentPath = { lineWidth : this.lineWidth, lineColor : this.lineColor, lineAlpha : this.lineAlpha, fillColor : this.fillColor, fillAlpha : this.fillAlpha, fill : this.filling, points : [], type : pixi.primitives.Graphics.POLY};
		this.currentPath.points.push(x,y);
		this.graphicsData.push(this.currentPath);
	}
	,lineStyle: function(lineWidth,color,alpha) {
		if(alpha == null) alpha = 1;
		if(color == null) color = 0;
		if(lineWidth == null) lineWidth = 0;
		if(this.currentPath.points.length == 0) this.graphicsData.pop();
		this.lineWidth = lineWidth;
		this.lineColor = color;
		this.lineAlpha = alpha;
		this.currentPath = { lineWidth : this.lineWidth, lineColor : this.lineColor, lineAlpha : this.lineAlpha, fillColor : this.fillColor, fillAlpha : this.fillAlpha, fill : this.filling, points : [], type : pixi.primitives.Graphics.POLY};
		this.graphicsData.push(this.currentPath);
	}
	,__class__: pixi.primitives.Graphics
});
pixi.renderers = {}
pixi.renderers.canvas = {}
pixi.renderers.canvas.CanvasGraphics = function() {
};
pixi.renderers.canvas.CanvasGraphics.__name__ = true;
pixi.renderers.canvas.CanvasGraphics.renderGraphics = function(graphics,context) {
	var worldAlpha = graphics.worldAlpha;
	var _g1 = 0, _g = graphics.graphicsData.length;
	while(_g1 < _g) {
		var i = _g1++;
		var data = graphics.graphicsData[i];
		var points = data.points;
		var color = "";
		context.strokeStyle = color = "#" + StringTools.hex(data.lineColor,6);
		context.lineWidth = data.lineWidth;
		if(data.type == pixi.primitives.Graphics.POLY) {
			context.beginPath();
			context.moveTo(points[0],points[1]);
			var _g3 = 1, _g2 = Math.round(points.length / 2);
			while(_g3 < _g2) {
				var j = _g3++;
				context.lineTo(points[j * 2],points[j * 2 + 1]);
			}
			if(points[0] == points[points.length - 2] && points[1] == points[points.length - 1]) context.closePath();
			if(data.fill) {
				context.globalAlpha = data.fillAlpha * worldAlpha;
				context.fillStyle = color = "#" + StringTools.hex(data.fillColor,6);
				context.fill();
			}
			if(data.lineWidth > 0) {
				context.globalAlpha = data.lineAlpha * worldAlpha;
				context.stroke();
			}
		} else if(data.type == pixi.primitives.Graphics.RECT) {
			context.globalAlpha = data.fillAlpha * worldAlpha;
			context.fillStyle = color = "#" + StringTools.hex(data.fillColor,6);
			context.fillRect(points[0],points[1],points[2],points[3]);
			if(data.lineWidth > 0) {
				context.globalAlpha = data.lineAlpha * worldAlpha;
				context.strokeRect(points[0],points[1],points[2],points[3]);
			}
		} else if(data.type == pixi.primitives.Graphics.CIRC) {
			context.beginPath();
			context.arc(points[0],points[1],points[2],0,2 * Math.PI,false);
			context.closePath();
			if(data.fill) {
				context.globalAlpha = data.fillAlpha * worldAlpha;
				context.fillStyle = color = "#" + StringTools.hex(data.fillColor,6);
				context.fill();
			}
			if(data.lineWidth > 0) {
				context.globalAlpha = data.lineAlpha * worldAlpha;
				context.stroke();
			}
		} else if(data.type == pixi.primitives.Graphics.ELIP) {
			var elipseData = data.points;
			var w = elipseData[2] * 2;
			var h = elipseData[3] * 2;
			var x = elipseData[0] - w / 2;
			var y = elipseData[1] - h / 2;
			context.beginPath();
			var kappa = .5522848, ox = w / 2 * kappa, oy = h / 2 * kappa, xe = x + w, ye = y + h, xm = x + w / 2, ym = y + h / 2;
			context.moveTo(x,ym);
			context.bezierCurveTo(x,ym - oy,xm - ox,y,xm,y);
			context.bezierCurveTo(xm + ox,y,xe,ym - oy,xe,ym);
			context.bezierCurveTo(xe,ym + oy,xm + ox,ye,xm,ye);
			context.bezierCurveTo(xm - ox,ye,x,ym + oy,x,ym);
			context.closePath();
			if(data.fill) {
				context.globalAlpha = data.fillAlpha * worldAlpha;
				context.fillStyle = color = "#" + StringTools.hex(data.fillColor,6);
				context.fill();
			}
			if(data.lineWidth > 0) {
				context.globalAlpha = data.lineAlpha * worldAlpha;
				context.stroke();
			}
		}
	}
}
pixi.renderers.canvas.CanvasGraphics.renderGraphicsMask = function(graphics,context) {
	var worldAlpha = graphics.worldAlpha;
	var len = graphics.graphicsData.length;
	if(len > 1) {
		len = 1;
		console.log("Pixi.js warning: masks in canvas can only mask using the first path in the graphics object");
	}
	var _g = 0;
	while(_g < 1) {
		var i = _g++;
		var data = graphics.graphicsData[i];
		var points = data.points;
		if(data.type == pixi.primitives.Graphics.POLY) {
			context.beginPath();
			context.moveTo(points[0],points[1]);
			var _g2 = 1, _g1 = Math.round(points.length / 2);
			while(_g2 < _g1) {
				var j = _g2++;
				context.lineTo(points[j * 2],points[j * 2 + 1]);
			}
			if(points[0] == points[points.length - 2] && points[1] == points[points.length - 1]) context.closePath();
		} else if(data.type == pixi.primitives.Graphics.RECT) {
			context.beginPath();
			context.rect(points[0],points[1],points[2],points[3]);
			context.closePath();
		} else if(data.type == pixi.primitives.Graphics.CIRC) {
			context.beginPath();
			context.arc(points[0],points[1],points[2],0,2 * Math.PI,false);
			context.closePath();
		} else if(data.type == pixi.primitives.Graphics.ELIP) {
			var elipseData = data.points;
			var w = elipseData[2] * 2;
			var h = elipseData[3] * 2;
			var x = elipseData[0] - w / 2;
			var y = elipseData[1] - h / 2;
			context.beginPath();
			var kappa = .5522848, ox = w / 2 * kappa, oy = h / 2 * kappa, xe = x + w, ye = y + h, xm = x + w / 2, ym = y + h / 2;
			context.moveTo(x,ym);
			context.bezierCurveTo(x,ym - oy,xm - ox,y,xm,y);
			context.bezierCurveTo(xm + ox,y,xe,ym - oy,xe,ym);
			context.bezierCurveTo(xe,ym + oy,xm + ox,ye,xm,ye);
			context.bezierCurveTo(xm - ox,ye,x,ym + oy,x,ym);
			context.closePath();
		}
	}
}
pixi.renderers.canvas.CanvasGraphics.prototype = {
	__class__: pixi.renderers.canvas.CanvasGraphics
}
pixi.renderers.canvas.CanvasRenderer = function(width,height,view,transparent) {
	if(transparent == null) transparent = false;
	if(height == null) height = 600;
	if(width == null) width = 800;
	this.transparent = transparent;
	this.width = width;
	this.height = height;
	if(view == null) view = js.Browser.document.createElement("canvas");
	this.view = view;
	this.context = this.view.getContext("2d");
	this.refresh = true;
	this.view.width = this.width;
	this.view.height = this.height;
	this.count = 0;
};
pixi.renderers.canvas.CanvasRenderer.__name__ = true;
pixi.renderers.canvas.CanvasRenderer.prototype = {
	renderStrip: function(strip) {
		var context = this.context;
		var verticies = strip.verticies;
		var uvs = strip.uvs;
		var length = verticies.length / 2;
		this.count++;
		var i = 1;
		while(i < length - 2) {
			var index = i * 2;
			var x0 = verticies[index], x1 = verticies[index + 2], x2 = verticies[index + 4];
			var y0 = verticies[index + 1], y1 = verticies[index + 3], y2 = verticies[index + 5];
			var u0 = uvs[index] * strip.texture.width, u1 = uvs[index + 2] * strip.texture.width, u2 = uvs[index + 4] * strip.texture.width;
			var v0 = uvs[index + 1] * strip.texture.height, v1 = uvs[index + 3] * strip.texture.height, v2 = uvs[index + 5] * strip.texture.height;
			context.save();
			context.beginPath();
			context.moveTo(x0,y0);
			context.lineTo(x1,y1);
			context.lineTo(x2,y2);
			context.closePath();
			context.clip();
			var delta = u0 * v1 + v0 * u2 + u1 * v2 - v1 * u2 - v0 * u1 - u0 * v2;
			var delta_a = x0 * v1 + v0 * x2 + x1 * v2 - v1 * x2 - v0 * x1 - x0 * v2;
			var delta_b = u0 * x1 + x0 * u2 + u1 * x2 - x1 * u2 - x0 * u1 - u0 * x2;
			var delta_c = u0 * v1 * x2 + v0 * x1 * u2 + x0 * u1 * v2 - x0 * v1 * u2 - v0 * u1 * x2 - u0 * x1 * v2;
			var delta_d = y0 * v1 + v0 * y2 + y1 * v2 - v1 * y2 - v0 * y1 - y0 * v2;
			var delta_e = u0 * y1 + y0 * u2 + u1 * y2 - y1 * u2 - y0 * u1 - u0 * y2;
			var delta_f = u0 * v1 * y2 + v0 * y1 * u2 + y0 * u1 * v2 - y0 * v1 * u2 - v0 * u1 * y2 - u0 * y1 * v2;
			context.transform(delta_a / delta,delta_d / delta,delta_b / delta,delta_e / delta,delta_c / delta,delta_f / delta);
			context.drawImage(strip.texture.baseTexture.source,0,0);
			context.restore();
			i++;
		}
	}
	,renderTilingSprite: function(sprite) {
		var context = this.context;
		context.globalAlpha = sprite.worldAlpha;
		if(sprite.__tilePattern == null) sprite.__tilePattern = context.createPattern(sprite.texture.baseTexture.source,"repeat");
		context.beginPath();
		var tilePosition = sprite.tilePosition;
		var tileScale = sprite.tileScale;
		context.scale(tileScale.x,tileScale.y);
		context.translate(tilePosition.x,tilePosition.y);
		context.fillStyle = sprite.__tilePattern;
		context.fillRect(-tilePosition.x,-tilePosition.y,sprite.width / tileScale.x,sprite.height / tileScale.y);
		context.scale(1 / tileScale.x,1 / tileScale.y);
		context.translate(-tilePosition.x,-tilePosition.y);
		context.closePath();
	}
	,renderStripFlat: function(strip) {
		var context = this.context;
		var verticies = strip.verticies;
		var uvs = strip.uvs;
		var length = verticies.length / 2;
		this.count++;
		context.beginPath();
		var i = 1;
		while(i < length - 2) {
			var index = i * 2;
			var x0 = verticies[index], x1 = verticies[index + 2], x2 = verticies[index + 4];
			var y0 = verticies[index + 1], y1 = verticies[index + 3], y2 = verticies[index + 5];
			context.moveTo(x0,y0);
			context.lineTo(x1,y1);
			context.lineTo(x2,y2);
			i++;
		}
		context.fillStyle = "#FF0000";
		context.fill();
		context.closePath();
	}
	,renderDisplayObject: function(displayObject) {
		var transform;
		var context = this.context;
		context.globalCompositeOperation = "source-over";
		var testObject = displayObject.last._iNext;
		displayObject = displayObject.first;
		do {
			transform = displayObject.worldTransform;
			if(!displayObject.visible) {
				displayObject = displayObject.last._iNext;
				continue;
			}
			if(!displayObject.renderable) {
				displayObject = displayObject._iNext;
				continue;
			}
			if(js.Boot.__instanceof(displayObject,pixi.display.Sprite)) {
				var frame = (js.Boot.__cast(displayObject , pixi.display.Sprite)).texture.frame;
				if(frame != null) {
					context.globalAlpha = (js.Boot.__cast(displayObject , pixi.display.Sprite)).worldAlpha;
					context.setTransform(transform[0],transform[3],transform[1],transform[4],transform[2],transform[5]);
					context.drawImage((js.Boot.__cast(displayObject , pixi.display.Sprite)).texture.baseTexture.source,frame.x,frame.y,frame.width,frame.height,(js.Boot.__cast(displayObject , pixi.display.Sprite)).anchor.x * -frame.width,(js.Boot.__cast(displayObject , pixi.display.Sprite)).anchor.y * -frame.height,frame.width,frame.height);
				}
			} else if(js.Boot.__instanceof(displayObject,pixi.extras.Strip)) {
				context.setTransform(transform[0],transform[3],transform[1],transform[4],transform[2],transform[5]);
				this.renderStrip(displayObject);
			} else if(js.Boot.__instanceof(displayObject,pixi.extras.TilingSprite)) {
				context.setTransform(transform[0],transform[3],transform[1],transform[4],transform[2],transform[5]);
				this.renderTilingSprite(displayObject);
			} else if(js.Boot.__instanceof(displayObject,pixi.extras.CustomRenderable)) (js.Boot.__cast(displayObject , pixi.extras.CustomRenderable)).renderCanvas(this); else if(js.Boot.__instanceof(displayObject,pixi.primitives.Graphics)) {
				context.setTransform(transform[0],transform[3],transform[1],transform[4],transform[2],transform[5]);
				pixi.renderers.canvas.CanvasGraphics.renderGraphics(displayObject,context);
			} else if(js.Boot.__instanceof(displayObject,pixi.filters.FilterBlock)) {
				if((js.Boot.__cast(displayObject , pixi.filters.FilterBlock)).open) {
					context.save();
					var cacheAlpha = displayObject.get_mask().alpha;
					var maskTransform = displayObject.get_mask().worldTransform;
					context.setTransform(maskTransform[0],maskTransform[3],maskTransform[1],maskTransform[4],maskTransform[2],maskTransform[5]);
					displayObject.get_mask().worldAlpha = 0.5;
					context.worldAlpha = 0;
					pixi.renderers.canvas.CanvasGraphics.renderGraphicsMask(displayObject.get_mask(),context);
					context.clip();
					displayObject.get_mask().worldAlpha = cacheAlpha;
				} else context.restore();
			}
			displayObject = displayObject._iNext;
		} while(displayObject != testObject);
	}
	,resize: function(width,height) {
		this.width = width;
		this.height = height;
		this.view.width = width;
		this.view.height = height;
	}
	,render: function(stage) {
		pixi.Pixi.texturesToUpdate = [];
		pixi.Pixi.texturesToDestroy = [];
		pixi.Pixi.visibleCount++;
		stage.updateTransform();
		if(this.view.style.backgroundColor != stage.backgroundColorString && !this.transparent) this.view.style.backgroundColor = stage.backgroundColorString;
		this.context.setTransform(1,0,0,1,0,0);
		this.context.clearRect(0,0,this.width,this.height);
		this.renderDisplayObject(stage);
		if(stage.get_interactive()) {
			if(!stage._interactiveEventsAdded) {
				stage._interactiveEventsAdded = true;
				stage.interactionManager.setTarget(this);
			}
		}
		if(pixi.textures.Texture.frameUpdates.length > 0) pixi.textures.Texture.frameUpdates = [];
	}
	,__class__: pixi.renderers.canvas.CanvasRenderer
}
pixi.utils = {}
pixi.utils.EventTarget = function() {
	this.listeners = new haxe.ds.StringMap();
};
pixi.utils.EventTarget.__name__ = true;
pixi.utils.EventTarget.prototype = {
	off: function(type,listener) {
		this.removeEventListener(type,listener);
	}
	,removeEventListener: function(type,listener) {
		HxOverrides.remove(this.listeners.get(type),listener);
	}
	,emit: function(event) {
		this.dispatchEvent(event);
	}
	,dispatchEvent: function(event) {
		var _g = 0, _g1 = (function($this) {
			var $r;
			var key = event.type;
			$r = $this.listeners.get(key);
			return $r;
		}(this));
		while(_g < _g1.length) {
			var listener = _g1[_g];
			++_g;
			var callback = listener;
			Reflect.callMethod(callback,callback,event);
		}
	}
	,on: function(type,listener) {
		this.addEventListener(type,listener);
	}
	,addEventListener: function(type,listener) {
		if(!this.listeners.exists(type)) this.listeners.set(type,[]);
		var x = listener;
		HxOverrides.remove(this.listeners.get(type),x);
		this.listeners.get(type).push(listener);
	}
	,__class__: pixi.utils.EventTarget
}
pixi.textures = {}
pixi.textures.BaseTexture = function(source) {
	pixi.utils.EventTarget.call(this);
	this.width = 100;
	this.height = 100;
	this.hasLoaded = false;
	this.source = source;
	if(source == null) return;
	if(this.source instanceof Image || this.source instanceof HTMLImageElement) {
		if(this.source.complete) {
			this.hasLoaded = true;
			this.width = this.source.width;
			this.height = this.source.height;
			pixi.Pixi.texturesToUpdate.push(this);
		} else {
			var scope = this;
			this.source.onload = function() {
				scope.hasLoaded = true;
				scope.width = scope.source.width;
				scope.height = scope.source.height;
				pixi.Pixi.texturesToUpdate.push(scope);
				scope.dispatchEvent({ type : "loaded", content : scope});
			};
		}
	} else {
		this.hasLoaded = true;
		this.width = this.source.width;
		this.height = this.source.height;
		pixi.Pixi.texturesToUpdate.push(this);
	}
	this._powerOf2 = false;
};
pixi.textures.BaseTexture.__name__ = true;
pixi.textures.BaseTexture.fromImage = function(imageUrl,crossorigin) {
	var baseTexture = pixi.Pixi.BaseTextureCache.get(imageUrl);
	if(baseTexture == null) {
		var image = new Image();
		if(crossorigin) image.crossOrigin = "";
		image.src = imageUrl;
		baseTexture = new pixi.textures.BaseTexture(image);
		pixi.Pixi.BaseTextureCache.set(imageUrl,baseTexture);
	}
	return baseTexture;
}
pixi.textures.BaseTexture.__super__ = pixi.utils.EventTarget;
pixi.textures.BaseTexture.prototype = $extend(pixi.utils.EventTarget.prototype,{
	destroy: function() {
		if(this.source instanceof Image) this.source.src = null;
		this.source = null;
		pixi.Pixi.texturesToDestroy.push(this);
	}
	,__class__: pixi.textures.BaseTexture
});
pixi.textures.Texture = function(baseTexture,frame) {
	pixi.utils.EventTarget.call(this);
	if(frame == null) {
		this.noFrame = true;
		frame = new pixi.core.Rectangle(0,0,1,1);
	}
	if(js.Boot.__instanceof(baseTexture,pixi.textures.Texture)) baseTexture = (js.Boot.__cast(baseTexture , pixi.textures.Texture)).baseTexture;
	this.baseTexture = baseTexture;
	this.frame = frame;
	this.trim = new pixi.core.Point();
	this.scope = this;
	if(baseTexture.hasLoaded) {
		if(this.noFrame) frame = new pixi.core.Rectangle(0,0,baseTexture.width,baseTexture.height);
		this.setFrame(frame);
	} else baseTexture.addEventListener("loaded",$bind(this,this.onBaseTextureLoaded));
};
pixi.textures.Texture.__name__ = true;
pixi.textures.Texture.fromImage = function(imageUrl,crossorigin) {
	if(crossorigin == null) crossorigin = false;
	var texture = pixi.Pixi.TextureCache.get(imageUrl);
	if(texture == null) {
		texture = new pixi.textures.Texture(pixi.textures.BaseTexture.fromImage(imageUrl,crossorigin));
		pixi.Pixi.TextureCache.set(imageUrl,texture);
		texture;
	}
	return texture;
}
pixi.textures.Texture.fromFrame = function(frameId) {
	var texture = pixi.Pixi.TextureCache.get(frameId);
	if(texture == null) throw "The frameId '" + frameId + "' does not exist in the texture cache";
	return texture;
}
pixi.textures.Texture.fromCanvas = function(canvas) {
	var baseTexture = new pixi.textures.BaseTexture(canvas);
	return new pixi.textures.Texture(baseTexture);
}
pixi.textures.Texture.addTextureToCache = function(texture,id) {
	pixi.Pixi.TextureCache.set(id,texture);
}
pixi.textures.Texture.removeTextureFromCache = function(id) {
	var texture = pixi.Pixi.TextureCache.get(id);
	pixi.Pixi.TextureCache.set(id,null);
	return texture;
}
pixi.textures.Texture.__super__ = pixi.utils.EventTarget;
pixi.textures.Texture.prototype = $extend(pixi.utils.EventTarget.prototype,{
	setFrame: function(frame) {
		this.frame = frame;
		this.width = frame.width;
		this.height = frame.height;
		if(frame.x + frame.width > this.baseTexture.width || frame.y + frame.height > this.baseTexture.height) throw "Texture Error: frame does not fit inside the base Texture dimensions " + Std.string(this);
		this.updateFrame = true;
		pixi.textures.Texture.frameUpdates.push(this);
	}
	,destroy: function(destroyBase) {
		if(destroyBase) this.baseTexture.destroy();
	}
	,onBaseTextureLoaded: function(event) {
		var baseTexture = this.baseTexture;
		baseTexture.removeEventListener("loaded",this.onLoaded);
		if(this.noFrame) this.frame = new pixi.core.Rectangle(0,0,baseTexture.width,baseTexture.height);
		this.noFrame = false;
		this.width = this.frame.width;
		this.height = this.frame.height;
		this.scope.dispatchEvent({ type : "update", content : this});
	}
	,__class__: pixi.textures.Texture
});
pixi.utils.Utils = function() { }
pixi.utils.Utils.__name__ = true;
pixi.utils.Utils.HEXtoRGB = function(hex) {
	return [(hex >> 16 & 255) / 255,(hex >> 8 & 255) / 255,(hex & 255) / 255];
}
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
pixi.Pixi.visibleCount = 0;
pixi.Pixi.BaseTextureCache = new haxe.ds.StringMap();
pixi.Pixi.texturesToUpdate = [];
pixi.Pixi.texturesToDestroy = [];
pixi.Pixi.TextureCache = new haxe.ds.StringMap();
pixi.Pixi.FrameCache = { };
pixi.primitives.Graphics.POLY = 0;
pixi.primitives.Graphics.RECT = 1;
pixi.primitives.Graphics.CIRC = 2;
pixi.primitives.Graphics.ELIP = 3;
pixi.textures.Texture.frameUpdates = [];
Main.main();
})();
