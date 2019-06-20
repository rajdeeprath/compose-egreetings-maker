package com.flashvisions.android.krishnagenerator.controller
{
	import air.net.URLMonitor;
	import com.flashvisions.android.krishnagenerator.model.*;
	import com.flashvisions.android.krishnagenerator.view.* ;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	public class CheckConnectionCommand extends AsyncCommand implements IAsyncCommand
	{
		private var monitor:URLMonitor;
		private var datacenterProxy:DataCentreProxy;
		private var connected:Boolean;
		private var serviceChecker:URLLoader;
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			datacenterProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			connected = datacenterProxy.isNetworkConnected();
			
			if (!connected) {
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
			datacenterProxy.hasNetwork = false;
			}
			else { 
			checkServiceStatus();
			}
			
			this.commandComplete();
		}
		
		private function serviceOffline():void
		{
			datacenterProxy.hasNetwork = false;
		}
		
		private function serviceOnline():void
		{
			if (NativeApplication.nativeApplication.hasEventListener(Event.NETWORK_CHANGE))
			NativeApplication.nativeApplication.removeEventListener(Event.NETWORK_CHANGE, onNetworkChange);
			
			if (monitor)
			deInitServiceMonitor();
			
			if (serviceChecker)
			deInitServiceChecker();
			
			datacenterProxy.hasNetwork = true;
		}
		
		private function checkServiceStatus():void
		{
			if (!serviceChecker)
			initServiceChecker();
			
			var request:URLRequest = new URLRequest();
			request.url = DataCentreProxy.GATEWAY;
			request.method = URLRequestMethod.HEAD;
			request.idleTimeout = 5000;
			request.followRedirects = false;
			
			serviceChecker.load(request);
		}
		
		private function initServiceChecker():void
		{
			serviceChecker = new URLLoader();
			serviceChecker.addEventListener(Event.COMPLETE, onCheckComplete);
			serviceChecker.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPResponseStatus);
			serviceChecker.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			serviceChecker.addEventListener(IOErrorEvent.IO_ERROR, onServiceError);
		}
		
		private function deInitServiceChecker():void
		{
			serviceChecker.removeEventListener(Event.COMPLETE, onCheckComplete);
			serviceChecker.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPResponseStatus);
			serviceChecker.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			serviceChecker.removeEventListener(IOErrorEvent.IO_ERROR, onServiceError);
			serviceChecker = null;
		}
		
		private function initServiceMonitor():void
		{
			monitor = new URLMonitor(new URLRequest(DataCentreProxy.GATEWAY));
			monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
			monitor.pollInterval = 3000;
		}
		
		private function deInitServiceMonitor():void
		{
			monitor.removeEventListener(StatusEvent.STATUS, netConnectivity);
			monitor = null;
		}
		
		private function onNetworkChange(e:Event = null):void
		{
			if (!monitor) initServiceMonitor();
            monitor.start();
		}
		
		private function onCheckComplete(e:Event):void
		{
			deInitServiceChecker();
			serviceOnline();
		}
		
		private function onHTTPResponseStatus(e:HTTPStatusEvent):void
		{
				trace("onHTTPResponseStatus "+e.status);
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void
		{
				trace("onHTTPStatus "+e.status);
		}
		
		private function onServiceError(e:IOErrorEvent):void
		{
			deInitServiceChecker();
			serviceOffline();
		}
		
		protected function netConnectivity(e:StatusEvent):void 
        {
            if(monitor.available)
            {
				deInitServiceMonitor();
                serviceOnline();
            }
            else
            {
               checkServiceStatus();
            }
			
        }
	}
}