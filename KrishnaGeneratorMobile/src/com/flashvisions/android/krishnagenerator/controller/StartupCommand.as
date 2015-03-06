package com.flashvisions.android.krishnagenerator.controller
{
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	
	public class StartupCommand extends AsyncMacroCommand implements IAsyncCommand 
	{
		public function StartupCommand()
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(InitFrameworkCommand);
			addSubCommand(InitFontsCommand);
			addSubCommand(InitInstructionsCommand);
			addSubCommand(InitCategoriesCommand);
			addSubCommand(InitStorageCommand);
			addSubCommand(StartupCompleteCommand);
		}
	}
}