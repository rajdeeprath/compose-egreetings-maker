package org.gestouch.input
{
	import org.gestouch.core.Touch;
	import org.gestouch.core.gestouch_internal;

	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventPhase;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;


	/**
	 * @author Pavel fljot
	 */
	public class TouchInputAdapter extends AbstractInputAdapter
	{		
		protected var _stage:Stage;
		/**
		 * The hash map of touches instantiated via TouchEvent.
		 * Used to avoid collisions (double processing) with MouseInputAdapter.
		 * 
		 * TODO: any better way?
		 */
		protected var _touchesMap:Object = {};
		
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		
		
		public function TouchInputAdapter(stage:Stage)
		{
			super();
			
			if (!stage)
			{
				throw new Error("Stage must be not null.");
			}
			
			_stage = stage;
		}
		
			
		override public function init():void
		{
			_stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler, true);
			_stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);// to catch with EventPhase.AT_TARGET
		}
		
			
		override public function dispose():void
		{
			_stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler, true);
			_stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			uninstallStageListeners();
		}
		
		
		protected function installStageListeners():void
		{
			// Maximum priority to prevent event hijacking	
			_stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler, true, int.MAX_VALUE);
			_stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler, false, int.MAX_VALUE);
			_stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler, true, int.MAX_VALUE);
			_stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler, false, int.MAX_VALUE);
		}
		
		
		protected function uninstallStageListeners():void
		{
			_stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler, true);
			_stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			_stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler, true);
			_stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		
		protected function touchBeginHandler(event:TouchEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;//we listen in capture or at_target (to catch on empty stage)
			// Way to prevent MouseEvent/TouchEvent collisions.
			// Also helps to ignore possible fake events.
			if (_touchesManager.hasTouch(event.touchPointID))
				return;
			
			installStageListeners();
			
			var touch:Touch = _touchesManager.createTouch();
			touch.id = event.touchPointID;
			touch.target = event.target as InteractiveObject;
			touch.gestouch_internal::setLocation(new Point(event.stageX, event.stageY));
			touch.sizeX = event.sizeX;
			touch.sizeY = event.sizeY;
			touch.pressure = event.pressure;
			//TODO: conditional compilation?
			if (event.hasOwnProperty("timestamp"))
			{
				touch.gestouch_internal::setTime(event["timestamp"]);
				touch.gestouch_internal::setBeginTime(event["timestamp"]);
			}
			else
			{
				touch.gestouch_internal::setTime(getTimer());
				touch.gestouch_internal::setBeginTime(getTimer());
			}
			
			_touchesManager.addTouch(touch);
			_touchesMap[touch.id] = true;
			
			_gesturesManager.gestouch_internal::onTouchBegin(touch);
		}
		
		
		protected function touchMoveHandler(event:TouchEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;//we listen in capture or at_target (to catch on empty stage)
			// Way to prevent MouseEvent/TouchEvent collisions.
			// Also helps to ignore possible fake events.
			if (!_touchesManager.hasTouch(event.touchPointID) || !_touchesMap.hasOwnProperty(event.touchPointID))
				return;
			
			var touch:Touch = _touchesManager.getTouch(event.touchPointID);
			touch.gestouch_internal::updateLocation(event.stageX, event.stageY);
			touch.sizeX = event.sizeX;
			touch.sizeY = event.sizeY;
			touch.pressure = event.pressure;
			//TODO: conditional compilation?
			if (event.hasOwnProperty("timestamp"))
			{
				touch.gestouch_internal::setTime(event["timestamp"]);
			}
			else
			{
				touch.gestouch_internal::setTime(getTimer());
			}
			
			_gesturesManager.gestouch_internal::onTouchMove(touch);
		}
		
		
		protected function touchEndHandler(event:TouchEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;//we listen in capture or at_target (to catch on empty stage)
			
			// Way to prevent MouseEvent/TouchEvent collisions.
			// Also helps to ignore possible fake events.
			if (!_touchesManager.hasTouch(event.touchPointID))
				return;
			
			var touch:Touch = _touchesManager.getTouch(event.touchPointID);
			touch.gestouch_internal::updateLocation(event.stageX, event.stageY);
			touch.sizeX = event.sizeX;
			touch.sizeY = event.sizeY;
			touch.pressure = event.pressure;
			//TODO: conditional compilation?
			if (event.hasOwnProperty("timestamp"))
			{
				touch.gestouch_internal::setTime(event["timestamp"]);
			}
			else
			{
				touch.gestouch_internal::setTime(getTimer());
			}
			
			_gesturesManager.gestouch_internal::onTouchEnd(touch);
			
			_touchesManager.removeTouch(touch);
			delete _touchesMap[touch.id];
			
			if (_touchesManager.activeTouchesCount == 0)
			{
				uninstallStageListeners();
			}
			
			// TODO: handle cancelled touch:
			// if (event.hasOwnProperty("isTouchPointCanceled") && event["isTouchPointCanceled"] && ...
		}
	}
}