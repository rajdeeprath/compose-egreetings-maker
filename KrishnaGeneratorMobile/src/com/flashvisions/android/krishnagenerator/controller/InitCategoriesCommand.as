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
	
	public class InitCategoriesCommand extends AsyncCommand implements IAsyncCommand
	{
		private var responder:Responder;
		private var dataCentreProxy:DataCentreProxy;
		
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var dataCentreProxy:DataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			var categoriesFile:File;
			var categoriesCacheFile:File;
			var categoriesDefaultFile:File;
			var fileStream:FileStream;
			var categoriesContent:String;
			var categories:Array = null;
			
			try 
			{
				categoriesDefaultFile = File.applicationDirectory.resolvePath(DataCentreProxy.CATEGORIES_FILE);
				categoriesCacheFile = File.documentsDirectory.resolvePath(DataCentreProxy.STORAGE_DIRECTORY).resolvePath(DataCentreProxy.CATEGORIES_FILE);
				categoriesFile = (categoriesCacheFile.exists)?categoriesCacheFile:categoriesDefaultFile;
						
				fileStream = new FileStream(); fileStream.open(categoriesFile, FileMode.READ);
				categoriesContent = fileStream.readUTFBytes(fileStream.bytesAvailable);
				categories = JSON.parse(categoriesContent) as Array;
				categories.unshift( { id:0, label:"All" } );
				dataCentreProxy.Categories = categories;
				
				if(categories.length>0)
				dataCentreProxy.CurrentCategory = new Category(categories[0].id, categories[0].label);
			}
			catch (e:Error)
			{
				trace(e.message);
			}
			finally 
			{
				fileStream.close();
				fileStream = null;
				categoriesFile = null;
			}
			
			this.commandComplete();
		}
	}
}