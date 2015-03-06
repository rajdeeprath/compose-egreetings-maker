package com.remoting

{

	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;

	import flash.net.ObjectEncoding;

	public class RemotingConnection extends NetConnection
	{
		public function RemotingConnection()
		{
			objectEncoding = ObjectEncoding.AMF3;
		}
		
	}

}