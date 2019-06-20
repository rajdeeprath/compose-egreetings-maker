package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.net.Responder;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ReadyCommand extends SimpleCommand implements ICommand
	{
		public function ReadyCommand()
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
	}
}