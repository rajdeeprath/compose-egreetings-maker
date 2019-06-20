package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.ObjectList;
	import com.greensock.TweenLite;
	import com.thanksmister.touchlist.events.ListItemEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BackgroundListMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BackgroundListMediator";
		private var objectList:ObjectList;
		private var dataCentreProxy:DataCentreProxy;
		
		public function BackgroundListMediator(viewComponent:Object=null)
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
			return [ApplicationFacade.HIDEBACKGROUNDLIST,ApplicationFacade.SHOWBACKGROUNDLIST,ApplicationFacade.SHOWOBJECTLIST, ApplicationFacade.HIDEOBJECTLIST,ApplicationFacade.LOADINGBACKGROUNDSCOMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.HIDEBACKGROUNDLIST:	
				case ApplicationFacade.SHOWOBJECTLIST:
					
				TweenLite.to(objectList, 1, { x: -80 } );
				
				break;
				
				case ApplicationFacade.SHOWBACKGROUNDLIST:
				dataCentreProxy.mode = DataCentreProxy.BACKGROUNDS;
				
				if (dataCentreProxy.CurrentBackgroundCategoryID != dataCentreProxy.CurrentCategory.id)
				facade.sendNotification(ApplicationFacade.LOADBACKGROUNDS);
				
				TweenLite.to(objectList, 1, { x:0 } );
				break;
				
				
				case ApplicationFacade.LOADINGBACKGROUNDSCOMPLETE:
				var backgrounds:Array = dataCentreProxy.Backgrounds as Array;
				objectList.addItems(backgrounds);
				break;
			}
		}
		
		override public function onRegister():void 
		{
			objectList = this.viewComponent as ObjectList;
			objectList.categoySelector.addEventListener(MouseEvent.CLICK, onClick);
			objectList.list.addEventListener(ListItemEvent.ITEM_SELECTED, handlelistItemSelected);
			
			dataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			facade.sendNotification(ApplicationFacade.HIDEBACKGROUNDLIST)
		}
		
		override public function onRemove():void 
		{
			
		}
		
		
		private function onClick(e:Event):void
		{
			facade.sendNotification(ApplicationFacade.SHOWCATEGORIES);
		}
		
		/**
		 * Handle list item seleced.
		 * */
		private function handlelistItemSelected(e:ListItemEvent):void
		{
			trace("List item selected: " + e.renderer.index);
			facade.sendNotification(ApplicationFacade.ADDBACKGROUND, e.renderer.data);
		}
	}
}