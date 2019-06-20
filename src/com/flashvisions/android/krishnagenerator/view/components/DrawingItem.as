package com.flashvisions.android.krishnagenerator.view.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class DrawingItem extends Sprite 
	{
		private var drawing:Sprite;
		
		public function DrawingItem(drawing:Sprite) 
		{
			this.drawing = drawing;
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			
			if (stage) autoLayout();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			autoLayout();
		}
		
		protected function autoLayout():void
		{
			if(!this.contains(drawing))
			addChild(drawing);
			
			drawing.x = -(drawing.width / 2);
			drawing.y = -(drawing.height / 2);
			
			centerOnParent();
		}
		
		public function centerOnParent():void
		{
			this.x = this.parent.width / 2;
			this.y = this.parent.height / 2;
		}
	}

}