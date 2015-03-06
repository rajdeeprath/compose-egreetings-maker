package com.flashvisions.android.krishnagenerator.model.business
{
	import com.flashvisions.android.krishnagenerator.model.DataCentreProxy;
	import com.remoting.RemotingConnection;
	import flash.net.Responder;
	
	public class LoadCategoriesDelegate
	{
		private var responder :Responder;
		private var service :RemotingConnection;
		
		public function LoadCategoriesDelegate(responder:Responder)
		{
			// constructor will store a reference to the service we're going to call
			this.service = DataCentreProxy.getService();
			this.responder = responder;
		}
		
		public function loadCategories() : void 
		{
			service.call( "Krishna.loadCategoriesRaw", responder);
		}
		
		public function loadInstructions() : void 
		{
			service.call( "Krishna.loadInstructions", responder);
		}
	}
}