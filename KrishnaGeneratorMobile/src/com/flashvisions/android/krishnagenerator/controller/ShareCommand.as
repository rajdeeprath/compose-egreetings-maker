package com.flashvisions.android.krishnagenerator.controller
{
	import com.adobe.images.PNGEncoder;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.ApplicationMediator;
	import com.flashvisions.android.krishnagenerator.view.CanvasMediator;
	import com.flashvisions.android.krishnagenerator.view.components.Canvas;
	import com.ssd.ane.AndroidExtensions;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.net.Responder;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import com.adobe.images.JPGEncoder;
	import flash.utils.setTimeout;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShareCommand extends SimpleCommand implements ICommand
	{
		
		public function ShareCommand()
		{
			super();
		}
		
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var url:String = notification.getBody() as String;
			AndroidExtensions.shareImage(url, "Share your creativity");
		}
	}
}