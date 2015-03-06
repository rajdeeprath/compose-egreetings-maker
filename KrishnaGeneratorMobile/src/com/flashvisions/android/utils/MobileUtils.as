package com.flashvisions.android.utils 
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author Krishna
	 */
	public class MobileUtils 
	{
		public static const DEVICE_TYPE_TABLET:String = "tablet";
		public static const DEVICE_TYPE_PHONE:String = "smartphone";
		
		public static function getDeviceType(stage:Stage, applicationDPI:Number):String
		{
			var _width : Number = Math.max( stage.stageWidth, stage.stageHeight );
			var _height : Number = Math.min( stage.stageWidth, stage.stageHeight );

			_width = _width / applicationDPI;
			_height = _height / applicationDPI;

			if ( _width >= 5 )
			return "tablet";
			else
			return "smartphone";
		}
		
		public static function getExtension($url:String):String
		{
			var extension:String = $url.substring($url.lastIndexOf(".")+1, $url.length);
			return extension.toLowerCase();
		}
	}

}