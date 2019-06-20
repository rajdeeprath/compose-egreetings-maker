package 
{
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.StageAspectRatio;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class Main extends Sprite 
	{
		private var isActive:Boolean = false;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
						
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		
		private function onStage(e:Event):void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.ENTER_FRAME, waitForStageOrientation);
		}
		
		
		private function waitForStageOrientation(e:Event):void
		{
			if (stage.orientation == "default") return;
			
			removeEventListener(Event.ENTER_FRAME, waitForStageOrientation);
			ApplicationFacade.getInstance().startup(this);
		}
	}
	
}