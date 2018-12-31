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
	import flash.events.Event;
	import flash.utils.Dictionary;
	import mx.core.Window;
	import mx.events.FlexEvent;
	
	/**
	 * Automates the management of a singleton window. 
	 */
	public class Singleton
	{
		/**
		 * A mapping of Class objects to instance references.
		 */
		private static var instances : Dictionary = null;
		
		/**
		 * Determine whether the singleton window of a given class is currently displayed. 
		 * @param type Window class.
		 * @return True/false.
		 */
		public static function isOpen(type : Class) : Boolean
		{
			if (instances[type] == null)
				return false;
			
			return instances[type].isOpen;
		}
		
		/**
		 * Create or retrieve the singleton instance of the specified class. 
		 * @param type Window class.
		 * @return Instance reference.
		 */
		public static function instance(type : Class) : Object
		{
			if (instances == null)
				instances = new Dictionary();
			
			if (instances[type] == null)
			{
				instances[type] = 
					{
						instance: new type(), 
						isOpen:   false
					};
				
				if (instances[type].instance is Window)
				{
					var wnd : Window = instances[type].instance as Window;
					
					// Remove the instance from the dictionary when it closes, because
					// windows are destroyed when they close.
					wnd.addEventListener(Event.CLOSE,
						function(event : Event) : void
						{
							instances[type] = null;
						});
					
					// Update the isOpen field when the window opens.
					wnd.addEventListener(FlexEvent.CREATION_COMPLETE,
						function(event : FlexEvent) : void
						{
							instances[type].isOpen = true;
						});
				}
			}
			
			return instances[type].instance;
		}
	}
}