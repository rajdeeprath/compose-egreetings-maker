package com.flashvisions.android.krishnagenerator.controller
{
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.ComboBox;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.ApplicationMediator;
	import com.flashvisions.android.krishnagenerator.view.CanvasMediator;
	import com.flashvisions.android.krishnagenerator.view.components.Canvas;
	import com.flashvisions.mobile.android.extensions.compose.ComposeUtils;
	import com.flashvisions.mobile.android.extensions.compose.event.ComposerEvent;
	import com.ssd.ane.AndroidExtensions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.net.Responder;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import sk.yoz.math.ResizeMath;
	import sk.yoz.image.ImageResizer;
	
	public class SaveCommand extends SimpleCommand implements ICommand
	{
		private static const TMPFILE:String = "creation";
		private static const EXTENSION:String = ".jpg";
		
		private var bmp:BitmapData;
		private var filename:String;
		
		private var composeutils:ComposeUtils = ComposeUtils.getInstance();
		private var addToCameraRoll:Boolean = false;
		
		public function SaveCommand()
		{
			super();
		}
		
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var oldFile:File = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(TMPFILE + EXTENSION);
			addToCameraRoll = notification.getBody() as Boolean;
			
			if (oldFile.exists){
			oldFile.addEventListener(Event.COMPLETE, deleteCompleteHandler, false, 0, true) ;
			oldFile.addEventListener(IOErrorEvent.IO_ERROR, deleteIOErrorEventHandler, false, 0, true); 
			oldFile.deleteFileAsync();
			}else {
			deleteCompleteHandler();
			}
		}
		
		private function deleteIOErrorEventHandler(e:IOErrorEvent):void 
		{
			e.target == null;
			startSaveOperation();
		}
		
		private function deleteCompleteHandler(e:Event=null):void
		{
			if (e != null)
			e.target == null;
			
			startSaveOperation();
		}
		
		private function startSaveOperation():void
		{
			if (addToCameraRoll)
			{
				facade.sendNotification(ApplicationFacade.SAVESTART);
				setTimeout(saveToCameraRoll, 1000);
			}
			else
			{
				facade.sendNotification(ApplicationFacade.SAVESTART);
				setTimeout(save, 1000);
			}
		}
		
		private function onAddComplete(e:Event):void
		{
			var cameraRoll:CameraRoll = e.target as CameraRoll;
			cameraRoll.removeEventListener(Event.COMPLETE, onAddComplete);
			cameraRoll.removeEventListener(ErrorEvent.ERROR, onAddError);
			
			try{
				bmp.dispose();
			}catch (e:Error) {
				trace(e.message);
			}finally {
				bmp = null;
			}
			
			facade.sendNotification(ApplicationFacade.SAVESUCCESS);
		}
		
		private function onAddError(e:Event):void
		{
			var cameraRoll:CameraRoll = e.target as CameraRoll;
			cameraRoll.removeEventListener(Event.COMPLETE, onAddComplete);
			cameraRoll.removeEventListener(ErrorEvent.ERROR, onAddError);	
			
			try{
				bmp.dispose();
			}catch (e:Error) {
				trace(e.message);
			}finally {
				bmp = null;
			}
			
			facade.sendNotification(ApplicationFacade.SAVEFAILED);
		}
		
		private function saveToCameraRoll():void
		{
			var cameraRoll:CameraRoll = new CameraRoll();
			var canvasMediator:CanvasMediator = facade.retrieveMediator(CanvasMediator.NAME) as CanvasMediator;
			var canvas:Canvas = canvasMediator.getViewComponent() as Canvas;
				
			if (CameraRoll.supportsAddBitmapData)
			{
				bmp = new BitmapData(canvas.stage.stageWidth, canvas.stage.stageHeight);
				bmp.draw(canvas);
				bmp = ImageResizer.bilinearIterative(bmp, 800, 480, ResizeMath.METHOD_PAN_AND_SCAN);
				
				/*
				cameraRoll.addEventListener(Event.COMPLETE, onAddComplete);
				cameraRoll.addEventListener(ErrorEvent.ERROR, onAddError);
				cameraRoll.addBitmapData(bmp);
				*/
				
				if(!composeutils.hasEventListener(ComposerEvent.IMAGESAVECOMPLETE))
				composeutils.addEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSavedToGallery);
				if(!composeutils.hasEventListener(ComposerEvent.IMAGESAVEIOERROR))
				composeutils.addEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailedToSaveToGallery);
				composeutils.saveBitmapToCameraRoll(bmp, TMPFILE + new Date().getTime(), 100);
			}

		}
		
		private function save():void
		{
			var canvasMediator:CanvasMediator = facade.retrieveMediator(CanvasMediator.NAME) as CanvasMediator;
			var canvas:Canvas = canvasMediator.getViewComponent() as Canvas;
			var ba:ByteArray;
			var image:File;
			var fs:FileStream;
			
			var imagePath:String = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).nativePath + "/";
			
			
			try
			{
				bmp = new BitmapData(canvas.stage.stageWidth, canvas.stage.stageHeight);
				bmp.draw(canvas); 
				bmp = ImageResizer.bilinearIterative(bmp, 800, 480, ResizeMath.METHOD_PAN_AND_SCAN);
				
				composeutils.addEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSaved);
				composeutils.addEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailed);
				composeutils.saveBitmapAsJPEG(bmp, TMPFILE, imagePath, 100);								
			}
			catch (e:Error) 
			{
				onFailed();
			}
		}
		
		private function onSaved(e:ComposerEvent =null):void
		{
			composeutils.removeEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSaved);
			composeutils.removeEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailed);
			
			var imagePath:String = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(TMPFILE + EXTENSION).nativePath;
			facade.sendNotification(ApplicationFacade.SAVESUCCESS, imagePath);
		}

		private function onFailed(e:ComposerEvent = null):void
		{
			composeutils.removeEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSaved);
			composeutils.removeEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailed);
			
			facade.sendNotification(ApplicationFacade.SAVEFAILED);
		}
		
		private function onSavedToGallery(e:ComposerEvent =null):void
		{
			composeutils.removeEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSavedToGallery);
			composeutils.removeEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailedToSaveToGallery);
			
			try{
				bmp.dispose();
			}catch (e:Error) {
				trace(e.message);
			}finally {
				bmp = null;
			}
			
			facade.sendNotification(ApplicationFacade.SAVESUCCESS);
		}

		private function onFailedToSaveToGallery(e:ComposerEvent = null):void
		{
			composeutils.removeEventListener(ComposerEvent.IMAGESAVECOMPLETE, onSavedToGallery);
			composeutils.removeEventListener(ComposerEvent.IMAGESAVEIOERROR, onFailedToSaveToGallery);
			
			try{
				bmp.dispose();
			}catch (e:Error) {
				trace(e.message);
			}finally {
				bmp = null;
			}
			
			facade.sendNotification(ApplicationFacade.SAVEFAILED);
		}
	}
}