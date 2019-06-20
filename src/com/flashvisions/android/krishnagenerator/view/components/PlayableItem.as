package com.flashvisions.android.krishnagenerator.view.components 
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class PlayableItem extends Sprite
	{
		private var __contentURL:String;
		private var __loader:Loader;
		protected var __preloader:Preloader;
		
		
		public function PlayableItem(url:String = null) 
		{
			if (url) {
				contentUrl = url;
				
				try{
					__loader = new Loader();
					__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemLoaded);
					__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
					__loader.load(new URLRequest(url));
					
					ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGDECORATIVE,  this)
				}catch (e:Error) {
					trace(e.message);
				}
			}
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			
			centerOnParent();
		}
		
		
		public function get contentUrl():String
		{
			return __contentURL;
		}
		public function set contentUrl(url:String):void
		{
			__contentURL = url;
		}
		
		
		public function centerOnParent():void
		{
			this.x = this.parent.width / 2;
			this.y = this.parent.height / 2;
		}
		
	
		/* Event Handlers */
		
		protected function onItemLoaded(e:Event):void {
			
			if(__loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onItemLoaded);
			
			if(__loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			__loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			this.addChild(__loader);
			
			__loader.x = -(__loader.width / 2);
			__loader.y = -(__loader.height / 2);
			
			centerOnParent();
			
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGDECORATIVECOMPLETE,  this)
		}
		
		
		protected function onLoadError(e:IOErrorEvent):void
		{
			if(__loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onItemLoaded);
			
			if(__loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			__loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			__loader = null;
			
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGDECORATIVEFAILED,  this)
		}
		
		public function cancelLoad():void
		{
			if(__loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onItemLoaded);
			
			if(__loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			__loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			try{
			__loader.close();
			}catch (e:Error) {
				trace(e.message);
			}finally {
				__loader = null;
			}
		}
		
	}
	
}