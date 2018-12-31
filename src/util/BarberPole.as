/*------------------------------------------------------------------------------
 |
 |  WinChatty
 |  Copyright (C) 2009 Brian Luft
 |
 | Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 | documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 | rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 | permit persons to whom the Software is furnished to do so, subject to the following conditions:
 |
 | The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 | Software.
 |
 | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 | WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 | OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 | OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 |
 !---------------------------------------------------------------------------*/
package util
{
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.events.*;
	import mx.styles.*;
	
	public class BarberPole extends UIComponent
	{
		[Embed(source="img/BarberPole.png")] public static var PoleImage : Class;
		
		private var position : int = 0;
		private var numPositions : int = 16;
		private var timer : Timer = null;
		private var isStarted : Boolean = false;
		
		/**
		 * Constructor. 
		 */
		public function BarberPole()
		{
			super();
		}
		
		public function start() : void
		{
			if (!isStarted)
			{
				isStarted = true;
				timer = new Timer(50, 0);
				timer.addEventListener(TimerEvent.TIMER,
					function(event : TimerEvent) : void
					{
						position = (position + 3) % numPositions;
						updateDisplayList(unscaledWidth, unscaledHeight);
					});
				timer.start();
			}
		}
		
		public function stop() : void
		{
			if (isStarted)
			{
				timer.stop();
				timer = null;
				isStarted = false;
			}
		}
		
		/**
		 * UIComponent function for creating the children components, such as 
		 * static text controls.
		 */
		override protected function createChildren() : void
		{
			super.createChildren();
		}
		
		/**
		 * UIComponent function called when our properties have changed. 
		 */
		override protected function commitProperties() : void
		{
			super.commitProperties();
		}
		
		/**
		 * UIComponent function called to measure the intended size of this 
		 * control. 
		 */
		override protected function measure() : void
		{
        	super.measure();
 		}
		
		/**
		 * UIComponent function called to repaint the control. 
		 * @param unscaledWidth  Width in pixels
		 * @param unscaledHeight Height in pixels
		 */
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (unscaledHeight < 4 || unscaledWidth < 4)
				return;
			
			graphics.clear();
			
			var bmp : BitmapData = new BitmapData(64, 16, true, 0);
			bmp.draw(new PoleImage);
			var matrix : Matrix = new Matrix();
			matrix.translate(-position, 0);
			graphics.lineStyle(); 
			graphics.beginBitmapFill(bmp, matrix, false);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x787878);
			graphics.drawRect(0, 0, 0, unscaledHeight);
			graphics.drawRect(unscaledWidth - 1, 0, 0, unscaledHeight);
		}
	}
}