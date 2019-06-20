package com.flashvisions.android.krishnagenerator
{
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import com.flashvisions.android.krishnagenerator.controller.*;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const CHANGETRANSFORMTARGET:String  = "CHANGETRANSFORMTARGET";
		public static const ROTATE:String  = "ROTATE";
		public static const SCALE:String  = "SCALE";
		
		public static const ROTATEOBJECT:String  = "ROTATEOBJECT";
		public static const SCALEOBJECT:String  = "SCALEOBJECT";
		
		public static const BRUSHSETTINGSCHANGED:String  = "BRUSHSETTINGSCHANGED";
		public static const CANVASSETTINGSCHANGED:String  = "CANVASSETTINGSCHANGED";
		public static const ERASERSETTINGSCHANGED:String  = "ERASERSETTINGSCHANGED";
		
		public static const DRAWINGCANVASMODE:String  = "DRAWINGCANVASMODE";
		public static const DRAWINGBRUSHMODE:String  = "DRAWINGBRUSHMODE";
		public static const DRAWINGUNDOMODE:String  = "DRAWINGUNDOMODE";
		public static const DRAWINGQUITMODE:String  = "DRAWINGQUITMODE";
		public static const CLOSEDRAWINGBOARD:String  = "CLOSEDRAWINGBOARD";
		
		public static const CLOSEDRAWINGBOARDWITHSAVE:String  = "CLOSEDRAWINGBOARDWITHSAVE";
		public static const ADDDRAWINGTOCOMPOSITION:String  = "ADDDRAWINGTOCOMPOSITION";
		
		public static const CATEGORYCHANGED:String  = "CATEGORYCHANGED";
		
		public static const REMOVESPLASHSCREEN:String  = "REMOVESPLASHSCREEN";
		public static const CREATESPLASHSCREEN:String  = "CREATESPLASHSCREEN";
		
		public static const NETWORKAVAILABLE:String  = "NETWORKAVAILABLE";
		public static const NETWORKUNAVAILABLE:String  = "NETWORKUNAVAILABLE";
		
		public static const LAYERFORWARD:String  = "LAYERFORWARD";
		public static const LAYERBACKWARD:String  = "LAYERBACKWARD";
		public static const LAYERTOP:String  = "LAYERTOP";
		public static const LAYERBOTTOM:String  = "LAYERBOTTOM";
		
		public static const FLIPHORIZONTAL:String  = "FLIPHORIZONTAL";
		public static const FLIPVERTICAL:String  = "FLIPVERTICAL";
		
		public static const EXIT:String  = "PREVIOUSSTATE";
		
		public static const LOADFONT:String  = "LOADFONT";
		public static const FONTUPDATE:String  = "FONTUPDATE";
		
		public static const SHOWOBJECTTOOLBAR:String  = "SHOWOBJECTTOOLBAR";
		public static const HIDEOBJECTTOOLBAR:String  = "HIDEOBJECTTOOLBAR";
		
		public static const SHOWDRAWINGVIEW:String  = "SHOWDRAWINGVIEW";
		public static const HIDEDRAWINGVIEW:String  = "HIDEDRAWINGVIEW";
		
		public static const SHOWTEXTEDITOR:String  = "SHOWTEXTEDITOR";
		public static const HIDETEXTEDITOR:String  = "HIDETEXTEDITOR";
		
		public static const TOGGLEMENU:String  = "TOGGLEMENU";
		public static const SHOWMENU:String  = "SHOWMENU";
		public static const HIDEMENU:String  = "HIDEMENU";
		public static const SHOWTOOLS:String  = "SHOWTOOLS";
		public static const HIDETOOLS:String  = "HIDETOOLS";
		
		public static const SHOWBACKGROUNDLIST:String  = "SHOWBACKGROUNDLIST";
		public static const HIDEBACKGROUNDLIST:String  = "HIDEBACKGROUNDLIST";
		
		public static const SHOWOBJECTLIST:String  = "SHOWOBJECTLIST";
		public static const HIDEOBJECTLIST:String  = "HIDEOBJECTLIST";
		
		public static const SHOWCATEGORIES:String  = "SHOWCATEGORIES";
		public static const HIDECATEGORIES:String  = "HIDECATEGORIES";
		
		public static const LOADBACKGROUNDS:String  = "LOADBACKGROUNDS";
		public static const BACKGROUNDSUPDATE:String  = "BACKGROUNDSUPDATE";
		
		public static const LOADFONTS:String  = "LOADFONTS";
		public static const FONTSUPDATE:String  = "FONTSUPDATE";
		
		public static const TRANSFORMTOOLINIT:String  = "TRANSFORMTOOLINIT";
		public static const ADDDECORATIVE:String  = "ADDDECORATIVE";
		
		public static const LOADINGPLUGINS:String  = "LOADING PLUGINS";
		public static const LOADINGFRAMES:String  = "LOADING FRAMES";
		public static const LOADINGBACKGROUNDS:String  = "LOADING BACKGROUNDS";
		public static const LOADINGSOUNDS:String  = "LOADING SOUNDS";
		public static const LOADINGFONTS:String  = "LOADING FONTS";
		public static const LOADINGCATEGORIES:String  = "LOADING CATEGORIES";
		public static const LOADINGDECORATIVES:String  = "LOADING DECORATIVES";
		public static const LOADINGBACKGROUNDSCOMPLETE:String  = "LOADINGBACKGROUNDSCOMPLETE";
		public static const LOADINGDECORATIVESCOMPLETE:String  = "LOADING DECORATIVES COMPLETE";
		public static const LOADINGDECORATIVESFAILED:String  = "LOADING DECORATIVES FAILED";
		public static const LOADINGSOUND:String  = "LOADING SOUND";
		public static const LOADINGSOUNDCOMPLETE:String  = "LOADING SOUND COMPLETE";
		public static const LOADINGSOUNDFAILED:String  = "LOADING SOUND FAILED";
		
		public static const LOADINGBACKGROUND:String  = "LOADINGBACKGROUND";
		public static const LOADINGBACKGROUNDCOMPLETE:String  = "LOADINGBACKGROUNDCOMPLETE";
		public static const LOADINGBACKGROUNDFAILED:String  = "LOADINGBACKGROUNDFAILED";
		
		public static const LOADINGDECORATIVE:String  = "LOADINGDECORATIVE";
		public static const LOADINGDECORATIVECOMPLETE:String  = "LOADINGDECORATIVECOMPLETE";
		public static const LOADINGDECORATIVEFAILED:String  = "LOADINGDECORATIVEFAILED";
		
		public static const STARTUP:String  = "STARTING";
		public static const READY:String  = "READY";
		public static const FAULT:String  = "FAULT";
		public static const LOADDECORATIVES:String  = "LOADDECORATIVES";
		public static const DECORATIVESUPDATE:String  = "DECORATIVESUPDATE";
		
		public static const LOADINGLANGUAGE:String  = "INITIALIZING LANGUAGE";
		public static const LANGUAGECHANGED:String  = "LANGUAGECHANGED";
		public static const CHANGELANGUAGE:String  = "CHANGELANGUAGE";
		
		public static const CAMERAROLL:String  = "CAMERAROLL";
		
		public static const SHARE:String  = "SHARE";
		public static const SAVE:String  = "SAVE";
		public static const SAVESTART:String  = "SAVESTART";
		public static const SAVESUCCESS:String  = "SAVESUCCESS";
		public static const SAVEFAILED:String  = "SAVEFAILED";
		public static const CAMERAROLLSAVESUCCESS:String  = "CAMERAROLLSAVESUCCESS";
		public static const CAMERAROLLSAVEFAILED:String  = "CAMERAROLLSAVEFAILED";
		public static const GENERATEBLING:String  = "GENERATEBLING";
		public static const CLEARALLITEMS:String  = "CLEARALLITEMS";
		public static const WORKSPACECLEAN:String  = "WORKSPACECLEAN";
		public static const WORKSPACEDIRTY:String  = "WORKSPACEDIRTY";
		public static const NEWBLING:String  = "NEWBLING";
		public static const TEXTSELECTED:String  = "TEXTSELECTED";
		public static const FONTLOADED:String  = "FONTLOADED";
		public static const FONTCHANGE:String  = "FONTCHANGE";
		public static const FONTSIZECHANGE:String  = "FONTSIZECHANGE";
		public static const FONTCOLORCHANGE:String  = "FONTCOLORCHANGE";
		public static const CANCELTEXTEDIT:String  = "CANCELTEXTEDIT";
		public static const ADDTEXT:String  = "ADDTEXT";
		public static const REMOVETEXT:String  = "REMOVETEXT";
		public static const ADDITEM:String  = "ADDITEM";
		public static const DELETEITEM:String  = "DELETEITEM";
		public static const ADDSOUND:String  = "ADDSOUND";
		public static const REMOVESOUND:String  = "REMOVESOUND";
		public static const ADDPLUGIN:String  = "ADDPLUGIN";
		public static const REMOVEPLUGIN:String  = "REMOVEPLUGIN";
		public static const ADDFRAME:String  = "ADDFRAME";
		public static const REMOVEFRAME:String  = "REMOVEFRAME";
		public static const IMAGEMODULE:String  = "IMAGEMODULE";
		public static const ADDBACKGROUND:String  = "ADDBACKGROUND";
		public static const REMOVEBACKGROUND:String  = "REMOVEBACKGROUND";
		public static const BACKGROUNDCOLOR:String  = "BACKGROUNDCOLOR";
		public static const DIMENSIONCHANGE:String  = "DIMENSIONCHANGE";
		
		public static const CACHECATEGORIES:String  = "CACHECATEGORIES";
		public static const CACHEINSTRUCTIONS:String  = "CACHEINSTRUCTIONS";
		
		
		public function ApplicationFacade()
		{
			super();
		}
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		
		/**
		 * Register Commands with the Controller 
		 */
		
		override protected function initializeController( ) : void 
		{
			super.initializeController();
			
			this.registerCommand(STARTUP,StartupCommand);
			this.registerCommand(READY, ReadyCommand);
			this.registerCommand(LOADFONT,LoadFontCommand)
			this.registerCommand(CAMERAROLL,CameraRollCommand)
			this.registerCommand(SAVE,SaveCommand)
			this.registerCommand(SHARE,ShareCommand)
			this.registerCommand(CACHECATEGORIES,LoadCategoriesCommand)
			this.registerCommand(CACHEINSTRUCTIONS,LoadInstructionsCommand)
		}
		
		
		public function startup( application:Object ):void
		{
			sendNotification( STARTUP, application);
		}
	}
}