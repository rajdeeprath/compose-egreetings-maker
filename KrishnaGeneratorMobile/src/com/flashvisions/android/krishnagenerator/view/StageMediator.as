package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class StageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "StageMediator";
		private var stage:Stage;
		private var splashScreen:SplashScreen;
		
		public function StageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IMediator */
		
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		override public function getViewComponent():Object 
		{
			return this.viewComponent;
		}
		
		override public function setViewComponent(viewComponent:Object):void 
		{
			this.viewComponent = viewComponent;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ApplicationFacade.CREATESPLASHSCREEN, ApplicationFacade.REMOVESPLASHSCREEN];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.CREATESPLASHSCREEN:
				createSplashScreen();
				break;
				
				case ApplicationFacade.REMOVESPLASHSCREEN:
				removeSplashScreen();
				break;
			}
		}
		
		override public function onRegister():void 
		{
			stage = this.viewComponent as Stage;
			facade.sendNotification(ApplicationFacade.CREATESPLASHSCREEN);
		}
		
		override public function onRemove():void 
		{
			
		}

		
		private function removeSplashScreen():void
		{
			stage.removeChild(splashScreen);
			splashScreen = null;
		}
		
		private function createSplashScreen():void
		{
			splashScreen = new SplashScreen();
			
			splashScreen.width = stage.stageWidth;
			splashScreen.height = stage.stageHeight;
						
			splashScreen.x = stage.stageWidth / 2;
			splashScreen.y = stage.stageHeight / 2;
			
			stage.addChild(splashScreen);
		}
		
		
	}
}