package com.flashvisions.android.krishnagenerator.view.components 
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.flashvisions.android.utils.AssetManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class Menubar extends Sprite 
	{	
		private var layout:HBox;
		
		public var save:IconButton;
		public var share:IconButton;
		public var clear:IconButton;
		public var quit:IconButton;
		
		public var camera:IconButton;
		
		private var assetManager:AssetManager;
		private var screenDPI:String;
		
		public function Menubar(screenDPI:String) 
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
			
			var clearIconBitmap:Bitmap = assetManager.getClearIcon(screenDPI);
			clear = new IconButton(null, 0, 0, clearIconBitmap);
			clear.setSize(clearIconBitmap.width, clearIconBitmap.height);
			layout.addChild(clear);
			
			var saveIconBitmap:Bitmap = assetManager.getSaveIcon(screenDPI);
			save = new IconButton(null, 0, 0, saveIconBitmap);
			save.setSize(saveIconBitmap.width, saveIconBitmap.height);
			layout.addChild(save);
			
			var shareIconBitmap:Bitmap = assetManager.getShareIcon(screenDPI);
			share = new IconButton(null, 0, 0, shareIconBitmap);
			share.setSize(shareIconBitmap.width, shareIconBitmap.height);
			layout.addChild(share);
			
			var quitIconBitmap:Bitmap = assetManager.getQuitIcon(screenDPI);
			quit = new IconButton(null, 0, 0, quitIconBitmap);
			quit.setSize(quitIconBitmap.width, quitIconBitmap.height);
			layout.addChild(quit);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onStage(e:Event):void
		{
			draw();
		}
		
		public function draw():void
		{
			
		}
		
		private function onRemoved(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			layout.removeChild(clear);
			
			layout.removeChild(save);
			
			layout.removeChild(share);
			
			layout.removeChild(quit);
		}
	}

}