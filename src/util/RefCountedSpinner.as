/*------------------------------------------------------------------------------
 |
 |  WinChatty
 |  Copyright (C) 2009, Brian Luft.
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
 	/**
 	 * A modification to the Spinner control, giving it the ability to hide
 	 * and show itself based on a reference count.  In this way, multiple
 	 * asynchronous tasks can use the same spinner control, which continues
 	 * spinning until every task is complete. 
 	 */
 	public class RefCountedSpinner extends Spinner
 	{
 		/**
 		 * When this number is greater than 0, the spinner displays. 
 		 */
 		private var referenceCount : int = 0;
 		
 		/**
 		 * If referenceCount is 0, then the spinner is hidden.  If it is 
 		 * greater than 0, then the spinner is shown.
 		 */
 		private function showOrHide() : void
 		{
 			if (referenceCount <= 0)
 			{
 				stop();
 				visible = false;
 			}
 			else if (referenceCount > 0)
 			{
 				start();
 				visible = true;
 			}
 		}
 		
 		/**
 		 * Increases the referenceCount.  If the spinner isn't already visible,
 		 * it will be shown.
 		 */
 		public function push() : void
 		{
 			referenceCount++;
 			showOrHide();
 		}
 		
 		/**
 		 * Decreases the referenceCount.  If the spinner has only 1 reference
 		 * remaining, then it will be hidden.
 		 */
 		public function pop() : void
 		{
 			if (referenceCount <= 0)
 				return; // Whoops.
 			
 			referenceCount--;
 			showOrHide();
 		}
	}
}