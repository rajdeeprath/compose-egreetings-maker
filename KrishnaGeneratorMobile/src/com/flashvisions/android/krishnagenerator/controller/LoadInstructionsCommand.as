package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.business.LoadCategoriesDelegate;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import ru.etcs.utils.FontLoader;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadInstructionsCommand extends SimpleCommand implements ICommand
	{
		public function result(re:Object):void
		{
			var dataCentreProxy:DataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			var instructionString:String = re as String;
			
			if (instructionString != null)
			dataCentreProxy.cacheContentToFile(instructionString, File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(DataCentreProxy.INSTRUCTIONS_FILE));
		}
		
		public function fault(fe:Object):void
		{
			// NO OP
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var loadInstructionsDelegate:LoadCategoriesDelegate = new LoadCategoriesDelegate(new Responder(result, fault));
			loadInstructionsDelegate.loadInstructions();
		}
	}
}