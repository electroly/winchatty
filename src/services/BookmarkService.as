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