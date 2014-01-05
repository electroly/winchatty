/*------------------------------------------------------------------------------
 |
 |  WinChatty
 |  Copyright (C) 2010, Brian Luft.
 |
 |  This program is free software; you can redistribute it and/or modify
 |  it under the terms of the GNU General Public License as published by
 |  the Free Software Foundation; either version 2 of the License, or
 |  (at your option) any later version.
 |
 |  This program is distributed in the hope that it will be useful,
 |  but WITHOUT ANY WARRANTY; without even the implied warranty of
 |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 |  GNU General Public License for more details.
 |
 |  You should have received a copy of the GNU General Public License along
 |  with this program; if not, write to the Free Software Foundation, Inc.,
 |  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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