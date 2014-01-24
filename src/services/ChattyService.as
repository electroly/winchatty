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
	 * Service for reading and posting Shacknews comments. 
	 */
	public class ChattyService extends Service
	{
		public function ChattyService()
		{
			super("ChattyService");
		}
		
		/**
		 * Gets a list of recent stories and their IDs. 
		 * @param result (ResultEvent) Called upon completion.
		 * @param fault  (FaultEvent) Called upon failure.
		 */
		public function getStories(result : Function, fault : Function) : void
		{
			call(getObject().getStories(), result, fault);
		}
		
		/**
		 * Gets the story text, threads, and all thread replies for a given story. 
		 * @param storyID Story ID.
		 * @param page    Page number.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function getStory(storyID : int, page : int, result : Function, fault : Function) : void
		{
			call(getObject().getStory(storyID, page), result, fault);
		}
		
		/**
		 * Performs a comment search. 
		 * @param terms  Search terms.  Can be blank.
		 * @param author Post author.  Can be blank.
		 * @param parentAuthor Post's parent author.  Can be blank.
		 * @param category Moderation flag.  Can be blank.
		 * @param page   Page number.
		 * @param result (ResultEvent) Called upon completion.
		 * @param fault  (FaultEvent) Called upon failure.
		 */
		public function search(terms : String, author : String, parentAuthor : String, category : String, page : int, result : Function, fault : Function) : void
		{
			call(getObject(true).search(terms, author, parentAuthor, category, page), result, fault);
		}
		
		/**
		 * Locates the page and thread in which we can find the specified post.
		 * @param postID  Post ID.
		 * @param storyID Story ID.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function locatePost(postID : int, storyID : int, result : Function, fault : Function) : void
		{
			call(getObject().locatePost(postID, storyID), result, fault);
		}
		
		/**
		 * Get the full text of all replies to a thread.
		 * @param threadID Thread ID.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function getThreadBodies(threadID : int, result : Function, fault : Function) : void
		{
			call(getObject().getThreadBodies(threadID), result, fault);
		}
		
		/**
		 * Get the thread reply hierarchy and post previews. 
		 * @param threadID Thread ID.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function getThreadTree(threadID : int, result : Function, fault : Function) : void
		{
			call(getObject().getThreadTree(threadID), result, fault);
		}
		
		/**
		 * Get the newest event ID. 
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function getNewestEventId(result : Function, fault : Function) : void
		{
			call(getObject().getNewestEventId(), result, fault);
		}
		
		/**
		 * Verify credentials. 
		 * @param username Shackname.
		 * @param password Shack password.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function verifyCredentials(username : String, password : String, result : Function, fault : Function) : void
		{
			call(getObject().verifyCredentials(username, password), result, fault);
		}
		
		/**
		 * Create a new thread or post a reply. 
		 * @param username Shackname.
		 * @param password Shack password.
		 * @param parentID Parent thread ID, or 0.
		 * @param storyID  Story ID
		 * @param body     Post body.
		 * @param result  (ResultEvent) Called upon completion.
		 * @param fault   (FaultEvent) Called upon failure.
		 */
		public function post(username : String, password : String, parentID : int, storyID : int, body : String, result : Function, fault : Function) : void
		{
			call(getObject().post(username, password, parentID, storyID, body), result, fault);
		}
	}
}