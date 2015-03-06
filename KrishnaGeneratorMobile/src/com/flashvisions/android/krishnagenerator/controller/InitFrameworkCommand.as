package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.model.*;
	import com.flashvisions.android.krishnagenerator.view.* ;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	public class InitFrameworkCommand extends AsyncCommand implements IAsyncCommand
	{
		public function InitFrameworkCommand()
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var application:Main = notification.getBody() as Main;
			var stage:Stage = application.stage as Stage;
						
			facade.registerProxy(new DataCentreProxy());
			
			facade.registerMediator(new ApplicationMediator(application));
			facade.registerMediator(new StageMediator(stage));
			
			commandComplete();
		}
	}
}