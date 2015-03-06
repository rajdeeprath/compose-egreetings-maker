package org.gestouch.core
{
	import org.gestouch.gestures.Gesture;
	import org.gestouch.input.MouseInputAdapter;
	import org.gestouch.input.TouchInputAdapter;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;

	/**
	 * @author Pavel fljot
	 */
	public class GesturesManager implements IGesturesManager
	{
		public static var initDefaultInputAdapter:Boolean = true;
		private static var _instance:IGesturesManager;
		private static var _allowInstantiation:Boolean;
		
		protected const _touchesManager:ITouchesManager = TouchesManager.getInstance();
		protected const _frameTickerShape:Shape = new Shape();
		protected var _inputAdapters:Vector.<IInputAdapter> = new Vector.<IInputAdapter>();
		protected var _stage:Stage;
		protected var _gesturesMap:Dictionary = new Dictionary(true);
		protected var _gesturesForTouchMap:Array = [];
		protected var _gesturesForTargetMap:Dictionary = new Dictionary(true);
		protected var _dirtyGestures:Vector.<Gesture> = new Vector.<Gesture>();
		protected var _dirtyGesturesLength:uint = 0;
		protected var _dirtyGesturesMap:Dictionary = new Dictionary(true);
		
		
		public function GesturesManager()
		{
			if (Object(this).constructor == GesturesManager && !_allowInstantiation)
			{
				throw new Error("Do not instantiate GesturesManager directly.");
			}
		}
		
		
		public function get inputAdapters():Vector.<IInputAdapter>
		{
			return _inputAdapters.concat();
		}
		
		
		public static function setImplementation(value:IGesturesManager):void
		{
			if (!value)
			{
				throw new ArgumentError("value cannot be null.");
			}
			if (_instance)
			{
				throw new Error("Instance of GesturesManager is already created. If you want to have own implementation of single GesturesManager instace, you should set it earlier.");
			}
			_instance = value;
		}
		

		public static function getInstance():IGesturesManager
		{
			if (!_instance)
			{
				_allowInstantiation = true;
				_instance = new GesturesManager();
				_allowInstantiation = false;
			}
			 
			return _instance;
		}
			
		
		
		
		public function addInputAdapter(inputAdapter:IInputAdapter):void
		{
			if (!inputAdapter)
			{
				throw new Error("Input adapter must be non null.");
			}
			
			if (_inputAdapters.indexOf(inputAdapter) > -1)
				return;//TODO: throw Error or ignore?
			
			_inputAdapters.push(inputAdapter);
			inputAdapter.touchesManager = _touchesManager;
			inputAdapter.gesturesManager = this;
			inputAdapter.init();
		}
		
		
		public function removeInputAdapter(inputAdapter:IInputAdapter, dispose:Boolean = true):void
		{
			if (!inputAdapter)
			{
				throw new Error("Input adapter must be non null.");
			}
			var index:int = _inputAdapters.indexOf(inputAdapter);
			if (index == -1)
			{
				throw new Error("This input manager is not registered.");
			}
			
			_inputAdapters.splice(index, 1);
			if (dispose)
			{
				inputAdapter.dispose();
			}
		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		protected function installStage(stage:Stage):void
		{
			_stage = stage;
			
			if (Multitouch.supportsTouchEvents)
			{
				addInputAdapter(new TouchInputAdapter(stage));
			}
			else
			{
				addInputAdapter(new MouseInputAdapter(stage));
			}
		}
		
		
		protected function resetDirtyGestures():void
		{
			for each (var gesture:Gesture in _dirtyGestures)
			{
				gesture.reset();
			}
			_dirtyGestures.length = 0;
			_dirtyGesturesLength = 0;
			_dirtyGesturesMap = new Dictionary(true);
			_frameTickerShape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		gestouch_internal function addGesture(gesture:Gesture):void
		{
			if (!gesture)
			{
				throw new ArgumentError("Argument 'gesture' must be not null.");
			}
			if (_gesturesMap[gesture])
			{
				throw new Error("This gesture is already registered.. something wrong.");
			}
			
			var target:Object = gesture.target;
			var targetGestures:Vector.<Gesture> = _gesturesForTargetMap[target] as Vector.<Gesture>;
			if (!targetGestures)
			{
				targetGestures = _gesturesForTargetMap[gesture.target] = new Vector.<Gesture>();
			}
			targetGestures.push(gesture);
			
			_gesturesMap[gesture] = true;
			
			if (GesturesManager.initDefaultInputAdapter)
			{
				if (!_stage && gesture.target.stage)
				{
					installStage(gesture.target.stage);
				}
				else
				{
					gesture.target.addEventListener(Event.ADDED_TO_STAGE, gestureTarget_addedToStageHandler);
				}
			}
		}
		
		
		gestouch_internal function removeGesture(gesture:Gesture):void
		{
			if (!gesture)
			{
				throw new ArgumentError("Argument 'gesture' must be not null.");
			}
			
			
			var target:InteractiveObject = gesture.target;
			var targetGestures:Vector.<Gesture> = _gesturesForTargetMap[target] as Vector.<Gesture>;
			if (targetGestures.length > 1)
			{
				targetGestures.splice(targetGestures.indexOf(gesture), 1);
			}			
			else
			{
				delete _gesturesForTargetMap[target];
				target.removeEventListener(Event.ADDED_TO_STAGE, gestureTarget_addedToStageHandler);
			}
			
			delete _gesturesMap[gesture];
			
			//TODO: decide about gesture state and _dirtyGestures
		}
		
		
		gestouch_internal function scheduleGestureStateReset(gesture:Gesture):void
		{
			if (!_dirtyGesturesMap[gesture])
			{
				_dirtyGestures.push(gesture);
				_dirtyGesturesLength++;
				_frameTickerShape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		
		gestouch_internal function onGestureRecognized(gesture:Gesture):void
		{
			for (var key:Object in _gesturesMap)
			{
				var otherGesture:Gesture = key as Gesture;
                var target:DisplayObject = gesture.target;
                var otherTarget:DisplayObject = otherGesture.target;
				
				// conditions for otherGesture "own properties"
				if (otherGesture != gesture &&
					target && otherTarget &&//in case GC worked half way through
					otherGesture.enabled &&
					otherGesture.state == GestureState.POSSIBLE)
				{
					// conditions for otherGesture target
					if (otherTarget == target ||
						(target is DisplayObjectContainer && (target as DisplayObjectContainer).contains(otherTarget)) ||
						(otherTarget is DisplayObjectContainer && (otherTarget as DisplayObjectContainer).contains(target)))
					{
						var gestureDelegate:IGestureDelegate = gesture.delegate;
						var otherGestureDelegate:IGestureDelegate = otherGesture.delegate;
						// conditions for gestures relations
						if (gesture.canPreventGesture(otherGesture) &&
							otherGesture.canBePreventedByGesture(gesture) &&
							(!gestureDelegate || !gestureDelegate.gesturesShouldRecognizeSimultaneously(gesture, otherGesture)) &&
							(!otherGestureDelegate || !otherGestureDelegate.gesturesShouldRecognizeSimultaneously(otherGesture, gesture)))
						{
							otherGesture.gestouch_internal::setState_internal(GestureState.FAILED);
						}
					}					
				}
			}
		}
		
		
		gestouch_internal function onTouchBegin(touch:Touch):void
		{
			if (_dirtyGesturesLength > 0)
			{
				resetDirtyGestures();
			}
			
			var gesture:Gesture;
			var i:uint;
			
			// This vector will contain active gestures for specific touch (ID) during all touch session.
			var gesturesForTouch:Vector.<Gesture> = _gesturesForTouchMap[touch.id] as Vector.<Gesture>;
			if (!gesturesForTouch)
			{
				gesturesForTouch = new Vector.<Gesture>(); 
				_gesturesForTouchMap[touch.id] = gesturesForTouch;
			}
			else
			{
				gesturesForTouch.length = 0;
			}			
			
			
			// Create a sorted(!) list of gestures which are interested in this touch.
			// Sorting priority: deeper target has higher priority, recently added gesture has higher priority.
			var target:InteractiveObject = touch.target;
			var gesturesForTarget:Vector.<Gesture>;
			while (target)
			{
				gesturesForTarget = _gesturesForTargetMap[target] as Vector.<Gesture>;
				if (gesturesForTarget)
				{
					i = gesturesForTarget.length;
					while (i-- > 0)
					{
						gesture = gesturesForTarget[i] as Gesture;
						if (gesture.enabled &&
							(!gesture.delegate || gesture.delegate.gestureShouldReceiveTouch(gesture, touch)))
						{
							//TODO: optimize performance! decide between unshift() vs [i++] = gesture + reverse()
							gesturesForTouch.unshift(gesture);
						}
					}
				}
				
				target = target.parent;
			}
			
			// Then we populate them with this touch and event.
			// They might start tracking this touch or ignore it (via Gesture#ignoreTouch())
			i = gesturesForTouch.length;
			while (i-- > 0)
			{
				gesture = gesturesForTouch[i] as Gesture;
				// Check for state because previous (i+1) gesture may already abort current (i) one
				if (gesture.state != GestureState.FAILED)
				{
					gesture.gestouch_internal::touchBeginHandler(touch);
				}
				else
				{
					gesturesForTouch.splice(i, 1);
				}
			}
		}
		
		
		gestouch_internal function onTouchMove(touch:Touch):void
		{
			if (_dirtyGesturesLength > 0)
			{
				resetDirtyGestures();
			}
			
			var gesturesForTouch:Vector.<Gesture> = _gesturesForTouchMap[touch.id] as Vector.<Gesture>;
			var gesture:Gesture;
			var i:int = gesturesForTouch.length;
			while (i-- > 0)
			{
				gesture = gesturesForTouch[i] as Gesture;
				
				if (gesture.state != GestureState.FAILED && gesture.isTrackingTouch(touch.id))
				{
					gesture.gestouch_internal::touchMoveHandler(touch);
				}
				else
				{
					// gesture is no more interested in this touch (e.g. ignoreTouch was called)
					gesturesForTouch.splice(i, 1);
				}
			}
		}
		
		
		gestouch_internal function onTouchEnd(touch:Touch):void
		{
			if (_dirtyGesturesLength > 0)
			{
				resetDirtyGestures();
			}
			
			var gesturesForTouch:Vector.<Gesture> = _gesturesForTouchMap[touch.id] as Vector.<Gesture>;
			var gesture:Gesture;
			var i:int = gesturesForTouch.length;
			while (i-- > 0)
			{
				gesture = gesturesForTouch[i] as Gesture;
									
				if (gesture.state != GestureState.FAILED && gesture.isTrackingTouch(touch.id))
				{					
					gesture.gestouch_internal::touchEndHandler(touch);
				}
			}
		}
		
		
		gestouch_internal function onTouchCancel(touch:Touch):void
		{
			//TODO
		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------		
		
		protected function gestureTarget_addedToStageHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			target.removeEventListener(Event.ADDED_TO_STAGE, gestureTarget_addedToStageHandler);
			if (!_stage && GesturesManager.initDefaultInputAdapter)
			{
				installStage(target.stage);
			}
		}
		
		
		private function enterFrameHandler(event:Event):void
		{
			resetDirtyGestures();
		}
	}
}