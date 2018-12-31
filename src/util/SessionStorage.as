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