package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.business.LoadCategoriesDelegate;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import ru.etcs.utils.FontLoader;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadCategoriesCommand extends SimpleCommand implements ICommand
	{
		public function result(re:Object):void
		{
			var dataCentreProxy:DataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			var categoriesString:String = re as String;
			
			if (categoriesString != null)
			dataCentreProxy.cacheContentToFile(categoriesString, File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(DataCentreProxy.CATEGORIES_FILE));
		}
		
		public function fault(fe:Object):void
		{
			// NO OP
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var loadInstructionsDelegate:LoadCategoriesDelegate = new LoadCategoriesDelegate(new Responder(result, fault));
			loadInstructionsDelegate.loadCategories();
		}		

		
	}
}