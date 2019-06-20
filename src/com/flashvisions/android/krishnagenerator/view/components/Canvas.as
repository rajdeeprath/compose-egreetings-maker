package com.flashvisions.android.krishnagenerator.view.components 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Krishna
	 */
	public class Canvas extends Sprite 
	{
		//[Embed(source = '../../../../../../assets/darkwood.jpg')]
		//private var backgroundImage:Class;
		private var background:CanvasBackground;
		
		public function Canvas(width:Number,height:Number,color:uint=0xffffff) 
		{
			background = new CanvasBackground(width, height, color);
			addChild(background);
		}
		
		public function getBackground():CanvasBackground
		{
			return background;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			background.x = background.y = 0;
			background.setSize(w, h);
		}
		
		public function setColor(color:uint):void
		{
			background.setColor(color);
		}
	}

}