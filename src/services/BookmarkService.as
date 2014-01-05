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
	 * Service for using the WinChatty.com centralized bookmark system, which
	 * stores a private list of each user's bookmarked posts.  
	 */
	public class BookmarkService extends Service
	{
		public function BookmarkService()
		{
			super("BookmarkService");
		}
		
		/**
		 * Gets an ordered list of bookmarked posts for a given user. 
		 * @param username Shackname.
		 * @param result   (ResultEvent) Called upon completion.
		 * @param fault    (FaultEvent) Called upon failure.
		 */
		public function getBookmarks(username : String, 
		                             result : Function, fault : Function) : void
		{
			call(getObject(true).getBookmarks(username), result, fault);
		}
		
		/**
		 * Adds a new bookmarked post to the list.
		 * Note that 'postID', 'preview', 'author', and 'flag' are not verified
		 * for accuracy, since we only ever use this data to show back to the
		 * user that originally added it.
		 * @param username Shackname.
		 * @param note     User's comment.  (Optional)
		 * @param storyID  Story number.
		 * @param postID   Post number.
		 * @param preview  A short preview of the post's body.
		 * @param author   The post author's Shackname.
		 * @param flag     Moderation flag (stupid, offtopic, etc.)
		 * @param result   (ResultEvent) Called upon completion.
		 * @param fault    (FaultEvent) Called upon failure.
		 */
		public function addBookmark(username : String, note : String, storyID : int, postID : int, preview : String, author : String, flag : String,
		                            result : Function, fault : Function) : void
		{
			call(getObject(true).addBookmark(username, note, storyID, postID, preview, author, flag), result, fault);
		}
		
		/**
		 * Deletes a bookmarked post from a user's list.
		 * @param username Shackname.
		 * @param postID   Post number to delete.
		 * @param result   (ResultEvent) Called upon completion.
		 * @param fault    (FaultEvent) Called upon failure.
		 * 
		 */
		public function deleteBookmark(username : String, postID : int,
		                               result : Function, fault : Function) : void
		{
			call(getObject(true).deleteBookmark(username, postID), result, fault);
		}
	}
}