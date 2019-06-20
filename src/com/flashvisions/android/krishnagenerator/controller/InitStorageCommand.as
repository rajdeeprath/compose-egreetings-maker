package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.model.*;
	import com.flashvisions.android.krishnagenerator.view.* ;
	import flash.filesystem.File;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	public class InitStorageCommand extends AsyncCommand implements IAsyncCommand
	{
		public function InitStorageCommand()
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var storageDirectory:File = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY);
			if (!storageDirectory.exists || !storageDirectory.isDirectory) storageDirectory.createDirectory();
			
			commandComplete();
		}
	}
}