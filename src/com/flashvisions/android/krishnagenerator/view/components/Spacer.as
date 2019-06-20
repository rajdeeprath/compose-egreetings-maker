package com.flashvisions.android.krishnagenerator.view.components 
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class Spacer extends Shape 
	{
		
		public function Spacer(width:Number= 10, height:Number= 10) 
		{
			this.graphics.clear();
			this.graphics.lineStyle();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
	}

}