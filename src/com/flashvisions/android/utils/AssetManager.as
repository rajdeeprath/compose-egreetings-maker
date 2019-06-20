package com.flashvisions.android.utils 
{
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Krishna
	 */
	public class AssetManager 
	{
		private static const PACKAGE:String = "com.flashvisions.android.utils.AssetManager_";
		private static const DPILIST:Array = ["ldpi", "mdpi", "hdpi", "xhdpi", "tvdpi"];
		
		
		[Embed(source="../../../../assets/ldpi/menutoggle.png")]
		private var menuIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/menutoggle.png")]
		private var menuIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/menutoggle.png")]
		private var menuIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/menutoggle.png")]
		private var menuIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/menutoggle.png")]
		private var menuIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/background.png")]
		private var backgroundIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/background.png")]
		private var backgroundIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/background.png")]
		private var backgroundIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/background.png")]
		private var backgroundIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/background.png")]
		private var backgroundIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/gallery.png")]
		private var galleryIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/gallery.png")]
		private var galleryIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/gallery.png")]
		private var galleryIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/gallery.png")]
		private var galleryIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/gallery.png")]
		private var galleryIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/photos.png")]
		private var photoIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/photos.png")]
		private var photoIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/photos.png")]
		private var photoIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/photos.png")]
		private var photoIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/photos.png")]
		private var photoIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/decoratives.png")]
		private var objectIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/decoratives.png")]
		private var objectIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/decoratives.png")]
		private var objectIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/decoratives.png")]
		private var objectIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/decoratives.png")]
		private var objectIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/text.png")]
		private var textIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/text.png")]
		private var textIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/text.png")]
		private var textIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/text.png")]
		private var textIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/text.png")]
		private var textIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/brush.png")]
		private var brushIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/brush.png")]
		private var brushIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/brush.png")]
		private var brushIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/brush.png")]
		private var brushIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/brush.png")]
		private var brushIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/save.png")]
		private var saveIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/save.png")]
		private var saveIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/save.png")]
		private var saveIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/save.png")]
		private var saveIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/save.png")]
		private var saveIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/clear.png")]
		private var clearIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/clear.png")]
		private var clearIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/clear.png")]
		private var clearIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/clear.png")]
		private var clearIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/clear.png")]
		private var clearIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/share.png")]
		private var shareIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/share.png")]
		private var shareIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/share.png")]
		private var shareIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/share.png")]
		private var shareIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/share.png")]
		private var shareIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/quit.png")]
		private var quitIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/quit.png")]
		private var quitIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/quit.png")]
		private var quitIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/quit.png")]
		private var quitIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/quit.png")]
		private var quitIconXHDPI:Class;
		
		
		[Embed(source="../../../../assets/ldpi/undo.png")]
		private var undoIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/undo.png")]
		private var undoIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/undo.png")]
		private var undoIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/undo.png")]
		private var undoIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/undo.png")]
		private var undoIconXHDPI:Class;
		
		[Embed(source="../../../../assets/ldpi/redo.png")]
		private var redoIconLDPI:Class;
		[Embed(source="../../../../assets/mdpi/redo.png")]
		private var redoIconMDPI:Class;
		[Embed(source="../../../../assets/hdpi/redo.png")]
		private var redoIconHDPI:Class;
		[Embed(source="../../../../assets/tvdpi/redo.png")]
		private var redoIconTVDPI:Class;
		[Embed(source="../../../../assets/xhdpi/redo.png")]
		private var redoIconXHDPI:Class;
		
		private static var instance:AssetManager = null;
		
		
		public static function getInstance():AssetManager
		{
			if (instance == null)
			instance = new AssetManager();
			return instance;
		}
		
		public function getBackgroundIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "backgroundIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		
		public function getGalleryIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "galleryIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getPhotoIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "photoIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getObjectIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "objectIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getTextIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "textIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getBrushIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "brushIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getSaveIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "saveIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getShareIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "shareIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getClearIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "clearIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getQuitIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "quitIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		
		public function getUndoIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "undoIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getRedoIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "redoIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function getMenuIcon(screenDPI:String):Bitmap
		{
			var Icon:Class = getDefinitionByName(PACKAGE + "menuIcon" + screenDPI.toUpperCase()) as Class;
			return new Icon() as Bitmap;
		}
		
		public function sanitizeDPISTring(dpiString:String):String
		{
			if(DPILIST.indexOf(dpiString.toLowerCase()) >= 0)
			return dpiString;
			else
			return DPILIST[3];
		}
	}

}