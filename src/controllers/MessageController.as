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