package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.TabletToolbar;
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
	
	public class TabletToolbarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TabletToolbarMediator";
		private var toolbar:TabletToolbar;
		
		public function TabletToolbarMediator(viewComponent:Object=null)
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
				TweenLite.to(toolbar, 1, { y:(toolbar.stage.stageHeight-toolbar.height-5) } );
				break;
				
				case ApplicationFacade.SHOWMENU:
				TweenLite.to(toolbar, 1, { y:(toolbar.stage.stageHeight+toolbar.height-5) } );
				break;
			}
		}
		
		override public function onRegister():void 
		{
			toolbar = this.viewComponent as TabletToolbar;
			toolbar.decoratons.addEventListener(MouseEvent.CLICK, onShowDecoratives);
			toolbar.backgrounds.addEventListener(MouseEvent.CLICK, onShowBackgrounds)
			toolbar.text.addEventListener(MouseEvent.CLICK, onShowTextEditor)
			toolbar.draw.addEventListener(MouseEvent.CLICK, onShowDrawingView);
			
			if(toolbar.gallery)
			toolbar.gallery.addEventListener(MouseEvent.CLICK, onCamera)
			
			toolbar.clear.addEventListener(MouseEvent.CLICK, onClear);
			toolbar.save.addEventListener(MouseEvent.CLICK, onSave);
			toolbar.share.addEventListener(MouseEvent.CLICK, onShare);
			toolbar.quit.addEventListener(MouseEvent.CLICK, onQuit);
		}
		
		override public function onRemove():void 
		{
			toolbar.decoratons.removeEventListener(MouseEvent.CLICK, onShowDecoratives);
			toolbar.backgrounds.removeEventListener(MouseEvent.CLICK, onShowBackgrounds)
			toolbar.text.removeEventListener(MouseEvent.CLICK, onShowTextEditor)
			toolbar.gallery.removeEventListener(MouseEvent.CLICK, onCamera)
			toolbar.draw.removeEventListener(MouseEvent.CLICK, onShowDrawingView);
						
			toolbar.clear.removeEventListener(MouseEvent.CLICK, onClear);
			toolbar.save.removeEventListener(MouseEvent.CLICK, onSave);
			toolbar.share.removeEventListener(MouseEvent.CLICK, onShare);
			toolbar.quit.removeEventListener(MouseEvent.CLICK, onQuit);
			
		}
		
		
		private function onShowDecoratives(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWOBJECTLIST);
		}
		
		private function onShowBackgrounds(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWBACKGROUNDLIST);
		}
		
		private function onShowTextEditor(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWTEXTEDITOR);
		}
		
		private function onShowDrawingView(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.SHOWDRAWINGVIEW);
		}
				
		private function onCamera(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.CAMERAROLL);
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
	}
}