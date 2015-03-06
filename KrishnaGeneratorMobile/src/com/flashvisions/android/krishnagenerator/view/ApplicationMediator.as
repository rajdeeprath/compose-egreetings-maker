package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.locale.LocaleString;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.Canvas;
	import com.flashvisions.android.krishnagenerator.view.components.DrawingView;
	import com.flashvisions.android.krishnagenerator.view.components.IconButton;
	import com.flashvisions.android.krishnagenerator.view.components.Menubar;
	import com.flashvisions.android.krishnagenerator.view.components.PlayableItem;
	import com.flashvisions.android.krishnagenerator.view.components.Preloader;
	import com.flashvisions.android.krishnagenerator.view.components.TabletToolbar;
	import com.flashvisions.android.krishnagenerator.view.components.Toolbar;
	import com.flashvisions.android.krishnagenerator.vo.Category;
	import com.flashvisions.android.krishnagenerator.vo.TextData;
	import com.flashvisions.android.utils.AssetManager;
	import com.flashvisions.android.utils.MobileUtils;
	import com.greensock.TweenLite;
	import com.ssd.ane.AndroidExtensions;
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.events.ListItemEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.geom.Rectangle;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		private static const DEFAULT_BACKGROUND:String = "darkwood.jpg";
		private static var PADRIGHT:uint = 10;
		private static var PADTOP:uint = 10;
		private var decorHolder:MovieClip;
		private var decorList:TouchList;
		private var preloaderAnimation:Preloader;
		private var backgroundsHolder:MovieClip;
		private var backgroundsList:TouchList;
		
		private var pluginsHolder:MovieClip;
		private var pluginsList:TouchList;
		
		private var application:Main;
		
		private var modal:Sprite;
		private var dataCentreProxy:DataCentreProxy;
		
		private var currentlyLoadingItemSource:Object;
		
		private var drawingView:DrawingView;
		private var canvas:Canvas;
		private var defaultBackgroundURL:String;
		private var screenDPI:String = null;
		private var menuToggle:IconButton;
		
		public function ApplicationMediator(viewComponent:Object=null)
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
			return [ApplicationFacade.SHOWBACKGROUNDLIST, ApplicationFacade.SHOWOBJECTLIST, ApplicationFacade.SHOWDRAWINGVIEW, ApplicationFacade.CLOSEDRAWINGBOARD, ApplicationFacade.LOADINGDECORATIVEFAILED, ApplicationFacade.LOADINGDECORATIVECOMPLETE, ApplicationFacade.LOADINGDECORATIVE, ApplicationFacade.CATEGORYCHANGED, ApplicationFacade.NETWORKUNAVAILABLE, ApplicationFacade.NETWORKAVAILABLE, ApplicationFacade.EXIT, ApplicationFacade.SHOWOBJECTTOOLBAR,ApplicationFacade.LOADINGBACKGROUND, ApplicationFacade.LOADINGBACKGROUNDFAILED, ApplicationFacade.LOADINGBACKGROUNDCOMPLETE, ApplicationFacade.SAVESUCCESS,ApplicationFacade.SAVEFAILED,ApplicationFacade.SAVESTART,ApplicationFacade.HIDETEXTEDITOR,ApplicationFacade.SHOWTEXTEDITOR,ApplicationFacade.DECORATIVESUPDATE,ApplicationFacade.READY,ApplicationFacade.SHOWCATEGORIES];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.SHOWBACKGROUNDLIST:
				dataCentreProxy.showBackgroundsList();
				break;
				
				case ApplicationFacade.SHOWOBJECTLIST:
				dataCentreProxy.showObjectsList();
				break;
				
				case ApplicationFacade.CATEGORYCHANGED:
				ToastNotification(dataCentreProxy.getResourceString(LocaleString.CATEGORY_SELECT_TOAST) + notification.getBody() as  String);
				break;
				
				case ApplicationFacade.NETWORKUNAVAILABLE:
				ToastNotification(dataCentreProxy.getResourceString(LocaleString.CONNECTIVITY_ERROR_TOAST));
				break;
				
				case ApplicationFacade.NETWORKAVAILABLE:
				break;
				
				case ApplicationFacade.READY:
				initUI();
				break;
				
				case ApplicationFacade.SHOWCATEGORIES:
				break;
				
				case ApplicationFacade.SHOWTEXTEDITOR:
				var data:Object = notification.getBody();
				data = (data == null)?dataCentreProxy.getTextEditorData():data;
				dataCentreProxy.showTextEditor(data);
				break;
				
				case ApplicationFacade.LOADINGDECORATIVE:
				case ApplicationFacade.LOADINGBACKGROUND:
				case ApplicationFacade.SAVESTART:
				currentlyLoadingItemSource = notification.getBody();
				showPreloader();
				break;
				
				case ApplicationFacade.LOADINGDECORATIVECOMPLETE:
				case ApplicationFacade.LOADINGBACKGROUNDCOMPLETE:
				currentlyLoadingItemSource = null;
				hidePreloader();
				break;
				
				case ApplicationFacade.LOADINGDECORATIVEFAILED:
				case ApplicationFacade.LOADINGBACKGROUNDFAILED:
				case ApplicationFacade.SAVEFAILED:
				currentlyLoadingItemSource = null;
				hidePreloader();
				
				if(notification.getName() != ApplicationFacade.SAVEFAILED)
				ToastNotification(dataCentreProxy.getResourceString(LocaleString.OBJECT_LOAD_FAILED_TOAST));
				break;
				
				case ApplicationFacade.SAVESUCCESS:
				hidePreloader();
				
				if(notification.getBody())
				facade.sendNotification(ApplicationFacade.SHARE, notification.getBody());
				else
				ToastNotification(dataCentreProxy.getResourceString(LocaleString.SAVE_COMPLETE_TOAST));
				
				break;
				
				case ApplicationFacade.SHOWOBJECTTOOLBAR:
				showObjectToolbar();
				break;
								
				case ApplicationFacade.EXIT:
				exit();
				break;
								
				case ApplicationFacade.SHOWDRAWINGVIEW:
				showDrawingBoard();
				break;
				
				case ApplicationFacade.CLOSEDRAWINGBOARD:
				hideDrawingBoard();
				application.stage.focus = application;
				break;
			}
		}
		
		
		override public function onRegister():void 
		{
			application = this.viewComponent as Main;
			dataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			application.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function onActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function onDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function ToastNotification(msg:String, long:Boolean = false):void
		{
			AndroidExtensions.toast(msg, long);
		}
		
		private function initUI():void
		{
			var deviceType:String = MobileUtils.getDeviceType(application.stage, Capabilities.screenDPI);
			var requiresOnScreenMenuButton:Boolean = dataCentreProxy.requiresOnScreenMenuButton();
			var assetManager:AssetManager = AssetManager.getInstance();
			
			screenDPI = assetManager.sanitizeDPISTring(dataCentreProxy.getDeviceDPIString());
			canvas = new Canvas(application.stage.stageWidth, application.stage.stageHeight, 0xE38100);
			application.addChild(canvas);
			facade.registerMediator(new CanvasMediator(canvas));
			
			defaultBackgroundURL = File.applicationDirectory.resolvePath(DEFAULT_BACKGROUND).url;
			facade.sendNotification(ApplicationFacade.ADDBACKGROUND,{url:defaultBackgroundURL})
			
			switch(deviceType)
			{
				case MobileUtils.DEVICE_TYPE_PHONE:
				
				var toolbar:Toolbar = new Toolbar(screenDPI);
				application.addChild(toolbar);
				toolbar.x = application.stage.stageWidth / 2 - toolbar.width / 2;
				toolbar.y = application.stage.stageHeight - toolbar.height - 5;
				facade.registerMediator(new ToolbarMediator(toolbar));

				var menu:Menubar = new Menubar(screenDPI);
				application.addChild(menu);
				menu.x = application.stage.stageWidth / 2 - menu.width / 2;
				menu.y = application.stage.stageHeight - menu.height - 5;
				facade.registerMediator(new MenubarMediator(menu));
				
				/* check if device requires on screen menu button */
				if(requiresOnScreenMenuButton){
				var menuIconBitmap:Bitmap = assetManager.getMenuIcon(screenDPI);
				menuToggle = new IconButton(null, 0, 0, menuIconBitmap);
				menuToggle.addEventListener(MouseEvent.CLICK, toggleMenu);
				menuToggle.setSize(menuIconBitmap.width, menuIconBitmap.height);
				menuToggle.x = application.stage.stageWidth - menuToggle.width - PADRIGHT;
				menuToggle.y = 0 + PADTOP;
				application.addChild(menuToggle);
				}
				break;
				
				case MobileUtils.DEVICE_TYPE_TABLET:
				var tabtoolbar:TabletToolbar = new TabletToolbar(screenDPI);
				application.addChild(tabtoolbar);
				tabtoolbar.x = application.stage.stageWidth / 2 - tabtoolbar.width / 2;
				tabtoolbar.y = application.stage.stageHeight - tabtoolbar.height - 5;
				facade.registerMediator(new TabletToolbarMediator(tabtoolbar));
				break;
			}
			
			setTimeout(function ():void { 
			facade.sendNotification(ApplicationFacade.REMOVESPLASHSCREEN);
			if(!dataCentreProxy.wasIntroShownBefore())
			dataCentreProxy.showInroScreen();
			else if(dataCentreProxy.Instructions != null)
			dataCentreProxy.showChangeLog();
			}, 3000);
			
			
			/* Attempt to get latest app data */
			dataCentreProxy.buildCache();
		}
		
		override public function onRemove():void 
		{
			
		}
		
		
		private function showDrawingBoard():void
		{
			showModal();
			
			var dimension:uint = (application.stage.stageWidth < application.stage.stageHeight)?application.stage.stageWidth:application.stage.stageHeight;
			dimension = dimension - 120;
			drawingView = new DrawingView(dimension, dimension, screenDPI);
			drawingView.alpha = 0;
			application.addChild(drawingView);
			TweenLite.to(drawingView, .2, { alpha:1, onComplete : function onCompleteTween():void {
			facade.registerMediator(new DrawingViewMediator(drawingView));	
			}});
		}
		
		private function hideDrawingBoard():void
		{
			hideModal();
			
			facade.removeMediator(DrawingViewMediator.NAME);
			TweenLite.to(drawingView, .2, { alpha:0 , onComplete : function onCompleteTween():void {
			application.removeChild(drawingView);
			drawingView = null;
		}});
		}
		
		
		private function showModal():void
		{
			modal = new Sprite();
			modal.graphics.lineStyle(1, 0x000000, 1);
			modal.graphics.beginFill(0x000000, .6);
			modal.graphics.drawRect(0, 0, application.stage.stageWidth, application.stage.stageHeight);
			modal.graphics.endFill();
			modal.mouseChildren = false;
			application.addChild(modal);
		}
		
		private function hideModal():void
		{
			modal.graphics.clear();
			application.removeChild(modal);
			modal = null;
		}
		
		
		private function showPreloader():void
		{
			showModal();
			preloaderAnimation = new Preloader();
			preloaderAnimation.scaleX = preloaderAnimation.scaleY = 2;
			preloaderAnimation.x = application.stage.stageWidth / 2
			preloaderAnimation.y = application.stage.stageHeight / 2;
			application.addChild(preloaderAnimation);
		}
		
		private function hidePreloader():void
		{
			hideModal();
			application.removeChild(preloaderAnimation);
			preloaderAnimation = null;
		}
		
		private function showObjectToolbar():void
		{
			dataCentreProxy.showObjectToolbar();
		}			
		
		private function toggleMenu(event:MouseEvent = null):void
		{
			facade.sendNotification(ApplicationFacade.TOGGLEMENU);
		}
		
		private function cancelCurrentLoading():void
		{
			hidePreloader();
			currentlyLoadingItemSource.cancelLoad();
			currentlyLoadingItemSource = null;
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.BACK) 
			{
				event.preventDefault();
				
				if (currentlyLoadingItemSource != null) cancelCurrentLoading();
				else if (drawingView) facade.sendNotification(ApplicationFacade.DRAWINGQUITMODE);
				else if (preloaderAnimation) return;
				else exit();
			}
			else if (event.keyCode == Keyboard.MENU) 
			{
				event.preventDefault();
				
				if(MobileUtils.getDeviceType(application.stage, Capabilities.screenDPI) == MobileUtils.DEVICE_TYPE_PHONE)
				toggleMenu();
			}
		}
		
		
		public function exit():void
		{
			dataCentreProxy.exit();
		}
	}
}