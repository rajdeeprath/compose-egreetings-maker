package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.Toolbar;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.CameraRoll;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.desktop.NativeApplication;
	
	public class ToolbarMediator extends Mediator implements IMediator
	{
		public static var VISIBLE:Boolean = true;
		public static const NAME:String = "ToolbarMediator";
		private var toolbar:Toolbar;
		
		public function ToolbarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IMediator */
		
		
		override public function getMediatorName():String 
		{
			return NAME;
		}
		
		override public function getViewComponent():Object 
		{
			return this.viewComponent;
		}
		
		override public function setViewComponent(viewComponent:Object):void 
		{
			this.viewComponent = viewComponent;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ApplicationFacade.HIDEMENU, ApplicationFacade.SHOWMENU];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.HIDEMENU:
				TweenLite.to(toolbar, .5, { y:(toolbar.stage.stageHeight-toolbar.height-5), onComplete: toolsVisible } );
				break;
				
				case ApplicationFacade.SHOWMENU:
				TweenLite.to(toolbar, .5, { y:(toolbar.stage.stageHeight+toolbar.height), onComplete: toolsHidden } );
				break;
			}
		}
		
		override public function onRegister():void 
		{
			toolbar = this.viewComponent as Toolbar;
			toolbar.decoratons.addEventListener(MouseEvent.CLICK, onShowDecoratives);
			toolbar.backgrounds.addEventListener(MouseEvent.CLICK, onShowBackgrounds)
			toolbar.gallery.addEventListener(MouseEvent.CLICK, onGalleryBackgrounds)
			toolbar.text.addEventListener(MouseEvent.CLICK, onShowTextEditor)
			toolbar.draw.addEventListener(MouseEvent.CLICK, onShowDrawingView);
		}
		
		override public function onRemove():void 
		{
			toolbar.decoratons.removeEventListener(MouseEvent.CLICK, onShowDecoratives);
			toolbar.backgrounds.removeEventListener(MouseEvent.CLICK, onShowBackgrounds)
			toolbar.gallery.removeEventListener(MouseEvent.CLICK, onGalleryBackgrounds)
			toolbar.text.removeEventListener(MouseEvent.CLICK, onShowTextEditor)
			toolbar.draw.removeEventListener(MouseEvent.CLICK, onShowDrawingView);
		}
		
		private function onShowDrawingView(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWDRAWINGVIEW);
		}
		
		private function onShowDecoratives(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWOBJECTLIST);
		}
		
		private function onShowBackgrounds(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWBACKGROUNDLIST);
		}
		
		
		private function onGalleryBackgrounds(e:MouseEvent):void
		{
			if (CameraRoll.supportsBrowseForImage)
			facade.sendNotification(ApplicationFacade.CAMERAROLL);
		}
		
		private function onShowTextEditor(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWTEXTEDITOR);
		}
		
		private function toolsVisible():void
		{
			VISIBLE = true;
		}
		
		private function toolsHidden():void
		{
			VISIBLE = false;
		}
	}
}