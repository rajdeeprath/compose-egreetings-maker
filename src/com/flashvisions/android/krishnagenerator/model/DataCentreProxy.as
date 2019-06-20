package com.flashvisions.android.krishnagenerator.model
{
	
	import air.net.URLMonitor;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.locale.LocaleString;
	import com.flashvisions.android.krishnagenerator.model.business.LoadCategoriesDelegate;
	import com.flashvisions.android.krishnagenerator.vo.Category;
	import com.flashvisions.android.krishnagenerator.vo.DrawingBoardData;
	import com.flashvisions.android.krishnagenerator.vo.TextData;
	import com.flashvisions.mobile.android.extensions.compose.ComposeUtils;
	import com.flashvisions.mobile.android.extensions.compose.event.ComposerEvent;
	import com.flashvisions.mobile.android.extensions.net.NetworkInfo;
	import com.remoting.RemotingConnection;
	import com.ssd.ane.AndroidExtensions;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.as3commons.logging.api.ILogger;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeProgressDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.iNativeDialog;
	import ru.etcs.utils.FontLoader;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	import org.as3commons.logging.api.ILogger
	import org.as3commons.logging.api.LOGGER_FACTORY
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	
	public class DataCentreProxy extends Proxy implements IProxy
	{
		private static var logger:ILogger = getLogger(DataCentreProxy);
		
		public static const GATEWAY:String = "http://funbling.flashvisions.com/flashservices/";
		public static const APPURL:String = "https://play.google.com/store/apps/details?id=air.air.Compose";
		public static const STORAGE_DIRECTORY:String = "compose";
		public static const CATEGORIES_FILE:String = "categories.json";
		public static const INSTRUCTIONS_FILE:String = "instructions.json";
		public static const FONTS_FILE:String = "fonts.xml";
		public static const DECORATIVES:String = "decoratives";
		public static const BACKGROUNDS:String = "backgrounds";
		public static const NAME:String = "DataCentreProxy";
		public var connectivity:uint;
		private static var service:RemotingConnection;
		private var categoriesCollection:Array;
		private var categoryNames:Array;
		private var instructions:Object;
		public var fontSWFPath:String;
		public var fontPreviewPath:String;
		private var fonts:Array;
		private var fontNames:Array;
		private var progressPopup:NativeProgressDialog;
		private var loadedFonts:Vector.<String>;
		private var category:Category;
		private var bgcategoryID:uint;
		private var decorcategoryID:uint;
		public var mode:String;
		private static var fontloader:FontLoader;
		private static var networkInfo:NetworkInfo;
		private static var composeutils:ComposeUtils;
		private var compositionTimestamp:Number = 0;
		private var nativeAlert:NativeAlertDialog;
		private var categoryListDialog:NativeListDialog;
		private static var LOCALSTORE:SharedObject;
		public static const FONT_SIZE_BOOST:int = 40;
		private var bonjour:uint;
		private var drawingBoardData:DrawingBoardData;
		
		
		private function initLogging():void
		{
			LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget());
		}
		
		public function DataCentreProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get CurrentDecorativeCategoryID():uint
		{
			return decorcategoryID as uint;
		}
		
		public function set CurrentDecorativeCategoryID(decorcategoryID:uint):void
		{
			this.decorcategoryID = decorcategoryID;
		}
		
		public function get CurrentBackgroundCategoryID():uint
		{
			return bgcategoryID as uint;
		}
		
		public function set CurrentBackgroundCategoryID(bgcategoryID:uint):void
		{
			this.bgcategoryID = bgcategoryID;
		}
		
		public function get CurrentCategory():Category
		{
			return category as Category;
		}
		
		public function set CurrentCategory(category:Category):void
		{
			this.category = category;
		}
		
		public function showBackgroundsList():void
		{
			if(isNetworkConnected())
			composeutils.showBackgroundsList();
			else
			showNetworkAlertToast();
		}
		
		public function showObjectsList():void
		{
			if(isNetworkConnected())
			composeutils.showObjectsList();	
			else
			showNetworkAlertToast();
		}
		
				
		public function loadCategories(responder:Responder):void
		{
			var loadDecorsDelgate:LoadCategoriesDelegate = new LoadCategoriesDelegate(responder);
			loadDecorsDelgate.loadCategories();
		}
		
		public function loadInstructions(responder:Responder):void
		{
			var loadDecorsDelgate:LoadCategoriesDelegate = new LoadCategoriesDelegate(responder);
			loadDecorsDelgate.loadInstructions();
		}

		
		/* INTERFACE org.puremvc.as3.interfaces.IProxy */
	
		override public function getProxyName():String 
		{
			return NAME;
		}
		
		public function hideProgressPopup():void
		{
			try {	
			progressPopup.hide();
			progressPopup.dispose();
			}catch (e:Error) {
			}finally {
			progressPopup = null;
			}
		}
		
		public function updateProgress(title:String, message:String):void
		{
			try{
			progressPopup.title = title;
			progressPopup.message =message;
			}catch (e:Error) {
			if (!progressPopup)
			showProgressPopup(title, message);
			}
		}
		
		public function showProgressPopup(title:String, message:String):void
		{
			try {
				if (progressPopup) throw new Error("EXISTS");
				progressPopup = new NativeProgressDialog();
				progressPopup.title = title;
				progressPopup.message = message;
				progressPopup.androidTheme = NativeProgressDialog.ANDROID_DEVICE_DEFAULT_DARK_THEME;
				progressPopup.showSpinner();
			}catch (e:Error) {
				trace("Error " + e.message + "   " + e.toString());
				if (e.message == "EXISTS")
				updateProgress(title, message);
			}
		}
		
		public function get CategoryNames():Array
		{
			return this.categoryNames as Array;
		}
		
		public function set Categories(data:Object):void 
		{
			this.categoriesCollection = data as Array ;
			
			/* Extract titles */
			for (var i:uint = 0; i < this.categoriesCollection.length;i++)
			this.categoryNames[i] = this.categoriesCollection[i].label;
			
			setCategories(this.categoriesCollection)
		}
		
		public function set Instructions(instructions:Object):void 
		{
			this.instructions = instructions;
		}
		
		public function get Instructions():Object 
		{
			return this.instructions;
		}
		
		public function get Categories():Object 
		{
			return this.categoriesCollection;
		}
		
		public static function getService():RemotingConnection
		{
			return service;
		}
				
		public static function getFontLoader():FontLoader
		{
			return (fontloader == null)?new FontLoader():fontloader;
		}
		
		public function set Fonts(data:Object):void 
		{
			this.fonts = data as Array ;
			updateFontNames();
		}
		
		public function set DrawingBoardSettings(drawingBoardData:DrawingBoardData):void
		{
			this.drawingBoardData = drawingBoardData;
		}
		
		public function get DrawingBoardSettings():DrawingBoardData
		{
			return drawingBoardData;
		}
		
		public function get Fonts():Object 
		{
			return this.fonts;
		}
		
		public function get FontNames():Object
		{
			return fontNames;
		}
		
		public function set LoadedFonts(data:Vector.<String>):void 
		{
			this.loadedFonts = data as Vector.<String> ;
		}
		
		public function get LoadedFonts():Vector.<String> 
		{
			return this.loadedFonts;
		}
		
		
		override public function setData(data:Object):void 
		{
			this.data = data;
		}
		
		override public function getData():Object 
		{
			return this.data;
		}
		
		override public function onRegister():void 
		{
			initLogging();
			
			/* init cache directory */
			var cacheDirectory:File = File.documentsDirectory.resolvePath(STORAGE_DIRECTORY);
			if (!cacheDirectory.exists || !cacheDirectory.isDirectory)	cacheDirectory.createDirectory();
			
			LOCALSTORE = SharedObject.getLocal(STORAGE_DIRECTORY);
			
			categoryNames = new Array();
			fontNames = new Array();
			loadedFonts = new Vector.<String>();
			drawingBoardData = new DrawingBoardData();
			
			networkInfo = new NetworkInfo();	
			
			service = new RemotingConnection();
			service.addEventListener(NetStatusEvent.NET_STATUS, onServiceStatus);
			service.connect(GATEWAY);
			
			composeutils = ComposeUtils.getInstance();
			composeutils.addEventListener(ComposerEvent.COMPOSITION_CHANGE, onCompositionChange);
			composeutils.addEventListener(ComposerEvent.COMPOSITION_CANCEL, onCompositionCancel);
			composeutils.addEventListener(ComposerEvent.COMPOSITION_ERROR, onCompositionError);
			composeutils.addEventListener(ComposerEvent.COMPOSITION_FONT_CHANGE, onCompositionFontChanged);
			composeutils.addEventListener(ComposerEvent.TOOLBAR_CHANGE, onObjectToobarChange);
			composeutils.addEventListener(ComposerEvent.TOOLBAR_CANCEL, onObjectToobarCancel);
			composeutils.addEventListener(ComposerEvent.BRUSH_SETTINGS_CHANGE, onBrushOptionsChange);
			composeutils.addEventListener(ComposerEvent.BRUSH_SETTINGS_CANCEL, onBrushOptionsCancel);
			composeutils.addEventListener(ComposerEvent.CANVAS_COLOR_CHANGE, onCanvasColorChange);
			composeutils.addEventListener(ComposerEvent.ERASER_SETTINGS_CHANGE, onEraserOptionsChange);
			composeutils.addEventListener(ComposerEvent.ERASER_SETTINGS_CANCEL, onEraserOptionsCancel);
			composeutils.addEventListener(ComposerEvent.TRANSFORM_SCALE, onTransformScale);
			composeutils.addEventListener(ComposerEvent.TRANSFORM_ROTATE, onTransformRotate);
			composeutils.addEventListener(ComposerEvent.OBJECT_SELECTED, onObjectSelected);
			composeutils.addEventListener(ComposerEvent.BACKGROUND_SELECTED, onBackgroundSelected);
		}
				
		override public function onRemove():void 
		{
			
		}
		
		private function checkConnectivity():void
		{
			clearTimeout(connectivity);
			
			if (!isNetworkConnected()) {
			updateProgress("", getResourceString(LocaleString.WAITING_FOR_CONNECTION_MESSAGE));
			waitForNetwork();
			}else {
			hideProgressPopup();
			}
		}
		
		public function waitForNetwork():void
		{
			connectivity = setTimeout(checkConnectivity, 3000);
		}
		
		public function showChangeLog():void
		{
			var lastUpdate:Object = readDataStore("changecode");
			var currentUpdate:Object = Instructions.changecode;
			
			if (lastUpdate != currentUpdate)
			{
				if (!nativeAlert)
				nativeAlert = new NativeAlertDialog();
				nativeAlert.title = "Updates";
				nativeAlert.message = Instructions.changelog;
				nativeAlert.show();
			}
			
			writeDataStore("changecode", currentUpdate);
		}
		
		public function readDataStore(prop:String):Object
		{
			return LOCALSTORE.data[prop];
		}
		
		public function writeDataStore(prop:String, value:Object):void
		{
			LOCALSTORE.data[prop] = value;
			LOCALSTORE.flush();
		}
		
		/********************* Public funtions ****************************/
		public function setCategories(categories:Object):void
		{
			composeutils.setCategories(categories);
		}
		
		public function getCategories():String
		{
			return composeutils.getCategories();
		}
	
		public function getResourceString(resource:String):String
		{
			return composeutils.getResourceString(resource);
		}
		
		public function getDeviceDPIString():String
		{
			return composeutils.getDPIString();
		}
		
		public function wasIntroShownBefore():Boolean
		{
			return composeutils.wasIntroShownBefore();
		}
		
		public function getDeviceDPI():int
		{
			return composeutils.getDPI();
		}
		
		public function isTransformToolShowing():Boolean
		{
			return composeutils.isTransformOptionShowing();
		}
		
		public function hideTransformToolsIfShowing():void
		{
			if (isTransformToolShowing())
			composeutils.hideTransformOptions();
		}
		
		public function updateTransformToolsTarget(maxScale:uint, currentScale:uint, maxRotate:uint, currentRotate:uint, dialogHeight:uint = 35):void
		{
			composeutils.showTransformOptions(maxScale, currentScale, maxRotate, currentRotate, dialogHeight);
		}
		
		public function showTransformTools(maxScale:uint, currentScale:uint, maxRotate:uint, currentRotate:uint, dialogHeight:uint = 35):void
		{
			if(!composeutils.isTransformOptionShowing())
			composeutils.showTransformOptions(maxScale, currentScale, maxRotate, currentRotate, dialogHeight);
		}
		
		public function showEraserOptions(eraserSize:int):void
		{
			composeutils.showEraserOptions(eraserSize, 200, 170);
		}
		
		
		public function getDrawingBoardData():DrawingBoardData
		{
			var requestedBrushColor:uint = this.drawingBoardData.brushColor;
			var requestedBrushSize:int = this.drawingBoardData.brushSize;
			var previousBrushColor:Object = readDataStore("brushColor"); 
			var previousBrushSize:Object = readDataStore("brushSize"); 
			var color:uint = (previousBrushColor == null)?requestedBrushColor:previousBrushColor as uint;
			var size:int = (previousBrushSize == null)?requestedBrushSize:previousBrushSize as int;
			
			this.drawingBoardData.brushColor = color;
			this.drawingBoardData.brushSize = size;
			
			return this.drawingBoardData;
		}
		
		public function buildCache():void
		{
			const DAYS1:int = 7 * (24 * 60 * 60 * 1000);
			const DAYS2:int = 7 * (24 * 60 * 60 * 1000);
			
			var currentTimeStamp:int = new Date().getTime();
			var lastCategoryCacheData:Object = readDataStore("lastCategoryCacheDate");
			var lastInstuctionCacheData:Object = readDataStore("lastInstructionCacheDate");
			var lastCategoryCache:int = (lastCategoryCacheData == null)?0:lastCategoryCacheData as int;
			var lastInstructionCache:int = (lastInstuctionCacheData == null)?0:lastInstuctionCacheData as int;

			if (isNetworkConnected()) 
			{
				var timeElapsed:Number = currentTimeStamp - lastCategoryCache;
				logger.info("timeElapsed since last cache {0}", [timeElapsed]);
				  
				if (timeElapsed >= DAYS1 || timeElapsed<0)
				{
					facade.sendNotification(ApplicationFacade.CACHECATEGORIES);
					writeDataStore("lastCategoryCacheDate", currentTimeStamp);
				}
				if (currentTimeStamp - lastInstructionCache >= DAYS2)
				{
					facade.sendNotification(ApplicationFacade.CACHEINSTRUCTIONS);
					writeDataStore("lastInstructionCacheDate", currentTimeStamp);
				}
			}
		}
				
		public function showBrushOptions(brushSize:int, brushColor:uint):void
		{
			var color:String = formatHexForAndroid(brushColor.toString(16));
			composeutils.showBrushOptions(brushSize, color, 200,220);
		}
		
		public function showCanvasOptions(canvasColor:uint):void
		{
			var color:String = formatHexForAndroid(canvasColor.toString(16));
			composeutils.showCanvasOptions(color);
		}
		
		
		public function showObjectToolbar():void
		{
			composeutils.showObjectToolbar(360,180);
		}
		
		public function onObjectSelected(e:ComposerEvent):void
		{
			facade.sendNotification(ApplicationFacade.ADDDECORATIVE, e.data)
		}
		
		public function onBackgroundSelected(e:ComposerEvent):void
		{
			facade.sendNotification(ApplicationFacade.ADDBACKGROUND, e.data)
		}
		
		public function getTextEditorData():Object
		{
			var requestedFontColor:Object = "#FF8C00";
			var requestedFontSize:Object = 60;
			var requestedFontName:String = this.fontNames[0];
			
			var previousFontColor:Object = readDataStore("fontcolor");
			var previousFontSize:Object = readDataStore("fontsize");
			var previousFontName:String = readDataStore("fontname") as String;
			
			var data:Object = new Object();
			data.color = (previousFontColor == null)?requestedFontColor:previousFontColor;
			data.size = (previousFontSize == null)?requestedFontSize:previousFontSize;
			data.font = (previousFontName == null)?requestedFontName:previousFontName;
			data.text = "";
			
			return data;
		}
		
		public function showTextEditor(data:Object):void
		{
			var size:int = data.size - FONT_SIZE_BOOST;
			var font:String = data.font;
			var text:String = data.text;
			var color:String = (data.color is String)?data.color:formatHexForAndroid(data.color.toString(16));
			

			
			facade.sendNotification(ApplicationFacade.LOADFONT, getFontByName(font));
			composeutils.showTextComposer(text, fontNames, font, size, color, 400, 300);
		}
		
		public function requiresOnScreenMenuButton():Boolean
		{
			return composeutils.requiresOnScreenMenuButton();
		}
		
		public function isFontRegistered(fontname:String):Boolean
		{
			for (var i:uint = 0; i < loadedFonts.length; i++)
			if (loadedFonts[i] == fontname) return true;
			
			return false;
		}
		
		public function getFontByName(fontName:String):Object
		{
			for (var i:int = 0; i < fonts.length; i++)
			if (fonts[i].name == fontName) return fonts[i];
			return null;
		}
		
		public function showDrawingViewCloseDialog():void
		{
			if (!nativeAlert)
			nativeAlert = new NativeAlertDialog();
			nativeAlert.addEventListener(NativeDialogEvent.CLOSED, onDrawingViewDialogClose);
			nativeAlert.title = getResourceString(LocaleString.CONFIRM_ACTION);
			nativeAlert.message = getResourceString(LocaleString.DRAWING_VIEW_CLOSE_MESSAGE);
			nativeAlert.closeLabel = getResourceString(LocaleString.YES);
			nativeAlert.otherLabels = getResourceString(LocaleString.NO);
			nativeAlert.show();
		}
		
		
		
		public function exit():void
		{
			
			if (NativeAlertDialog.isSupported)
			{
				if (!nativeAlert)
				nativeAlert = new NativeAlertDialog();
				nativeAlert.addEventListener(NativeDialogEvent.CLOSED, onExitDialogClose);
				nativeAlert.title = getResourceString(LocaleString.APPLICATION_EXIT_TITLE);
				nativeAlert.message = getResourceString(LocaleString.APPLICATION_EXIT_MESSAGE);
				nativeAlert.closeLabel = getResourceString(LocaleString.APPLICATION_EXIT_YES);
				nativeAlert.otherLabels = getResourceString(LocaleString.APPLICATION_EXIT_NO) + "," + getResourceString(LocaleString.APPLICATION_TELL_FRIEND);
				nativeAlert.show();
			}
			else
			{
				exitImmediately();
			}
			
		}
		
		public function showNetworkAlertToast():void
		{
			AndroidExtensions.toast(getResourceString(LocaleString.NETWORK_UNAVAILABLE_MESSAGE_3), true);
		}
		
		public function showNetworkAlertDialog():void
		{
				if (!nativeAlert)
				nativeAlert = new NativeAlertDialog();
				nativeAlert.addEventListener(NativeDialogEvent.CLOSED, onNetworkAlertDialogClose);
				nativeAlert.title = getResourceString(LocaleString.NETWORK_UNAVAILABLE_TITLE);
				nativeAlert.message = getResourceString(LocaleString.NETWORK_UNAVAILABLE_MESSAGE);
				nativeAlert.closeLabel = getResourceString(LocaleString.YES);
				nativeAlert.otherLabels = getResourceString(LocaleString.NO);
				nativeAlert.show();
		}
		
		public function showServiceAlertDialog():void
		{
				if (!nativeAlert)
				nativeAlert = new NativeAlertDialog();
				nativeAlert.addEventListener(NativeDialogEvent.CLOSED, onServiceAlertDialogClose);
				nativeAlert.title = getResourceString(LocaleString.SERVICE_UNAVAILABLE_TITLE);
				nativeAlert.message = getResourceString(LocaleString.SERVICE_UNAVAILABLE_MESSAGE);
				nativeAlert.closeLabel = getResourceString(LocaleString.OK);
				nativeAlert.show();
		}
		
		public function isNetworkConnected():Boolean
		{
			return networkInfo.isNetworkConnected();
		}
		
		
		public function monitorConnection():void
		{
			clearInterval(bonjour);
			bonjour = setInterval(checkConnection, 8000);
		}
		
		public function cacheContentToFile(content:String, file:File):void
		{
			var fileStream:FileStream;
			
			try 
			{
				fileStream = new FileStream(); 
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes(content);
			}
			catch (e:Error)
			{
				//trace(e.message);
			}
			finally 
			{
				fileStream.close();
				fileStream = null;
				file = null;
			}
		}
		
		
		/********************* Private funtions ****************************/
		private function onTransformScale(ce:ComposerEvent):void
		{
			var max:uint = ce.data.max;
			var value:uint = ce.data.value;
			var scale:Number = value/10;
			
			facade.sendNotification(ApplicationFacade.SCALE, scale);
		}
		
		private function onTransformRotate(ce:ComposerEvent):void
		{
			var max:uint = ce.data.max;
			var min:uint = max / 2;
			var value:int = ce.data.value - 180;
			
			facade.sendNotification(ApplicationFacade.ROTATE, value);
		}
		
		private function onEraserOptionsChange(ce:ComposerEvent):void
		{
			var size:uint = drawingBoardData.eraserSize = ce.data.size;
			facade.sendNotification(ApplicationFacade.ERASERSETTINGSCHANGED, {"eraserSize":size});
		}
		
		private function onEraserOptionsCancel(ce:ComposerEvent):void
		{
			
		}
		
		private function onCanvasColorChange(ce:ComposerEvent):void
		{
			var color:uint = drawingBoardData.canvasColor = uint(setCharAt(ce.data.color as String, "0x", 0));
			facade.sendNotification(ApplicationFacade.CANVASSETTINGSCHANGED, {"canvasColor":color});
		}
		
		private function onBrushOptionsChange(e:ComposerEvent):void
		{
			var color:uint = drawingBoardData.brushColor =  uint(setCharAt(e.data.color as String, "0x", 0));
			var size:uint = drawingBoardData.brushSize = e.data.size;
			writeDataStore("brushColor", color);
			writeDataStore("brushSize", size);
			facade.sendNotification(ApplicationFacade.BRUSHSETTINGSCHANGED, {"brushColor":color, "brushSize":size});
		}
		
		private function onBrushOptionsCancel(e:ComposerEvent):void
		{
			// NO OP
		}
		
		
		private function onServiceStatus(e:NetStatusEvent):void
		{
			if (e.info.code == "NetConnection.Call.Failed" || e.info.level == "error")
			showServiceAlertDialog();
		}
		
		
		private function onDrawingViewDialogClose(event:NativeDialogEvent):void
		{
			var nativeAlert:NativeAlertDialog = event.target as NativeAlertDialog;
			nativeAlert.removeEventListener(NativeDialogEvent.CLOSED, onDrawingViewDialogClose);
			
			var saveDrawing:Boolean = (parseInt(event.index) == 0)?true:false;
			facade.sendNotification(ApplicationFacade.CLOSEDRAWINGBOARDWITHSAVE, saveDrawing);
			
			nativeAlert = null;
		}
		
		private function onServiceAlertDialogClose(event:NativeDialogEvent):void
		{
			var nativeAlert:NativeAlertDialog = event.target as NativeAlertDialog;
			nativeAlert.removeEventListener(NativeDialogEvent.CLOSED, onNetworkAlertDialogClose);
			
			exitImmediately();
		}
		
		
		private function onNetworkAlertDialogClose(event:NativeDialogEvent):void
		{
			var nativeAlert:NativeAlertDialog = event.target as NativeAlertDialog;
			nativeAlert.removeEventListener(NativeDialogEvent.CLOSED, onNetworkAlertDialogClose);
			
		
			if (parseInt(event.index) == 0) {
			networkInfo.openNetworkSettings();
			}else {
			exitImmediately();
			}
		}
		
		private function checkConnection():void
		{
			if (!isNetworkConnected())
			facade.sendNotification(ApplicationFacade.NETWORKUNAVAILABLE);
			else
			facade.sendNotification(ApplicationFacade.NETWORKAVAILABLE);
		}		
		
		private function updateFontNames():void
		{
			this.fontNames = [];
			for (var i:int = 0; i < this.fonts.length; i++)
			this.fontNames.push(this.fonts[i].name.toString());
		}
		
		private function setCharAt(str:String, char:String,index:int):String {
			return str.substr(0,index) + char + str.substr(index + 1);
		}
		
		private function formatHexForAndroid(hexStr:String):String
		{
			var strLength:uint = hexStr.length;
			
			if (strLength < 6){
			for (var j:uint; j < (6-strLength); j++){
			hexStr = "0" + hexStr;
			}
			}
			
			return "#"+hexStr;
		}
		
		
		private function exitImmediately():void
		{
			composeutils.removeEventListener(ComposerEvent.COMPOSITION_CHANGE, onCompositionChange);
			composeutils.removeEventListener(ComposerEvent.COMPOSITION_CANCEL, onCompositionCancel);
			composeutils.removeEventListener(ComposerEvent.COMPOSITION_ERROR, onCompositionError);
			composeutils.removeEventListener(ComposerEvent.COMPOSITION_FONT_CHANGE, onCompositionFontChanged);
			composeutils.removeEventListener(ComposerEvent.TOOLBAR_CHANGE, onObjectToobarChange);
			composeutils.removeEventListener(ComposerEvent.TOOLBAR_CANCEL, onObjectToobarCancel);
			composeutils.removeEventListener(ComposerEvent.BRUSH_SETTINGS_CHANGE, onBrushOptionsChange);
			composeutils.removeEventListener(ComposerEvent.BRUSH_SETTINGS_CANCEL, onBrushOptionsCancel);
			composeutils.removeEventListener(ComposerEvent.CANVAS_COLOR_CHANGE, onCanvasColorChange);
			composeutils.removeEventListener(ComposerEvent.ERASER_SETTINGS_CHANGE, onEraserOptionsChange);
			composeutils.removeEventListener(ComposerEvent.ERASER_SETTINGS_CANCEL, onEraserOptionsCancel);
			composeutils.removeEventListener(ComposerEvent.TRANSFORM_SCALE, onTransformScale);
			composeutils.removeEventListener(ComposerEvent.TRANSFORM_ROTATE, onTransformRotate);
			composeutils.removeEventListener(ComposerEvent.OBJECT_SELECTED, onObjectSelected);
			composeutils.removeEventListener(ComposerEvent.BACKGROUND_SELECTED, onBackgroundSelected);
			
			if (nativeAlert != null && !nativeAlert.disposed)
			nativeAlert.dispose();
			
			NativeApplication.nativeApplication.exit();
		}
		
		public function showInroScreen():void
		{
			composeutils.showIntroScreen();
		}
		
		/********************* Event handlers ****************************/
		
		private function onObjectToobarChange(e:ComposerEvent):void
		{
			var selected:int = parseInt(e.data.index);
			
			switch(selected)
			{
				case 0:
				facade.sendNotification(ApplicationFacade.FLIPHORIZONTAL);
				break;
				
				case 1:
				facade.sendNotification(ApplicationFacade.FLIPVERTICAL);
				break;
				
				case 2:
				facade.sendNotification(ApplicationFacade.DELETEITEM);
				break;
				
				case 3:
				facade.sendNotification(ApplicationFacade.LAYERFORWARD);
				break;
				
				case 4:
				facade.sendNotification(ApplicationFacade.LAYERBACKWARD);
				break;
				
				case 5:
				facade.sendNotification(ApplicationFacade.HIDEOBJECTTOOLBAR);
				break;
				
				case 6:
				facade.sendNotification(ApplicationFacade.LAYERTOP);
				break;
				
				case 7:
				facade.sendNotification(ApplicationFacade.LAYERBOTTOM);
				break;
				
				case 8:
				facade.sendNotification(ApplicationFacade.SCALEOBJECT);
				break;
				
				case 9:
				facade.sendNotification(ApplicationFacade.ROTATEOBJECT);
				break;
			}
		}
		
		private function onObjectToobarCancel(e:ComposerEvent):void
		{
			// NO OP
		}
		
		private function onExitDialogClose(event:NativeDialogEvent):void
		{
			var nativeAlert:NativeAlertDialog = event.target as NativeAlertDialog;
			nativeAlert.removeEventListener(NativeDialogEvent.CLOSED, onExitDialogClose);
			
			if (parseInt(event.index) == 0) {
				exitImmediately();
			}
			else if (parseInt(event.index) == 2){
				shareAppWithFriends();
			}			
			else {
				if (nativeAlert.disposed)
				nativeAlert = null;	
			}
			
		}
		
		
		private function shareAppWithFriends():void
		{
			var applicationURL:String = APPURL;
			var shareSubject:String = getResourceString(LocaleString.APPLICATION_TELL_FRIEND_SUBJECT);
			var shareContent:String = getResourceString(LocaleString.APPLICATION_TELL_FRIEND_CONTENT) + " \n\n" + applicationURL;
			var shareChooserTitle:String = getResourceString(LocaleString.APPLICATION_TELL_FRIEND_TITLE);
			AndroidExtensions.shareText(shareSubject, shareContent, shareChooserTitle);
		}
		
		private function onCompositionChange(e:ComposerEvent):void
		{
			var currentCompositionTimeStamp:Number = e.data.timestamp;
			
			if (currentCompositionTimeStamp - compositionTimestamp <= 1000)
			return;
			else
			compositionTimestamp = currentCompositionTimeStamp;
			
			var data:TextData = new TextData();
			data.color = uint(setCharAt(e.data.fontColor as String, "0x", 0));
			data.font = e.data.selectedFont;
			data.size = e.data.fontSize + FONT_SIZE_BOOST;
			data.text = e.data.message;
			
			writeDataStore("fontcolor", data.color);
			writeDataStore("fontname", data.font);
			writeDataStore("fontsize", data.size);
			
			if(data.text.length>0)
			facade.sendNotification(ApplicationFacade.ADDTEXT, data);
		}
		
		public function clearCache(code:String):void
		{
			composeutils.clearCache(code);
		}
		
		private function onCompositionFontChanged(e:ComposerEvent):void
		{
			var font:Object = getFontByName(e.data.selectedFont);
			facade.sendNotification(ApplicationFacade.LOADFONT, font);
		}
		
		private function onCompositionCancel(e:ComposerEvent):void
		{
			
		}
		
		private function onCompositionError(e:ComposerEvent):void
		{
			
		}
	}
}