package com.flashvisions.android.krishnagenerator.view.components 
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.flashvisions.android.utils.AssetManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.CameraRoll;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class DrawingToolbar extends Sprite 
	{
		private var layout:HBox;
		
		public var btnCanvasOptions:IconButton;
		public var btnBrushOptions:IconButton;
		public var btnUndo:IconButton;
		public var btnClear:IconButton;
		public var btnQuit:IconButton;
		
		private var assetManager:AssetManager;		
		private var screenDPI:String;
		
		public function DrawingToolbar(screenDPI:String) 
		{
			this.screenDPI = screenDPI;
			createChildren();
		}
		
		private function createChildren():void
		{
			assetManager = AssetManager.getInstance();
			
			layout = new HBox();
			layout.spacing = 20;
			addChild(layout);
			
			var btnCanvasOptionsIconBitmap:Bitmap = assetManager.getBackgroundIcon(screenDPI);
			btnCanvasOptions = new IconButton(null,0,0, btnCanvasOptionsIconBitmap);
			btnCanvasOptions.setSize(btnCanvasOptionsIconBitmap.width, btnCanvasOptionsIconBitmap.height);
			layout.addChild(btnCanvasOptions);
			
			var brushIconBitmap:Bitmap = assetManager.getBrushIcon(screenDPI);
			btnBrushOptions = new IconButton(null,0,0,brushIconBitmap);
			btnBrushOptions.setSize(brushIconBitmap.width, brushIconBitmap.height);
			layout.addChild(btnBrushOptions);
			
			var undoIconBitmap:Bitmap = assetManager.getUndoIcon(screenDPI);
			btnUndo = new IconButton(null,0,0,undoIconBitmap);
			btnUndo.setSize(undoIconBitmap.width, undoIconBitmap.height);
			layout.addChild(btnUndo);
			
			var clearIconBitmap:Bitmap = assetManager.getClearIcon(screenDPI);
			btnClear = new IconButton(null,0,0,clearIconBitmap);
			btnClear.setSize(clearIconBitmap.width, clearIconBitmap.height);
			layout.addChild(btnClear);
			
			var quitIconBitmap:Bitmap = assetManager.getQuitIcon(screenDPI);
			btnQuit = new IconButton(null,0,0,quitIconBitmap);
			btnQuit.setSize(quitIconBitmap.width, quitIconBitmap.height);
			layout.addChild(btnQuit);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			draw();
		}
		
		public function draw():void
		{
			
		}
	}

}