package com.flashvisions.android.krishnagenerator.view.components 
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import sk.yoz.image.ImageResizer;
	import sk.yoz.math.ResizeMath;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class CanvasBackground extends MovieClip 
	{
		private static var backgroundLoader:Loader;
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		private var _bmp:Bitmap;
		
		
		public function setColor(color:uint):void
		{
			_color = color;
			draw();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			draw();
		}
		
		public function setWidth(w:Number):void
		{
			_width = w;
			draw();
		}
		
		public function setHeight(h:Number):void
		{
			_height = h;
			draw();
		}
		
		public function get Background():Bitmap
		{
			return _bmp;
		}
		
		public function set Background(bmp:Bitmap):void
		{
			_bmp = bmp;
			draw();
		}
		
		public function CanvasBackground(width:Number, height:Number, color:uint = 0xffffff, bmp:Bitmap = null) 
		{
			_width = width;
			_height = height;
			_color =  color;
			_bmp = bmp;
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAvailable);
		}
		
		
		protected function onStageResize(e:Event):void
		{
			draw();
		}
		
		protected function onStageAvailable(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageAvailable);
			addEventListener(Event.RESIZE, onStageResize);
			draw();
		}
		
		
		protected function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0, 0, 0);
			
			if (_bmp) 
			{
				this.graphics.beginBitmapFill(_bmp.bitmapData);
			}
			else 
			{
				this.graphics.beginFill(_color, 1);
			}
			
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		
		public function setBackgroundFromURL(url:String):void
		{
			try
			{
				initBackgroundLoader();
				backgroundLoader.load(new URLRequest(url))
				ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGBACKGROUND, this);
			}
			catch (e1:Error) 
			{
				trace(e1.message);
				try{
				deInitBackgroundLoader();
				}catch (e2:Error) {
				trace(e2.message);
				}
			}
		}
		
		public function cancelLoad():void
		{
			try{
			backgroundLoader.close();
			deInitBackgroundLoader();
			}catch (e:Error) {
				trace(e.message);
			}
		}
		
		private function initBackgroundLoader():void
		{
			if (backgroundLoader) return;
			backgroundLoader = new Loader();
			backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			backgroundLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		private function deInitBackgroundLoader():void
		{
			if (!backgroundLoader) return;
			backgroundLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			backgroundLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			backgroundLoader = null;
		}
		
		private function onLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var bmp:Bitmap = loaderInfo.loader.content as Bitmap;
			var bitmapData:BitmapData = sk.yoz.image.ImageResizer.bilinearIterative(bmp.bitmapData, _width, _height, ResizeMath.METHOD_PAN_AND_SCAN);
			bmp.bitmapData = bitmapData;
			
			loaderInfo.loader.unload();
			Background = bmp;
			
			deInitBackgroundLoader();
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGBACKGROUNDCOMPLETE, this);
		}
				
		private function onLoadError(e:Event):void
		{
			deInitBackgroundLoader();
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LOADINGBACKGROUNDFAILED, this);
		}
	}

}