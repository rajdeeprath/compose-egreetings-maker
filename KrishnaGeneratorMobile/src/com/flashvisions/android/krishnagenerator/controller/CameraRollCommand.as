package com.flashvisions.android.krishnagenerator.controller
{
	import caurina.transitions.AuxFunctions;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.IDataInput;
	import ru.etcs.utils.FontLoader;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CameraRollCommand extends SimpleCommand implements ICommand
	{
		private var cameraRoll:CameraRoll;
		private var dataSource:IDataInput;
			
		public function CameraRollCommand()
		{
			super();
		}
		
				
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			if( CameraRoll.supportsBrowseForImage )
			{
				cameraRoll = new CameraRoll();	
				cameraRoll.addEventListener( MediaEvent.SELECT, imageSelected );
				cameraRoll.addEventListener( Event.CANCEL, browseCanceled );
				cameraRoll.addEventListener( ErrorEvent.ERROR, mediaError );
				cameraRoll.browseForImage();
			}
			else
			{
				trace( "Image browsing is not supported on this device.");
			} 
		}
		
		private function mediaError(e:ErrorEvent):void
		{
			releaseCameraRoll();
		}
		
		private function browseCanceled (e:Event):void
		{
			releaseCameraRoll();
		}
		
		private function imageSelected( event:MediaEvent ):void
		{
			releaseCameraRoll();
			facade.sendNotification(ApplicationFacade.ADDBACKGROUND,{url:event.data.file.url})
		}
		
		private function releaseCameraRoll():void
		{
			cameraRoll.removeEventListener( MediaEvent.SELECT, imageSelected );
			cameraRoll.removeEventListener( Event.CANCEL, browseCanceled );
			cameraRoll.removeEventListener( ErrorEvent.ERROR, mediaError );
			
			cameraRoll = null;
		}
	}
}