package com.flashvisions.android.krishnagenerator.view.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Krishna
	 */
	
	public class DrawingView extends Sprite 
	{
		public var canvas:Canvas;
		public var toolbar:DrawingToolbar;
		
		private var canvasWidth:Number;
		private var canvasHeight:Number;
		private var screenDPI:String;
		
		public function DrawingView(_width:Number, _height:Number, dpi:String) 
		{
			canvasWidth = _width;
			canvasHeight = _height;
			screenDPI = dpi;
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			canvas = new Canvas(canvasWidth, canvasHeight);
			addChild(canvas);
			
			toolbar = new DrawingToolbar(screenDPI);
			addChild(toolbar);
			
			drawLayout();
		}
		
		private function drawLayout():void
		{			
			canvas.setSize(canvasWidth, canvasHeight);
			canvas.x = this.stage.stageWidth / 2 - canvas.width / 2;
			canvas.y =  this.stage.stageHeight / 2 - canvas.height / 2;
			
			toolbar.x = this.stage.stageWidth / 2 - toolbar.width / 2;
			toolbar.y = this.stage.stageHeight - toolbar.height - 5;
		}
		
	}

}