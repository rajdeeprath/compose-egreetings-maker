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
	public class Toolbar extends Sprite 
	{
		private var layout:HBox;
		
		public var backgrounds:IconButton;
		public var gallery:IconButton;
		public var decoratons:IconButton;
		public var text:IconButton;
		public var draw:IconButton;
		public var photos:IconButton;
		private var assetManager:AssetManager;
		
		private var screenDPI:String;
		
		public function Toolbar(screenDPI:String) 
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
			
			var backgroundIconBitmap:Bitmap = assetManager.getBackgroundIcon(screenDPI);
			backgrounds = new IconButton(null,0,0,backgroundIconBitmap);
			backgrounds.setSize(backgroundIconBitmap.width, backgroundIconBitmap.height);
			layout.addChild(backgrounds);
			
			var galleryIconBitmap:Bitmap = assetManager.getGalleryIcon(screenDPI);
			gallery = new IconButton(null,0,0,galleryIconBitmap);
			gallery.setSize(galleryIconBitmap.width, galleryIconBitmap.height);
			layout.addChild(gallery);
			
			var decorativeIconBitmap:Bitmap = assetManager.getObjectIcon(screenDPI);
			decoratons = new IconButton(null,0,0,decorativeIconBitmap);
			decoratons.setSize(decorativeIconBitmap.width, decorativeIconBitmap.height);
			layout.addChild(decoratons);

			var textIconBitmap:Bitmap = assetManager.getTextIcon(screenDPI);
			text = new IconButton(null,0,0,textIconBitmap);
			text.setSize(textIconBitmap.width, textIconBitmap.height);
			layout.addChild(text);
			
			var brushIconBitmap:Bitmap = assetManager.getBrushIcon(screenDPI);
			draw = new IconButton(null,0,0,brushIconBitmap);
			draw.setSize(brushIconBitmap.width, brushIconBitmap.height);
			layout.addChild(draw);
		}
	}
	

}