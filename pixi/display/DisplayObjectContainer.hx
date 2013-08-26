package pixi.display;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 */


/**
 * A DisplayObjectContainer represents a collection of display objects.
 * It is the base class of all display objects that act as a container for other objects.
 *
 * @class DisplayObjectContainer 
 * @extends DisplayObject
 * @constructor
 */
class DisplayObjectContainer extends DisplayObject {
	
	
	public var children:Array<DisplayObject>;
	public var interactiveChildren:Bool;
	
	
public function new ()
{
	//PIXI.DisplayObject.call( this );
	super ();
	
	/**
	 * [read-only] The of children of this container.
	 *
	 * @property children
	 * @type Array<DisplayObject>
	 * @readOnly
	 */	
	this.children = [];
}

// constructor
//PIXI.DisplayObjectContainer.prototype = Object.create( PIXI.DisplayObject.prototype );
//PIXI.DisplayObjectContainer.prototype.constructor = PIXI.DisplayObjectContainer;

//TODO make visible a getter setter
/*
Object.defineProperty(PIXI.DisplayObjectContainer.prototype, 'visible', {
    get: function() {
        return this._visible;
    },
    set: function(value) {
        this._visible = value;
        
    }
});*/

/**
 * Adds a child to the container.
 *
 * @method addChild
 * @param child {DisplayObject} The DisplayObject to add to the container
 */
public function addChild (child:DisplayObject)
{
	if(child.parent != null)
	{
		
		//// COULD BE THIS???
		child.parent.removeChild(child);
	//	return;
	}

	child.parent = this;
	
	this.children.push(child);	
	
	// update the stage refference..
	
	if(this.stage != null)
	{
		var tmpChild = child;
		do
		{
			if(tmpChild.interactive)this.stage.dirty = true;
			tmpChild.stage = this.stage;
			tmpChild = tmpChild._iNext;
		}	
		while(tmpChild != null);
	}
	
	// LINKED LIST //
	
	// modify the list..
	var childFirst = child.first;
	var childLast = child.last;
	var nextObject:Dynamic;
	var previousObject:Dynamic;
	
	// this could be wrong if there is a filter??
	if(this.filter)
	{
		previousObject =  this.last._iPrev;
	}
	else
	{
		previousObject = this.last;
	}

	nextObject = previousObject._iNext;
	
	// always true in this case
	// need to make sure the parents last is updated too
	var updateLast = this;
	var prevLast = previousObject;
	
	while(updateLast != null)
	{
		if(updateLast.last == prevLast)
		{
			updateLast.last = child.last;
		}
		updateLast = updateLast.parent;
	}
	
	if(nextObject != null)
	{
		nextObject._iPrev = childLast;
		childLast._iNext = nextObject;
	}
	
	childFirst._iPrev = previousObject;
	previousObject._iNext = childFirst;		

	// need to remove any render groups..
	if(this.__renderGroup != null)
	{
		// being used by a renderTexture.. if it exists then it must be from a render texture;
		if(child.__renderGroup != null)child.__renderGroup.removeDisplayObjectAndChildren(child);
		// add them to the new render group..
		this.__renderGroup.addDisplayObjectAndChildren(child);
	}
	
}

/**
 * Adds a child to the container at a specified index. If the index is out of bounds an error will be thrown
 *
 * @method addChildAt
 * @param child {DisplayObject} The child to add
 * @param index {Number} The index to place the child in
 */
public function addChildAt (child:DisplayObject, index:Int)
{
	if(index >= 0 && index <= this.children.length)
	{
		if(child.parent != null)
		{
			child.parent.removeChild(child);
		}
		child.parent = this;
		
		if(this.stage != null)
		{
			var tmpChild = child;
			do
			{
				if(tmpChild.interactive)this.stage.dirty = true;
				tmpChild.stage = this.stage;
				tmpChild = tmpChild._iNext;
			}
			while(tmpChild != null);
		}
		
		// modify the list..
		var childFirst = child.first;
		var childLast = child.last;
		var nextObject:Dynamic;
		var previousObject:Dynamic;
		
		if(index == this.children.length)
		{
			previousObject =  this.last;
			var updateLast = this;
			var prevLast = this.last;
			while(updateLast != null)
			{
				if(updateLast.last == prevLast)
				{
					updateLast.last = child.last;
				}
				updateLast = updateLast.parent;
			}
		}
		else if(index == 0)
		{
			previousObject = this;
		}
		else
		{
			previousObject = this.children[index-1].last;
		}
		
		nextObject = previousObject._iNext;
		
		// always true in this case
		if(nextObject != null)
		{
			nextObject._iPrev = childLast;
			childLast._iNext = nextObject;
		}
		
		childFirst._iPrev = previousObject;
		previousObject._iNext = childFirst;		

		//this.children.splice(index, 0, child);
		this.children.insert (index, child);
		// need to remove any render groups..
		if(this.__renderGroup != null)
		{
			// being used by a renderTexture.. if it exists then it must be from a render texture;
			if(child.__renderGroup != null)child.__renderGroup.removeDisplayObjectAndChildren(child);
			// add them to the new render group..
			this.__renderGroup.addDisplayObjectAndChildren(child);
		}
		
	}
	else
	{
		throw child + " The index "+ index +" supplied is out of bounds " + this.children.length;
	}
}

/**
 * [NYI] Swaps the depth of 2 displayObjects
 *
 * @method swapChildren
 * @param child {DisplayObject}
 * @param child2 {DisplayObject}
 * @private
 */
private function swapChildren (child, child2)
{
	/*
	 * this funtion needs to be recoded.. 
	 * can be done a lot faster..
	 */
	return;
	
	// need to fix this function :/
	/*
	// TODO I already know this??
	var index = this.children.indexOf( child );
	var index2 = this.children.indexOf( child2 );
	
	if ( index !== -1 && index2 !== -1 ) 
	{
		// cool
		
		/*
		if(this.stage)
		{
			// this is to satisfy the webGL batching..
			// TODO sure there is a nicer way to achieve this!
			this.stage.__removeChild(child);
			this.stage.__removeChild(child2);
			
			this.stage.__addChild(child);
			this.stage.__addChild(child2);
		}
		
		// swap the positions..
		this.children[index] = child2;
		this.children[index2] = child;
		
	}
	else
	{
		throw new Error(child + " Both the supplied DisplayObjects must be a child of the caller " + this);
	}*/
}

/**
 * Returns the Child at the specified index
 *
 * @method getChildAt
 * @param index {Number} The index to get the child from
 */
public function getChildAt (index)
{
	if(index >= 0 && index < this.children.length)
	{
		return this.children[index];
	}
	else
	{
		throw index + " Both the supplied DisplayObjects must be a child of the caller " + this;
	}
}

/**
 * Removes a child from the container.
 *
 * @method removeChild
 * @param child {DisplayObject} The DisplayObject to remove
 */
public function removeChild (child)
{
	var index = -1;
	for (i in 0...children.length) {
		if (children[i] == child) index = i;
	}
	if ( index != -1 ) 
	{
		// unlink //
		// modify the list..
		var childFirst = child.first;
		var childLast = child.last;
		
		var nextObject:Dynamic = childLast._iNext;
		var previousObject:Dynamic = childFirst._iPrev;
			
		if(nextObject != null)nextObject._iPrev = previousObject;
		previousObject._iNext = nextObject;		
		
		if(this.last == childLast)
		{
			var tempLast =  childFirst._iPrev;	
			// need to make sure the parents last is updated too
			var updateLast = this;
			while(updateLast.last == childLast.last)
			{
				updateLast.last = tempLast;
				updateLast = updateLast.parent;
				if(updateLast == null)break;
			}
		}
		
		childLast._iNext = null;
		childFirst._iPrev = null;
		 
		// update the stage reference..
		if(this.stage != null)
		{
			var tmpChild = child;
			do
			{
				if(tmpChild.interactive)this.stage.dirty = true;
				tmpChild.stage = null;
				tmpChild = tmpChild._iNext;
			}	
			while(tmpChild != null);
		}
	
		// webGL trim
		if(child.__renderGroup != null)
		{
			child.__renderGroup.removeDisplayObjectAndChildren(child);
		}
		
		child.parent = null;
		this.children.splice( index, 1 );
	}
	else
	{
		throw child + " The supplied DisplayObject must be a child of the caller " + this;
	}
}

/*
 * Updates the container's children's transform for rendering
 *
 * @method updateTransform
 * @private
 */
private override function updateTransform ()
{
	if(!this.visible)return;
	
	super.updateTransform ();
	
	var i = 0;
	var j = this.children.length;
	while (i<j)
	{
		this.children[i].updateTransform();
		i++;
	}
}

}