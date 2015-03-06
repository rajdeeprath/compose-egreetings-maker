package com.flashvisions.android.krishnagenerator.view
{
	import caurina.transitions.SpecialProperty;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.flashvisions.android.krishnagenerator.view.components.Canvas;
	import com.flashvisions.android.krishnagenerator.view.components.CanvasBackground;
	import com.flashvisions.android.krishnagenerator.view.components.DrawingItem;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import com.flashvisions.android.krishnagenerator.view.components.PlayableItem;
	import com.flashvisions.android.krishnagenerator.view.components.TextItem;
	import com.flashvisions.android.krishnagenerator.vo.TextData;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.events.ListItemEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import org.gestouch.events.TapGestureEvent;
	import org.gestouch.gestures.TapGesture;
	
	import org.gestouch.core.GestureState;
	import org.gestouch.core.IGestureDelegate;
	import org.gestouch.core.Touch;
	import org.gestouch.events.LongPressGestureEvent;
	import org.gestouch.events.PanGestureEvent;
	import org.gestouch.events.RotateGestureEvent;
	import org.gestouch.events.TransformGestureEvent;
	import org.gestouch.events.ZoomGestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.RotateGesture;
	import org.gestouch.gestures.TransformGesture;
	import org.gestouch.gestures.ZoomGesture;
	import org.gestouch.utils.GestureUtils;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	public class CanvasMediator extends Mediator implements IMediator, IGestureDelegate
	{
		public static const NAME:String = "CanvasMediator";
		private var canvas:Canvas;
		private var background:CanvasBackground;
		private var selectedItem:*;
		private var textEditMode:Boolean = false;
		private var gestures:Vector.<Gesture> = new Vector.<Gesture>();
		private var bounds:Rectangle;
		private var gestureMode:Boolean = false;
		private var longPressCheck:uint;
		
		private static const HORIZONTAL:String = 'horizontal';
		private static const VERTICAL:String = 'vertical';
		private static const TOP:String = 'top';
		private static const BOTTOM:String = 'bottom';
		private static const FORWARD:String = 'forward';
		private static const BACKWARD:String = 'backward';
		
		private var dataCentreProxy:DataCentreProxy;
		
		public function CanvasMediator(viewComponent:Object=null)
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
			return [ApplicationFacade.CHANGETRANSFORMTARGET, ApplicationFacade.SCALEOBJECT, ApplicationFacade.ROTATEOBJECT, ApplicationFacade.ROTATE, ApplicationFacade.SCALE, ApplicationFacade.ADDDRAWINGTOCOMPOSITION, ApplicationFacade.LAYERFORWARD, ApplicationFacade.LAYERBACKWARD, ApplicationFacade.LAYERTOP, ApplicationFacade.LAYERBOTTOM, ApplicationFacade.SHOWTEXTEDITOR, ApplicationFacade.LOADINGDECORATIVEFAILED, ApplicationFacade.LOADINGDECORATIVECOMPLETE, ApplicationFacade.FLIPVERTICAL, ApplicationFacade.FLIPHORIZONTAL, ApplicationFacade.ADDTEXT, ApplicationFacade.DELETEITEM,ApplicationFacade.READY,ApplicationFacade.ADDDECORATIVE, ApplicationFacade.CLEARALLITEMS, ApplicationFacade.ADDBACKGROUND];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{	
				case ApplicationFacade.ADDBACKGROUND:
				var backgroundItem:Object = notification.getBody()
				background.setBackgroundFromURL(backgroundItem.url);
				break;
				
				case ApplicationFacade.ADDDRAWINGTOCOMPOSITION:
				addDrawing(notification.getBody() as Sprite);
				break;
				
				case ApplicationFacade.ADDDECORATIVE:
				addInteractiveItem(notification.getBody());
				break;
				
				case ApplicationFacade.LOADINGDECORATIVECOMPLETE:
				var addedItem:PlayableItem = notification.getBody() as PlayableItem;
				if(gestureMode)
				listeners('add', addedItem);
				else
				singleTouchListeners('add', addedItem);
				break;

				case ApplicationFacade.LOADINGDECORATIVEFAILED:
				var failedItem:PlayableItem = notification.getBody() as PlayableItem;
				canvas.removeChild(failedItem);
				break;

				case ApplicationFacade.ROTATE:
				case ApplicationFacade.SCALE:
				transformObject(notification.getName() as String, notification.getBody() as Number);
				break;
				
				case ApplicationFacade.CLEARALLITEMS:
				dataCentreProxy.hideTransformToolsIfShowing();
				clearCanvas();
				break;
				
				case ApplicationFacade.DELETEITEM:
				dataCentreProxy.hideTransformToolsIfShowing();
				deleteItem();
				break;
				
				case ApplicationFacade.SHOWTEXTEDITOR:
				dataCentreProxy.hideTransformToolsIfShowing();
				if (notification.getBody() == null)	
				selectedItem = null;
				break;
				
				case ApplicationFacade.ADDTEXT:
				if (notification.getBody()){
				if (textEditMode && selectedItem!=null)
				updateTextItem(notification.getBody() as TextData);
				else
				addTextItem(notification.getBody() as TextData);
				}
				textEditMode = false;
				break;
				
				case ApplicationFacade.FLIPVERTICAL:
				dataCentreProxy.hideTransformToolsIfShowing();
				flipItem(VERTICAL);
				break;
				
				case ApplicationFacade.FLIPHORIZONTAL:
				dataCentreProxy.hideTransformToolsIfShowing();
				flipItem(HORIZONTAL);
				break;
				
				
				case ApplicationFacade.LAYERTOP:
				dataCentreProxy.hideTransformToolsIfShowing();
				stackOrderItem(TOP);
				break;
				
				case ApplicationFacade.LAYERBOTTOM:
				dataCentreProxy.hideTransformToolsIfShowing();
				stackOrderItem(BOTTOM);
				break;
				
				case ApplicationFacade.LAYERFORWARD:
				dataCentreProxy.hideTransformToolsIfShowing();
				stackOrderItem(FORWARD);
				break;
				
				case  ApplicationFacade.LAYERBACKWARD:
				dataCentreProxy.hideTransformToolsIfShowing();
				stackOrderItem(BACKWARD);
				break;
				
				case ApplicationFacade.CHANGETRANSFORMTARGET:
				case ApplicationFacade.SCALEOBJECT:
				case ApplicationFacade.ROTATEOBJECT:
				var currentScale:uint = Math.abs(selectedItem.scaleX) * 10;
				var currentRotation:Number = 180 + selectedItem.rotation;
				if (notification.getName() == ApplicationFacade.CHANGETRANSFORMTARGET)
				dataCentreProxy.updateTransformToolsTarget(60, currentScale, 360, currentRotation);
				else
				dataCentreProxy.showTransformTools(60, currentScale, 360, currentRotation);
				break;
			}
		}
		
		override public function onRegister():void 
		{
			canvas = this.viewComponent as Canvas ;
			background = canvas.getBackground();
			bounds = new Rectangle(background.x, background.y, background.width, background.height);
			dataCentreProxy = facade.retrieveProxy(DataCentreProxy.NAME) as DataCentreProxy;
			
			
			if (Multitouch.supportsGestureEvents || Multitouch.maxTouchPoints >= 2) {	
			initGestureMode();
			}else {
			initSingleTouchMode();	
			}
				
		}
		
		override public function onRemove():void 
		{
			
		}
		
		private function addDrawing(drawing:Sprite):void
		{
			var interactiveItem:DrawingItem = new DrawingItem(drawing);
			interactiveItem.addChild(drawing);
			
			interactiveItem.x = canvas.width / 2 - interactiveItem.width / 2;
			interactiveItem.y = canvas.height / 2 - interactiveItem.height / 2;
			canvas.addChild(interactiveItem);
			
			if(gestureMode)
			listeners('add', interactiveItem);
			else
			singleTouchListeners('add', interactiveItem);
		}
		
		private function addInteractiveItem(item:Object):void
		{
			var interactiveItem:PlayableItem = new PlayableItem(item.url);
			interactiveItem.scaleX = interactiveItem.scaleY = 2;
			interactiveItem.x = canvas.width / 2 - interactiveItem.width / 2;
			interactiveItem.y = canvas.height / 2 - interactiveItem.height / 2;
			canvas.addChild(interactiveItem);
		}
		
		private function addTextItem(data:TextData):void
		{
			var textItem:TextItem = new TextItem(canvas.stage.stageWidth * .8, canvas.stage.stageWidth * .8, data);
			textItem.x = canvas.width / 2 - textItem.width / 2;
			textItem.y = canvas.height / 2 - textItem.height / 2;
			canvas.addChild(textItem);
			
			if(gestureMode)
			listeners('add', textItem);
			else
			singleTouchListeners('add', textItem);
		}
		
		private function updateTextItem(data:TextData):void
		{
			var textItem:TextItem = selectedItem as TextItem;
			textItem.data = data;
			
			if (textItem.x < 0) textItem.x = 2;
			if (textItem.y < 0) textItem.y = 2;
		}
		
		private function initSingleTouchMode():void
		{
			gestureMode = false;
			
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, updateScreenPosition);
			canvas.addEventListener(MouseEvent.MOUSE_UP, onStopObjectMove);
			canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDeselectAll);
		}
		
		private function initGestureMode():void
		{
			gestureMode = true;
			
			if(Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT)
			canvas.addEventListener(TouchEvent.TOUCH_TAP, selectItemInGestureMode);
			else
			canvas.addEventListener(MouseEvent.CLICK, selectItemInGestureMode);
		}
		
		private function singleTouchListeners(action:String, target:Sprite):void
		{
			if(action == 'add')
			{
				if (target is TextItem)
				target.addEventListener(MouseEvent.DOUBLE_CLICK, onEditText);
				target.addEventListener(MouseEvent.MOUSE_DOWN, onStartObjectMove);
				trace(1);
			}
			else
			{
				if (target is TextItem)
				target.removeEventListener(MouseEvent.DOUBLE_CLICK, onEditText);
				target.removeEventListener(MouseEvent.MOUSE_DOWN, onStartObjectMove);
			}
		}
		
		private function listeners(action:String, target:Sprite):void
		{
			if(action == 'add')
			{
				
					var longPressGesture:LongPressGesture = new LongPressGesture(target);
					longPressGesture.addEventListener(LongPressGestureEvent.GESTURE_LONG_PRESS, onGesture);
					longPressGesture.minPressDuration = 600;
					gestures.push(longPressGesture);
					
					var rotate:RotateGesture = new RotateGesture(target);
					rotate.addEventListener(RotateGestureEvent.GESTURE_ROTATE, onRotateGesture);
					rotate.delegate = this;
					gestures.push(rotate);
					
					var zoom:ZoomGesture = new ZoomGesture(target);
					zoom.addEventListener(ZoomGestureEvent.GESTURE_ZOOM, onZoomGesture);
					zoom.delegate = this;
					gestures.push(zoom);
					
					
					var pan:PanGesture = new PanGesture(target);
					pan.maxNumTouchesRequired = 2;
					pan.minNumTouchesRequired = 1;
					pan.addEventListener(PanGestureEvent.GESTURE_PAN, onPan);
					pan.delegate = this;
					gestures.push(pan);
					
					
					if (target is TextItem)
					target.addEventListener(MouseEvent.DOUBLE_CLICK, onEditText);
			}
			else
			{
				
				for (var i:int = 0; i < gestures.length; i++)
				{
					var gesture:Gesture = gestures[i] as Gesture;
					
					if(gesture.target == target)
					{
						if(gesture.hasEventListener(LongPressGestureEvent.GESTURE_LONG_PRESS))
						gesture.removeEventListener(LongPressGestureEvent.GESTURE_LONG_PRESS, onGesture);
						
						if(gesture.hasEventListener(RotateGestureEvent.GESTURE_ROTATE))
						gesture.removeEventListener(RotateGestureEvent.GESTURE_ROTATE, onRotateGesture);
						
						if(gesture.hasEventListener(ZoomGestureEvent.GESTURE_ZOOM))
						gesture.removeEventListener(ZoomGestureEvent.GESTURE_ZOOM, onZoomGesture);
						
						if(gesture.hasEventListener(PanGestureEvent.GESTURE_PAN))
						gesture.removeEventListener(PanGestureEvent.GESTURE_PAN, onPan);
						
						if (target is TextItem)
						target.removeEventListener(MouseEvent.DOUBLE_CLICK, onEditText);
						
						gesture.delegate = null;
						gesture.dispose();
						
						gestures.splice(i, 1);
						i--;
					}
					
				}
				
				
				if (target is TextItem)
				target.removeEventListener(MouseEvent.DOUBLE_CLICK, onEditText);
			}
		}
		
		
		private function onEditText(e:MouseEvent):void
		{
			var textItem:TextItem = e.target as TextItem;
			selectedItem = e.target;
			textEditMode = true;
			facade.sendNotification(ApplicationFacade.SHOWTEXTEDITOR, textItem.data);
		}
		
		
		private function selectItemInGestureMode(e:Event):void
		{	
			
			if ((e.target is PlayableItem) || (e.target is TextItem) || (e.target is DrawingItem)) {
				
				if (e.target == selectedItem) return; // patch for double call
				
				selectedItem = e.target as Sprite;
				
				if (dataCentreProxy.isTransformToolShowing())
				facade.sendNotification(ApplicationFacade.CHANGETRANSFORMTARGET);
								
				facade.sendNotification(ApplicationFacade.HIDEOBJECTLIST);
			}else if (e.target is CanvasBackground) {
				
				selectedItem = null;
				dataCentreProxy.hideTransformToolsIfShowing();
				//facade.sendNotification(ApplicationFacade.SHOWOBJECTLIST);
			}
		}
		
		
		private function updateScreenPosition(e:MouseEvent):void
		{
			if(selectedItem!=null)
			e.updateAfterEvent();
		}
		
		private function onDeselectAll(e:MouseEvent):void
		{
			if (!((e.target is PlayableItem) || (e.target is TextItem) || (e.target is DrawingItem)))
			{
				selectedItem = null;
				dataCentreProxy.hideTransformToolsIfShowing();
				facade.sendNotification(ApplicationFacade.SHOWOBJECTLIST);
			}
		}
		
		private function onStartObjectMove(e:MouseEvent):void
		{
			selectedItem = e.target as Sprite;
			selectedItem.startDrag();
			
			if (dataCentreProxy.isTransformToolShowing())
			facade.sendNotification(ApplicationFacade.CHANGETRANSFORMTARGET);
				
			facade.sendNotification(ApplicationFacade.HIDEOBJECTLIST);
			
			clearTimeout(longPressCheck);
			longPressCheck = setTimeout(checkForLongPress, 700, selectedItem as Sprite, selectedItem.x, selectedItem.y);
		}
		
		private function onStopObjectMove(e:MouseEvent):void
		{
			if(selectedItem)
			selectedItem.stopDrag();
		}
		
		private function checkForLongPress(object:Sprite, ox:Number, oy:Number):void
		{
			var xdiff:Number = Math.abs(object.x - ox);
			var ydiff:Number = Math.abs(object.y - oy);
			
			if (xdiff <= 4 && ydiff <= 4 && object == selectedItem && selectedItem != null) {
			selectedItem.stopDrag();	
			facade.sendNotification(ApplicationFacade.SHOWOBJECTTOOLBAR);
			}
		}
	
		private function clearCanvas():void
		{
			var i:int = canvas.numChildren - 1;
			
			while (i>0)
			{
				if (canvas.getChildAt(i) != null)
				{
					/* Remove all but transform tool and the canvas */
					
					if ((!(canvas.getChildAt(i) is CanvasBackground )))
					{
						var object:* = canvas.getChildAt(i);
						
						if(object is PlayableItem || object is TextItem || object is DrawingItem){
						if(gestureMode)
						listeners('remove', object);
						else
						singleTouchListeners('remove', object);
						}
						canvas.removeChildAt(i);
						
						object = null;
					}
					
				}
				
				i--;
			}
			
			System.gc();
		}
		
		private function transformObject(type:String, value:Number):void
		{
			var interactiveItem:Sprite = this.selectedItem as Sprite;
			if (!interactiveItem) return;
			
			switch(type)
			{
				case ApplicationFacade.ROTATE:
				interactiveItem.rotation = value;
				break;
				
				case ApplicationFacade.SCALE:
				interactiveItem.scaleX = (interactiveItem.scaleX<0)?(value * -1):value;
				interactiveItem.scaleY = (interactiveItem.scaleY<0)?(value * -1):value;
				break;
			}
		}
		
		private function stackOrderItem(order:String):void
		{
			var selectedItem:Sprite = this.selectedItem as Sprite;
			if (!selectedItem) return;
			
			var parent:DisplayObjectContainer = selectedItem.parent;
			
			switch(order)
			{
				case TOP:
				parent.setChildIndex(selectedItem, parent.numChildren - 1);
				break;
				
				case BOTTOM:
				parent.setChildIndex(selectedItem, 1);
				break;
				
				case FORWARD:
				if (parent.getChildIndex(selectedItem) < (parent.numChildren - 1))
				parent.setChildIndex(selectedItem, parent.getChildIndex(selectedItem) + 1);
				break;
				
				case BACKWARD:
				if (parent.getChildIndex(selectedItem) > 1)
				parent.setChildIndex(selectedItem, parent.getChildIndex(selectedItem) - 1);
				break;
			}
		}
		
		private function flipItem(direction:String):void
		{
			var selectedItem:Sprite = this.selectedItem as Sprite;
			if (!selectedItem) return;
			
			var matrix:Matrix = selectedItem.transform.matrix;
			matrix.translate( -selectedItem.x, -selectedItem.y);
			
			switch(direction)
			{
				case HORIZONTAL:
				matrix.scale(-1, 1);
				break;
				
				case VERTICAL:
				matrix.scale(1, -1);
				break;
			}
			
			matrix.translate(selectedItem.x, selectedItem.y);
			selectedItem.transform.matrix = matrix;
		}
		
		private function deleteItem():void
		{
			if (!selectedItem) return;
			
			if (selectedItem is PlayableItem || selectedItem is TextItem || selectedItem is DrawingItem) {
			if(gestureMode)
			listeners('remove', selectedItem);
			else
			singleTouchListeners('remove', selectedItem);
			}
			
			canvas.removeChild(selectedItem);
			selectedItem = null;
		}
		
		private function onGesture(event:LongPressGestureEvent):void
		{
			var longpressGesture:LongPressGesture = event.target as LongPressGesture;
			var interactiveItem:Sprite = longpressGesture.target as Sprite;
			var fingerToImageOffset:Point = new Point();
			var loc:Point = canvas.globalToLocal(longpressGesture.location);
			
				if (event.gestureState == GestureState.BEGAN)
				{
					selectedItem = interactiveItem;
					facade.sendNotification(ApplicationFacade.SHOWOBJECTTOOLBAR);
					TweenMax.to(interactiveItem, 0.5, {alpha: 0.5, glowFilter: {color: 0xEEEEEE * Math.random(), blurX: 16, blurY: 16, strength: 2, alpha: 1}});
				}
				else if (event.gestureState == GestureState.CHANGED)
				{
					// NO OP
				}
				else if (event.gestureState == GestureState.ENDED)
				{
					TweenMax.to(interactiveItem, 1, {alpha: 1, glowFilter: {alpha: 0, remove: true}});
				}	
		}
		
		
		private function onRotateGesture(event:RotateGestureEvent):void
		{
			var rotate:RotateGesture = event.target as RotateGesture;
			var interactiveItem:Sprite = rotate.target as Sprite;
			var loc:Point = canvas.globalToLocal(rotate.location);
			
			if (event.rotation != 0)
			{			
				var matrix:Matrix = interactiveItem.transform.matrix;
				var transformPoint:Point = matrix.transformPoint(new Point(event.localX, event.localY));
				matrix.translate(-transformPoint.x, -transformPoint.y);
				matrix.rotate(event.rotation * GestureUtils.DEGREES_TO_RADIANS);
				matrix.translate(transformPoint.x, transformPoint.y);
				interactiveItem.transform.matrix = matrix;
			}	
		}
		
		private function onZoomGesture(event:ZoomGestureEvent):void
		{
			var zoom:ZoomGesture = event.target as ZoomGesture;
			var interactiveItem:Sprite = zoom.target as Sprite;
			var loc:Point = canvas.globalToLocal(zoom.location);
				
				if (event.scaleX != 1 || event.scaleY)
				{			
					var matrix:Matrix = interactiveItem.transform.matrix;
					var transformPoint:Point = matrix.transformPoint(new Point(event.localX, event.localY));
					matrix.translate(-transformPoint.x, -transformPoint.y);
					matrix.scale(event.scaleX, event.scaleY);
					matrix.translate(transformPoint.x, transformPoint.y);
					interactiveItem.transform.matrix = matrix;
				}
		}
		
		private function onPan(event:PanGestureEvent):void
		{
			var pan:PanGesture = event.target as PanGesture;
			var interactiveItem:Sprite = pan.target as Sprite;
			
			
			if (event.offsetX != 0 || event.offsetY != 0)
			{
				interactiveItem.x = interactiveItem.x + event.offsetX;
				interactiveItem.y = interactiveItem.y + event.offsetY;
			}
			
		}
		
		public function gestureShouldReceiveTouch(gesture:Gesture, touch:Touch):Boolean
		{
			return true;
		}


		public function gestureShouldBegin(gesture:Gesture):Boolean
		{
			return true;
		}


		public function gesturesShouldRecognizeSimultaneously(gesture:Gesture, otherGesture:Gesture):Boolean
		{
			if (gesture.target == otherGesture.target)
			{
				return true;
			}

			return false;
		}
	}
}