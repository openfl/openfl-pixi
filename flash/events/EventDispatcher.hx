package flash.events;


import flash.events.EventPhase;
import flash.events.IEventDispatcher;


class EventDispatcher implements IEventDispatcher {
	
	
	private var __target:IEventDispatcher;
	private var __eventMap:EventMap;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__target = target;
			
		} else {
			
			__target = this;
			
		}
		
		__eventMap = [];
		
	}
	
	
	public function addEventListener (type:String, inListener:Dynamic -> Void, useCapture:Bool = false, inPriority:Int = 0, useWeakReference:Bool = false):Void {
		
		var capture:Bool = (useCapture == null ? false : useCapture);
		var priority:Int = (inPriority==null ? 0 : inPriority);
		var list = getList (type);
		
		if (!existList (type)) {
			
			list = [];
			setList (type, list);
			
		}
		
		list.push (new Listener (inListener, capture, priority));
		list.sort (compareListeners);
		
	}
	
	
	private static function compareListeners (l1:Listener, l2:Listener):Int {
		
		return l1.mPriority == l2.mPriority ? 0 : (l1.mPriority > l2.mPriority ? -1 : 1);
		
	}
	
	
	public function dispatchEvent (event:Event):Bool {
		
		if (event.target == null) {
			
			event.target = __target;
			
		}
		
		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);
		
		if (existList (event.type)) {
			
			var list = getList (event.type);
			var idx = 0;
			
			while (idx < list.length) {
				
				var listener = list[idx];
				
				if (listener.mUseCapture == capture) {
					
					listener.dispatchEvent (event);
					
					if (event.__getIsCancelledNow ()) {
						
						return true;
						
					}
					
				}
				
				// Detect if the just used event listener was removed...
				if (idx < list.length && listener != list[idx]) {
					
					// do not advance to next item because it looks like one was just removed
					
				} else {
					
					idx++;
					
				}
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private function existList (type:String):Bool { 
		
		untyped return (__eventMap != null && __eventMap[type] != __js__("undefined"));
		
	}
	
	
	private function getList (type:String):ListenerList {
		
		untyped return __eventMap[type];
		
	}
	
	
	public function hasEventListener (type:String):Bool {
		
		return existList (type);
		
	}
	
	
	public function removeEventListener (type:String, listener:Dynamic->Void, inCapture:Bool = false):Void {
		
		if (!existList (type)) return;
		
		var list = getList (type);
		var capture:Bool = (inCapture == null ? false : inCapture);
		
		for (i in 0...list.length) {
			
			if (list[i].Is (listener, capture)) {
				
				list.splice (i, 1);
				return;
				
			}
			
		}
		
	}
	
	
	private function setList (type:String, list:ListenerList):Void { 
		
		untyped __eventMap[type] = list;
		
	}
	
	
	public function toString ():String { 
		
		return untyped "[ " +  this.__name__ + " ]";
		
	}
	
	
	public function willTrigger (type:String):Bool {
		
		return hasEventListener (type);
		
	}
	
	
}


class Listener {
	
	
	public var mID:Int;
	public var mListner:Dynamic->Void;
	public var mPriority:Int;
	public var mUseCapture:Bool;
	
	private static var sIDs = 1;
	
	
	public function new (inListener:Dynamic->Void, inUseCapture:Bool, inPriority:Int) {
		
		mListner = inListener;
		mUseCapture = inUseCapture;
		mPriority = inPriority;
		mID = sIDs++;
		
	}
	
	
	public function dispatchEvent (event:Event):Void {
		
		mListner(event);
		
	}
	
	
	public function Is (inListener:Dynamic->Void, inCapture:Bool):Bool {
		
		return Reflect.compareMethods (mListner, inListener) && mUseCapture == inCapture;
		
	}
	
	
}


typedef ListenerList = Array<Listener>;
typedef EventMap = Array<ListenerList>;


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
/*class EventDispatcher {
	
	
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
		
		if (listeners.exists (event.type)) {
			
			for (listener in listeners.get (event.type)) {
				
				var callback = listener;
				Reflect.callMethod (callback, callback, event);
				
			}
			
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
	
	
}*/