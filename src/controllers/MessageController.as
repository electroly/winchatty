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
package controllers
{
	import mx.collections.*;
	import mx.rpc.events.*;
	
	import services.*;
	
	import util.*;
	
	/**
	 * Manages the interaction between the MessageService and the WinChatty interface. 
	 */
	public class MessageController
	{
		public static const INBOX   : String = 'inbox';
		public static const SENT    : String = 'outbox';
		public static const ARCHIVE : String = 'archive'; 
		
		/**
		 * Used to communicate with the WinChatty.com server.  
		 */		
		private var messageService : MessageService = new MessageService();

		/**
		 * Gets the user's Shackmessages. 
		 * @param folder  Folder constant.
		 * @param page    Page number.
		 * @param success (Object) Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function getMessages(folder : String, page : int, success : Function, failure : Function) : void
		{
			if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				new MessageBox().go(this, 'Enter a username first.');
				failure();
				return;
			}
			
			messageService.getMessages(folder, OptionsStorage.username, OptionsStorage.password, page, 50,
				function result(event : ResultEvent) : void
				{
					success(event.result);
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		}
		
		/**
		 * Sends a Shackmessage.
		 * @param recipient
		 * @param subject
		 * @param body
		 * @param success () Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function sendMessage(recipient : String, subject : String, body : String, success : Function, failure : Function) : void
		{
			body = Utility.fixNewlines(Utility.quoteCodeShacktag(body));
			
			messageService.sendMessage(OptionsStorage.username, OptionsStorage.password, recipient, subject, body,
				function result(event : ResultEvent) : void
				{
					success();
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		} 	
		
		/**
		 * Deletes a Shackmessage. 
		 * @param id
		 * @param success () Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function deleteMessage(id : int, success : Function, failure : Function) : void
		{
			messageService.deleteMessage(OptionsStorage.username, OptionsStorage.password, id,
				function result(event : ResultEvent) : void
				{
					success();
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);	
				});
		}
		
		/**
		 * Archives a Shackmessage. 
		 * @param id
		 * @param success () Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function archiveMessage(id : int, success : Function, failure : Function) : void
		{
			messageService.archiveMessage(OptionsStorage.username, OptionsStorage.password, id,
				function result(event : ResultEvent) : void
				{
					success();
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);	
				});
		}
		
		/**
		 * Get the unread and total message count for the logged-in user. 
		 * @param success (Object) Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function getMessageCount(success : Function, failure : Function) : void
		{
			messageService.getMessageCount(OptionsStorage.username, OptionsStorage.password,
				function result(event : ResultEvent) : void
				{
					success(event.result);
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		}
		
		/**
		 * Mark a message as read 
		 * @param id Message ID
		 * @param success () Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function markMessageAsRead(id : int, success : Function, failure : Function) : void
		{
			messageService.markMessageAsRead(OptionsStorage.username, OptionsStorage.password, id,
				function result(event : ResultEvent) : void
				{
					success();
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		}
	}
}