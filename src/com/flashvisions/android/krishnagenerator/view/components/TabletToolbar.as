package com.flashvisions.android.krishnagenerator.view.components 
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.flashvisions.android.utils.AssetManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.CameraRoll;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class TabletToolbar extends Sprite 
	{
		[Embed(source = "../../../../../../assets/background.png")]
		private var backgroundIcon:Class;
		
		[Embed(source="../../../../../../assets/decoratives.png")]
		public var decorativeIcon:Class;
		
		[Embed(source="../../../../../../assets/text.png")]
		public var textIcon:Class;
		
		[Embed(source = "../../../../../../assets/camera.png")]
		public var cameraIcon:Class;
		
		[Embed(source = "../../../../../../assets/brush.png")]
		private var drawIcon:Class;
		
		[Embed(source = "../../../../../../assets/clear.png")]
		private var clearIcon:Class;
		
		[Embed(source="../../../../../../assets/share.png")]
		private var shareIcon:Class;
		
		[Embed(source="../../../../../../assets/save.png")]
		private var saveIcon:Class;
		
		[Embed(source="../../../../../../assets/quit.png")]
		private var quitIcon:Class;
		
		private var layout:HBox;
		
		public var backgrounds:IconButton;
		public var gallery:IconButton;
		public var decoratons:IconButton;
		public var text:IconButton;
		public var draw:IconButton;
		
		public var save:IconButton;
		public var share:IconButton;
		public var clear:IconButton;
		public var quit:IconButton;
		
		private var assetManager:AssetManager;
		private var screenDPI:String;
		
		public function TabletToolbar(screenDPI:String) 
		{
			this.screenDPI = screenDPI;
			createChildren();
		}		
		
		private function createChildren():void
		{
			assetManager = AssetManager.getInstance();
			
			layout = new HBox();
			layout.spacing = 30;
			addChild(layout);
			
			var backgroundIconBitmap:Bitmap = assetManager.getBackgroundIcon(screenDPI);
			backgrounds = new IconButton(null,0,0,backgroundIconBitmap);
			backgrounds.setSize(backgroundIconBitmap.width, backgroundIconBitmap.height);
			layout.addChild(backgrounds);
			
			if(CameraRoll.supportsBrowseForImage){
			var galleryIconBitmap:Bitmap = assetManager.getGalleryIcon(screenDPI);
			gallery = new IconButton(null,0,0,galleryIconBitmap);
			gallery.setSize(galleryIconBitmap.width, galleryIconBitmap.height);
			layout.addChild(gallery);
			}		
			
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
		}
	}

}