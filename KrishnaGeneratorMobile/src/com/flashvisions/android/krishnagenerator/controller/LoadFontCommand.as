package com.flashvisions.android.krishnagenerator.controller
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import ru.etcs.utils.FontLoader;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadFontCommand extends SimpleCommand implements ICommand
	{
		private var font:Object = null;
		private var dataCentreProxy:DataCentreProxy;
		
		public function LoadFontCommand()
		{
			super();
		}
		
		public function result(re:Object):void
		{
			
		}
		
		public function fault(fe:Object):void
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			font = notification.getBody();
			dataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			if (!dataCentreProxy.isFontRegistered(font.name))
			loadFont(font);
			else 
			facade.sendNotification(ApplicationFacade.FONTUPDATE, font);
		}
		
		private function loadFont(font:Object):void
		{
			var fontloader:FontLoader = DataCentreProxy.getFontLoader();
			var fontPath:String = new String(dataCentreProxy.fontSWFPath + font.data);
			
			fontloader.addEventListener(Event.COMPLETE, onFontLoaded);
			fontloader.load(new URLRequest(fontPath));
		}
		
		private function onFontLoaded(e:Event):void
		{
			var fontloader:FontLoader = e.target as FontLoader;
			fontloader.removeEventListener(Event.COMPLETE, onFontLoaded);
			
			facade.sendNotification(ApplicationFacade.FONTUPDATE, font);
			dataCentreProxy.LoadedFonts.push(font.name);
			dataCentreProxy.writeDataStore("fontname", font.name);
		}
		

	}
}