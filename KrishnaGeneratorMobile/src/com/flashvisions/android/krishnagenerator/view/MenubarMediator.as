package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.Menubar;
	import com.flashvisions.android.krishnagenerator.view.components.Toolbar;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.desktop.NativeApplication;
	
	public class MenubarMediator extends Mediator implements IMediator
	{
		public static var VISIBLE:Boolean = true;
		public static const NAME:String = "MenubarMediator";
		private var menubar:Menubar;
		
		public function MenubarMediator(viewComponent:Object=null)
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
			return [ApplicationFacade.TOGGLEMENU, ApplicationFacade.HIDEMENU, ApplicationFacade.SHOWMENU];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.TOGGLEMENU:
				if (VISIBLE)
				facade.sendNotification(ApplicationFacade.HIDEMENU);
				else
				facade.sendNotification(ApplicationFacade.SHOWMENU);
				break;
				
				case ApplicationFacade.HIDEMENU:
				TweenLite.to(menubar, .5, { y:(menubar.stage.stageHeight+menubar.height), onComplete: menuHidden } );
				break;
				
				case ApplicationFacade.SHOWMENU:
				TweenLite.to(menubar, .5, { y:(menubar.stage.stageHeight-menubar.height-5), onComplete: menuVisible } );
				break;
			}
		}
		
		override public function onRegister():void 
		{
			menubar = this.viewComponent as Menubar;
			menubar.clear.addEventListener(MouseEvent.CLICK, onClear);
			menubar.save.addEventListener(MouseEvent.CLICK, onSave);
			menubar.share.addEventListener(MouseEvent.CLICK, onShare);
			menubar.quit.addEventListener(MouseEvent.CLICK, onQuit);
			
			facade.sendNotification(ApplicationFacade.HIDEMENU);
		}
		
		override public function onRemove():void 
		{
			menubar.clear.removeEventListener(MouseEvent.CLICK, onClear);
			menubar.save.removeEventListener(MouseEvent.CLICK, onSave);
			menubar.share.removeEventListener(MouseEvent.CLICK, onShare);
			menubar.quit.removeEventListener(MouseEvent.CLICK, onQuit);
		}
		
		private function onClear(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.CLEARALLITEMS);
		}
		
		private function onQuit(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.EXIT);
		}
		
		private function onShare(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SAVE,false);
		}
		
		private function onSave(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SAVE,true);
		}
		
		private function menuVisible():void
		{
			VISIBLE = true;
		}
		
		private function menuHidden():void
		{
			VISIBLE = false;
		}
		
	}
}