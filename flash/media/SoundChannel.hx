package flash.media;


import flash.events.Event;
import flash.events.EventDispatcher;
import js.html.MediaElement;
import js.Browser;


class SoundChannel extends EventDispatcher {
	
	
	public var ChannelId (default, null):Int;
	public var leftPeak (default, null):Float;
	public var __audio (default, null):MediaElement;
	public var position (default, null):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (default, set_soundTransform):SoundTransform;

	private var __audioCurrentLoop:Int;
	private var __audioTotalLoops:Int;
	private var __removeRef:Void->Void;
	private var __startTime:Float;
	
	
	private function new ():Void {
		
		super (this);
		
		ChannelId = -1;
		leftPeak = 0.;
		position = 0.;
		rightPeak = 0.;
		
		__audioCurrentLoop = 1;
		__audioTotalLoops = 1;
		
	}
	
	
	public function stop ():Void {
		
		if (__audio != null) {
			
			__audio.pause ();
			__audio = null;
			if (__removeRef != null) __removeRef ();
			
		}
		
	}
	
	
	public static function __create (src:String, startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null, removeRef:Void->Void):SoundChannel {
		
		var channel = new SoundChannel ();
		
		channel.__audio = cast Browser.document.createElement ("audio");
		channel.__removeRef = removeRef;
		channel.__audio.addEventListener ("ended", cast channel.__onSoundChannelFinished, false);
		channel.__audio.addEventListener ("seeked", cast channel.__onSoundSeeked, false);
		channel.__audio.addEventListener ("stalled", cast channel.__onStalled, false);
		channel.__audio.addEventListener ("progress", cast channel.__onProgress, false);
		
		if (loops > 0) {
			
			channel.__audioTotalLoops = loops;
			// webkit-specific 
			channel.__audio.loop = true;
			
		}
		
		channel.__startTime = startTime;
		
		if (startTime > 0.) {
			
			var onLoad = null;
			
			onLoad = function (_) { 
				
				channel.__audio.currentTime = channel.__startTime; 
				channel.__audio.play ();
				channel.__audio.removeEventListener ("canplaythrough", cast onLoad, false);
				
			}
			
			channel.__audio.addEventListener ("canplaythrough", cast onLoad, false);
			
		} else {
			
			channel.__audio.autoplay = true;
			
		}
		
		channel.__audio.src = src;
		
		// note: the following line seems to crash completely on most browsers,
		// maybe because the sound isn't loaded ?
		
		//if (startTime > 0.) channel.__audio.currentTime = startTime;
		
		return channel;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function __onProgress (evt:Event):Void {
		
		#if debug
		trace ("sound progress: " + evt);
		#end
		
	}
	
	
	private function __onSoundChannelFinished (evt:Event):Void {
		
		if (__audioCurrentLoop >= __audioTotalLoops) {
			
			__audio.removeEventListener ("ended", cast __onSoundChannelFinished, false);
			__audio.removeEventListener ("seeked", cast __onSoundSeeked, false);
			__audio.removeEventListener ("stalled", cast __onStalled, false);
			__audio.removeEventListener ("progress", cast __onProgress, false);
			__audio = null;
			
			var evt = new Event (Event.COMPLETE);
			evt.target = this;
			dispatchEvent (evt);
			
			if (__removeRef != null) {
				
				__removeRef ();
				
			}
			
		} else {
			
			// firefox-specific
			__audio.currentTime = __startTime;
			__audio.play();
			
		}
		
	}
	
	
	private function __onSoundSeeked (evt:Event):Void {
		
		if (__audioCurrentLoop >= __audioTotalLoops) {
			
			__audio.loop = false;
			stop();
			
		} else {
			
			__audioCurrentLoop++;
			
		}
		
	}
	
	
	private function __onStalled (evt:Event):Void {
		
		#if debug
		trace ("sound stalled");
		#end
		
		if (__audio != null) {
			
			__audio.load ();
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_soundTransform (v:SoundTransform):SoundTransform {
		
		__audio.volume = v.volume;
		return this.soundTransform = v;
		
	}
	
	
}