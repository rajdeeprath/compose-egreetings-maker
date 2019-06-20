package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	public class StartupCompleteCommand extends AsyncCommand implements IAsyncCommand
	{
		public function StartupCompleteCommand()
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			facade.sendNotification(ApplicationFacade.READY);
			commandComplete();
		}
	}
}