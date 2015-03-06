package com.flashvisions.android.krishnagenerator.controller
{
	import com.adobe.nativeExtensions.Vibration;
	import com.flashvisions.android.krishnagenerator.ApplicationFacade;
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InteractionFeedbackCommand extends SimpleCommand implements ICommand
	{		
		public function InteractionFeedbackCommand()
		{
			super();
		}
		
				
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void 
		{
			var vibrator:Vibration = DataCentreProxy.getVibrator();
			if(vibrator)vibrator.vibrate(40);
		}
		
		
	}
}