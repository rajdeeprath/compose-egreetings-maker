package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Responder;
	import flash.system.System;
	import flash.utils.getTimer;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitFontsCommand extends AsyncCommand implements IAsyncCommand
	{
		private var responder:Responder;
		
		public function InitFontsCommand()
		{
			super();
		}
		
		
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var dataCentreProxy:DataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			var settingsFile:File;
			var fileStream:FileStream;
			var settings:XML;
			var fontNodes:XMLList;
			var previewPath:String;
			var mainPath:String;
			var fonts:Array = new Array();
			
			try
			{
				settingsFile = File.applicationDirectory.resolvePath(DataCentreProxy.FONTS_FILE);
				fileStream = new FileStream(); fileStream.open(settingsFile, FileMode.READ);
				settings = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fontNodes = settings.font;
				mainPath = settings.@mainpath;
				previewPath = settings.@previewpath;
			
				for (var i:int = 0; i < fontNodes.length(); i++) 
				{
					var font:Object = new Object();
					font.name = fontNodes[i].@name;
					font.preview = fontNodes[i].@preview;
					font.data = fontNodes[i].@data;
					fonts.push(font);
				}
				
				dataCentreProxy.fontSWFPath = mainPath;
				dataCentreProxy.fontPreviewPath = previewPath;
				dataCentreProxy.Fonts = fonts;
			}
			catch (e:Error)
			{
				trace(e.message);
			}
			finally 
			{
				fileStream.close();
				fileStream = null;
				settingsFile = null;
				
				System.disposeXML(settings);
				settings = null;
			}
			
			
			commandComplete();
		}
	}
}