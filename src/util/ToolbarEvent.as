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
	
	/**
	 * This is the event used by the Toolbar class. 
	 */
	public class ToolbarEvent extends Event 
	{
		/**
		 * Event Type: The user has clicked a toolbar button. 
		 */		
		public static const BUTTON_CLICK : String = 'buttonClick';
		
		/**
		 * Internal storage for the command property. 
		 */
		private var _command : String;
		
		/**
		 * Constructor. 
		 * @param type    Type constant.
		 * @param command Command string, taken from the data provider.
		 */
		public function ToolbarEvent(type : String, command : String)
		{
			super(type);
			_command = command;
		}
		
		/**
		 * Read-only property for the command string. 
		 * @return _command
		 */
		public function get command() : String
		{
			return _command;
		}
	}
}