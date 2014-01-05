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
package services
{
	/**
	 * Service to access Shackmessages. 
	 */
	public class MessageService extends Service
	{
		public function MessageService()
		{
			super("MessageService");
		}
		
		/**
		 * Gets a portion of the user's Shackmessages. 
		 * @param folder          inbox, outbox, or archive
		 * @param username        Shackname
		 * @param password        Password
		 * @param page            Page number.
		 * @param messagesPerPage Number of messages to list per page.
		 * @param result          (ResultEvent) Called upon completion.
		 * @param fault           (FaultEvent) Called upon failure.
		 */
		public function getMessages(folder : String, username : String, password : String, page : int, messagesPerPage : int, result : Function, fault : Function) : void
		{
			call(getObject().getMessages(folder, username, password, page, messagesPerPage), result, fault);
		}
		
		/**
		 * Sends a Shackmessage. 
		 * @param username
		 * @param password
		 * @param recipient
		 * @param subject
		 * @param body
		 * @param result    (ResultEvent) Called upon completion.
		 * @param fault     (FaultEvent) Called upon failure.
		 */
		public function sendMessage(username : String, password : String, recipient : String, subject : String, body : String, result : Function, fault : Function) : void
		{
			call(getObject().sendMessage(username, password, recipient, subject, body), result, fault);
		}
		
		/**
		 * Deletes a Shackmessage 
		 * @param username
		 * @param password
		 * @param id
		 * @param result    (ResultEvent) Called upon completion.
		 * @param fault     (FaultEvent) Called upon failure.
		 */
		public function deleteMessage(username : String, password : String, id : int, result : Function, fault : Function) : void
		{
			call(getObject().deleteMessage(username, password, id), result, fault);
		}
	
		/**
		 * Archives a Shackmessage 
		 * @param username
		 * @param password
		 * @param id
		 * @param result    (ResultEvent) Called upon completion.
		 * @param fault     (FaultEvent) Called upon failure.
		 */
		public function archiveMessage(username : String, password : String, id : int, result : Function, fault : Function) : void
		{
			call(getObject().archiveMessage(username, password, id), result, fault);
		}
		
		/**
		 * Gets the unread and total messages 
		 * @param username
		 * @param password
		 * @param result    (ResultEvent) Called upon completion.
		 * @param fault     (FaultEvent) Called upon failure.
		 */
		public function getMessageCount(username : String, password : String, result : Function, fault : Function) : void
		{
			call(getObject().getMessageCount(username, password), result, fault);
		}
		
		/**
		 * Mark a Shackmessage as read. 
		 * @param username
		 * @param password
		 * @param id
		 * @param result    (ResultEvent) Called upon completion.
		 * @param fault     (FaultEvent) Called upon failure.
		 */
		public function markMessageAsRead(username : String, password : String, id : int, result : Function, fault : Function) : void
		{
			call(getObject().markMessageAsRead(username, password, id), result, fault);
		}
	}	
}