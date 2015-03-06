package com.flashvisions.android.krishnagenerator.view.components  
{
	import com.flashvisions.android.krishnagenerator.vo.TextData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	/**
	 * ...
	 * @author Rajdeep
	 */
	
	public class TextItem extends Sprite
	{
		private var __textField:TextField;
		private var __txtFormat:TextFormat;
		private var __width:int;
		private var __height:int;
		private var _data:TextData;
				
		public var type:String = "text";
		
		public function TextItem(_width:int, _height:int, _data:TextData) 
		{
			this._data = _data;
			this.__width = _width;
			this.__height = _height;
			this.doubleClickEnabled = true;
			
			if (stage) createChildren();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function get data():TextData
		{
			return _data;
		}
		
		public function set data(data:TextData):void
		{
			_data = data;
			update();
		}
		
		
		public function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			createChildren();
			update();
		}
		
		protected function createChildren():void
		{
			__txtFormat = new TextFormat(_data.font, _data.size, _data.color);
			
			__textField = new TextField();
			__textField.embedFonts = true;
			__textField.multiline = true;
			__textField.autoSize = TextFieldAutoSize.LEFT;
			
			__textField.defaultTextFormat = __txtFormat;
			
			mouseChildren = false;
			addChild(__textField);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			alignTextField();
		}
		
		private function alignTextField():void
		{
			__textField.x = - (__textField.width / 2);
			__textField.y = - (__textField.height / 2);
		}
		
		/* Getters and Setters */
		
		public function update():void
		{
			__textField.width = null;
			__textField.wordWrap = false;
			
			__textField.autoSize = TextFieldAutoSize.LEFT;
			__textField.text = _data.text;
			__txtFormat.font = _data.font;
			__txtFormat.color = _data.color;
			__txtFormat.size = _data.size;
			__textField.setTextFormat(__txtFormat);
			
			// testing screen update issues
			__textField.cacheAsBitmap = true;
						
			if (__textField.width >= this.stage.stageWidth) {
			__textField.wordWrap = true;
			__textField.width = this.stage.stageWidth - 5;	
			__textField.width = __textField.textWidth;
			}
			
			
			alignTextField();
		}
		
		protected function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			_data = null;
			__txtFormat = null;
			removeChild(__textField);
			__textField = null;
		}
		
		
	}

}