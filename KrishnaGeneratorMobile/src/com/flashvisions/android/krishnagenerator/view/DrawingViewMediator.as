package com.flashvisions.android.krishnagenerator.view
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.Canvas;
	import com.flashvisions.android.krishnagenerator.view.components.DrawingToolbar;
	import com.flashvisions.android.krishnagenerator.view.components.DrawingView;
	import com.flashvisions.android.krishnagenerator.view.components.Toolbar;
	import com.flashvisions.android.krishnagenerator.vo.DrawingBoardData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.desktop.NativeApplication;
	
	public class DrawingViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DrawingViewMediator";
		private var drawingView:DrawingView;
		private var drawingToolbar:DrawingToolbar;
		private var drawingcanvas:Canvas;
		private var datacenterProxy:DataCentreProxy;
		private var drawingBoardData:DrawingBoardData;
		
		private var write:Boolean = false;
		public var eraser:Boolean = false;
		private var activeSprite:Shape = null;
		
		private var objectContainer:Sprite;
		private var canvasitems:Array;
		
		private var hitarea:Sprite;
		private var previousBrushColor:Object;
		private var previousBrushSize:Object;
		
		public function DrawingViewMediator(viewComponent:Object=null)
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
			return [ApplicationFacade.CLOSEDRAWINGBOARDWITHSAVE, ApplicationFacade.DRAWINGQUITMODE, ApplicationFacade.ERASERSETTINGSCHANGED, ApplicationFacade.CANVASSETTINGSCHANGED, ApplicationFacade.BRUSHSETTINGSCHANGED];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ApplicationFacade.CANVASSETTINGSCHANGED:
				var canvasColor:uint = uint(notification.getBody().canvasColor);
				drawingcanvas.setColor(canvasColor);
				break;
				
				case ApplicationFacade.BRUSHSETTINGSCHANGED:
				var brushColor:uint = uint(notification.getBody().brushColor);
				var brushSize:uint =  notification.getBody().brushSize;
				break;
				
				case ApplicationFacade.ERASERSETTINGSCHANGED:
				var eraserSize:uint =  notification.getBody().eraserSize;
				break;
				
				case ApplicationFacade.DRAWINGQUITMODE:
				if(canvasitems.length>0)
				datacenterProxy.showDrawingViewCloseDialog();
				else
				facade.sendNotification(ApplicationFacade.CLOSEDRAWINGBOARD);
				break;
				
			case ApplicationFacade.CLOSEDRAWINGBOARDWITHSAVE:
				if (notification.getBody() == true) {
				hitarea.alpha = 0;
				facade.sendNotification(ApplicationFacade.ADDDRAWINGTOCOMPOSITION, resizeObject(objectContainer));	
				}
				
				canvasitems = [];
				facade.sendNotification(ApplicationFacade.CLOSEDRAWINGBOARD);
				break;
			}
		}
		
		override public function onRegister():void 
		{
			datacenterProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			drawingBoardData = datacenterProxy.getDrawingBoardData();
			
			drawingView = this.viewComponent as DrawingView;
			drawingcanvas = drawingView.canvas as Canvas;
			drawingToolbar = drawingView.toolbar as DrawingToolbar;
			
			objectContainer = new Sprite();
			drawingcanvas.addChild(objectContainer);
			
			canvasitems = new Array();
			
			drawingcanvas.addEventListener(MouseEvent.MOUSE_DOWN, onBeginWriting);
			drawingcanvas.addEventListener(MouseEvent.MOUSE_MOVE, onWrite);
			drawingcanvas.stage.addEventListener(MouseEvent.MOUSE_UP, onEndWriting);
			
			drawingToolbar.btnCanvasOptions.addEventListener(MouseEvent.CLICK, onCanvasMode);
			drawingToolbar.btnClear.addEventListener(MouseEvent.CLICK, onClear);
			drawingToolbar.btnBrushOptions.addEventListener(MouseEvent.CLICK, onBrushMode);
			drawingToolbar.btnUndo.addEventListener(MouseEvent.CLICK, onUndoMode);
			drawingToolbar.btnQuit.addEventListener(MouseEvent.CLICK, onQuitDrawingView);
			
			hitarea = new Sprite();
			hitarea.graphics.beginFill(0xcccccc, .4);
			hitarea.graphics.drawRect(0, 0, drawingcanvas.width, drawingcanvas.height);
			hitarea.graphics.endFill();
			objectContainer.addChild(hitarea);
			
			hitarea.mouseEnabled = false;
			hitarea.scaleX = hitarea.scaleY = .5;
			hitarea.x = drawingcanvas.width / 2 - hitarea.width / 2;
			hitarea.y = drawingcanvas.height / 2 - hitarea.height / 2;
		}
		
		override public function onRemove():void 
		{
			canvasitems = null;
			
			drawingcanvas.removeEventListener(MouseEvent.MOUSE_DOWN, onBeginWriting);
			drawingcanvas.removeEventListener(MouseEvent.MOUSE_MOVE, onWrite);
			drawingcanvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onEndWriting);
			
			drawingToolbar.btnCanvasOptions.removeEventListener(MouseEvent.CLICK, onCanvasMode);
			drawingToolbar.btnClear.removeEventListener(MouseEvent.CLICK, onClear);
			drawingToolbar.btnBrushOptions.removeEventListener(MouseEvent.CLICK, onBrushMode);
			drawingToolbar.btnUndo.removeEventListener(MouseEvent.CLICK, onUndoMode);
			drawingToolbar.btnQuit.removeEventListener(MouseEvent.CLICK, onQuitDrawingView);
		}
		
		
		private function resizeObject(object:DisplayObjectContainer):DisplayObjectContainer
		{
			var m:Matrix = new Matrix();
			m.translate(-object.x,-object.y);
			m.scale(.6, .6);
			m.translate(object.x,object.y);
			object.transform.matrix = m;
			return object;
		}
		
	
		/* event handlers */
		
		private function onBeginWriting(e:MouseEvent):void
		{
			activeSprite = new Shape();
			objectContainer.addChild(activeSprite);
			
			activeSprite.graphics.lineStyle(drawingBoardData.brushSize, drawingBoardData.brushColor);
			activeSprite.graphics.moveTo(e.localX, e.localY);
			
			canvasitems.push(activeSprite);
			write = true;
		}
		
		private function onEndWriting(e:MouseEvent):void
		{	
			activeSprite = null;
			write = false;
		}
		
		private function onWrite(e:MouseEvent):void
		{
			if (write) {
			activeSprite.graphics.lineTo(e.localX, e.localY);	
			activeSprite.graphics.moveTo(e.localX, e.localY);
			e.updateAfterEvent();
			}
		}
		
		private function onCanvasMode(e:MouseEvent):void
		{
			datacenterProxy.showCanvasOptions(drawingBoardData.canvasColor);
			facade.sendNotification(ApplicationFacade.DRAWINGCANVASMODE);
		}
		
		private function onBrushMode(e:MouseEvent):void
		{
			eraser = false;
			datacenterProxy.showBrushOptions(drawingBoardData.brushSize, drawingBoardData.brushColor);
			facade.sendNotification(ApplicationFacade.DRAWINGBRUSHMODE);
		}
				
	
		private function onUndoMode(e:MouseEvent):void
		{
			if (canvasitems.length > 0) {
				var item:Shape = canvasitems.pop();
				item.graphics.clear();
				item.parent.removeChild(item);
				item = null;
			}
			
			facade.sendNotification(ApplicationFacade.DRAWINGUNDOMODE);
		}
		
		private function onClear(e:MouseEvent):void
		{
			while (canvasitems.length > 0) {
				var item:Shape = canvasitems.pop();
				item.graphics.clear();
				item.parent.removeChild(item);
				item = null;
			}
			
			canvasitems = [];
		}
		
		private function onQuitDrawingView(e:MouseEvent):void
		{
			facade.sendNotification(ApplicationFacade.DRAWINGQUITMODE);
		}
	}
}