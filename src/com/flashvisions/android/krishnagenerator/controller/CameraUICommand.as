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
	
	public class CameraUICommand extends SimpleCommand implements ICommand
	{
		private var cameraUI:CameraUI;
		private var dataSource:IDataInput;
			
		public function CameraUICommand()
		{
			super();
		}
		
				
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			if( CameraUI.isSupported )
			{
				cameraUI = new CameraUI();
				cameraUI.addEventListener( MediaEvent.COMPLETE, imageSelected );
				cameraUI.addEventListener( ErrorEvent.ERROR, mediaError );
				cameraUI.launch( MediaType.IMAGE );
			}
			else
			{
				trace( "CameraUI is not supported.");
			}
		}
		
		private function mediaError(E:ErrorEvent):void
		{
			trace("AN ERROR OCCURED");
		}
		
		private function imageSelected( event:MediaEvent ):void
		{
			var result:Object = new Object();
			result.url = event.data.file.url;
			
			cameraUI.removeEventListener( MediaEvent.COMPLETE, imageSelected );
			cameraUI.removeEventListener( ErrorEvent.ERROR, mediaError );
			cameraUI = null;
			
			facade.sendNotification(ApplicationFacade.ADDBACKGROUND,result)
		}
		
		
	}
}