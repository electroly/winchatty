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