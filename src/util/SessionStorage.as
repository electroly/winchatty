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
	import flash.events.EventDispatcher;
	
	/**
	 * Stores information that expires at the end of the session.  This data
	 * is not persisted between application launches. 
	 */
	[Bindable]
	public class SessionStorage
	{
		public static const MESSAGECOUNT_CHANGE : String = 'messageCountChange';
		
		/**
		 * Stores the saved view states for threads. 
		 */
		private static var threadStates : Object = new Object();
		
		/**
		 * Stores the last seen reply IDs for a given thread. 
		 */		
		private static var lastReplyIDs : Object = new Object();
		
		/**
		 * Stores the unread and total message counts. 
		 */
		private static var messageCount : Object = {unread: 0, total: 0};
		
		/**
		 * Changed notification events. 
		 */
		public static var events : EventDispatcher = new EventDispatcher();
		
		/**
		 * Gets the saved view state for a particular thread, if one exists. 
		 * @param threadID Thread ID.
		 * @return Thread state, or null.
		 */
		public static function getThreadState(threadID : int) : Object
		{
			if (threadStates[threadID] == null)
				return {scrollPosition: 0, selectedPostID: -1};
			else
				return threadStates[threadID];
		}
		
		/**
		 * Saves the view state for a particular thread. 
		 * @param threadID
		 * @param state
		 * 
		 */
		public static function setThreadState(threadID : int, scrollPosition : Number, selectedPostID : int) : void
		{
			threadStates[threadID] = {scrollPosition: scrollPosition, selectedPostID: selectedPostID};
		}
		
		/**
		 * Gets the last seen reply ID for a given thread. 
		 * @param threadID Thread ID.
		 * @return Last reply ID
		 */
		public static function getLastReplyID(threadID : int) : int
		{
			if (lastReplyIDs.hasOwnProperty(threadID))
				return lastReplyIDs[threadID];
			else
				return 0;
		}
		
		/**
		 * Sets the last seen reply ID for a given thread. 
		 * @param threadID    Thread ID
		 * @param lastReplyID Last reply ID
		 */
		public static function setLastReplyID(threadID : int, lastReplyID : int) : void
		{
			lastReplyIDs[threadID] = lastReplyID;
		}
		
		/**
		 * Get the unread and total message counts. 
		 * @return {unread: #, total: #}
		 */
		public static function getMessageCount() : Object
		{
			return messageCount;
		}
		
		/**
		 * Set the unread and total message counts. 
		 * @param unread Unread messages.
		 * @param total  Total messages.
		 */
		public static function setMessageCount(unread : int, total : int) : void
		{
			messageCount.unread = unread;
			messageCount.total = total;
			events.dispatchEvent(new Event(MESSAGECOUNT_CHANGE));
		}
	}
}