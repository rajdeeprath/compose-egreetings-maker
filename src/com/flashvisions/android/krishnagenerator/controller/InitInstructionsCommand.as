package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.business.LoadCategoriesDelegate;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.vo.Category;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Responder;
		
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	public class InitInstructionsCommand extends AsyncCommand implements IAsyncCommand
	{
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var dataCentreProxy:DataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			var instructionsFile:File;
			var fileStream:FileStream;
			var instructionsString:String;
			var instructions:Object;
			
			try 
			{
				instructionsFile = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(DataCentreProxy.INSTRUCTIONS_FILE);
				
				fileStream = new FileStream(); fileStream.open(instructionsFile, FileMode.READ);
				instructionsString = fileStream.readUTFBytes(fileStream.bytesAvailable);
				instructions = JSON.parse(instructionsString);
				dataCentreProxy.Instructions = instructions;
				
				if(instructions.resetcode != null)
				dataCentreProxy.clearCache(instructions.resetcode);
			}
			catch (e:Error)
			{
				trace(e.message);
			}
			finally 
			{
				fileStream.close();
				fileStream = null;
				instructionsFile = null;
			}
			
			this.commandComplete();
		}
	}
}