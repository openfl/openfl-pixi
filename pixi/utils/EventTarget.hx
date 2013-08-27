package pixi.utils;


/**
 * https://github.com/mrdoob/eventtarget.js/
 * THankS mr DOob!
 */

/**
 * Adds event emitter functionality to a class
 *
 * @class EventTarget
 * @example
 *		function MyEmitter() {
 *			PIXI.EventTarget.call(this); //mixes in event target stuff
 *		}
 *
 *		var em = new MyEmitter();
 *		em.emit({ type: 'eventName', data: 'some data' });
 */
class EventTarget {
	
	
	private var listeners:Map<String, Array<Dynamic>>;
	
	
	public function new () {
		
		listeners = new Map<String, Array<Dynamic>> ();
		
	}
	
	
	public function addEventListener ( type, listener:Dynamic ) {
		
		if (!listeners.exists (type)) {
			
			listeners.set (type, []);
			
		}
		
		listeners.get (type).remove (listener);
		listeners.get (type).push (listener);
		
	}
	
	
	public function dispatchEvent ( event:Dynamic ) {
		
		for (listener in listeners.get (event.type)) {
			
			var callback = listener;
			Reflect.callMethod (callback, callback, event);
			
		}
		
	}
	
	
	public function emit (event) {
		
		dispatchEvent (event);
		
	}
	
	
	public function off (type, listener) {
		
		removeEventListener (type, listener);
		
	}
	
	
	public function on (type, listener) {
		
		addEventListener (type, listener);
		
	}
	
	
	public function removeEventListener ( type, listener ) {
		
		listeners.get (type).remove (listener);
		
	}
	
	
}