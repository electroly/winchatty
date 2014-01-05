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