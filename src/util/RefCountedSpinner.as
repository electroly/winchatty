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