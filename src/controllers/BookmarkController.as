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
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.*;
	
	import util.*;
	
	/**
	 * Manages the interaction between the BookmarkService and the WinChatty interface. 
	 */
	public class BookmarkController
	{
		/**
		 * Used to communicate with the WinChatty.com server.  
		 */		
		private static var bookmarkService : BookmarkService = new BookmarkService();
		
		/**
		 * Downloads a fresh copy of the bookmarks list. 
		 * @param callback Called when OptionsStorage.taggedPosts has been updated.
		 */
		public static function downloadAll(callback : Function) : void
		{
			if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				callback();
				return;
			}
		
			bookmarkService.getBookmarks(
				OptionsStorage.username,
				function(event : ResultEvent) : void
				{
					if (event.result is Array)
						OptionsStorage.setTaggedPosts(new ArrayCollection(event.result as Array));
						
					OptionsStorage.save();
					
					callback();
				},
				function(event : FaultEvent) : void
				{
					callback();
				});
		}
		
		/**
		 * Adds a new bookmark. 
		 * @param storyID  Story ID
		 * @param id       Post ID
		 * @param preview  Snippet of the body text
		 * @param author   Author's username
		 * @param note     This user's notes
		 * @param callback Called when the bookmark has been added.
		 * @return False on error.
		 */
		public static function addMark(storyID : int, id : int, preview : String, author : String, note : String, callback : Function) : Boolean
		{
			if (OptionsStorage.username.length == 0)
				return false;

			bookmarkService.addBookmark(
				OptionsStorage.username, note, storyID, id, preview, author, null,
				function(event : ResultEvent) : void
				{
					downloadAll(callback);
				},
				function(event : FaultEvent) : void
				{
					callback();
				});
			return true;
		}
		
		/**
		 * Deletes a bookmark.
		 * @param id       Post ID.
		 * @param callback Called when the bookmark has been deleted.
		 * @return False on error.
		 */
		public static function removeMark(id : int, callback : Function) : Boolean
		{
			if (OptionsStorage.username.length == 0)
				return false;
		
			bookmarkService.deleteBookmark(
				OptionsStorage.username, id,
				function(event : ResultEvent) : void
				{
					downloadAll(callback);
				},
				function(event : FaultEvent) : void
				{
					callback();
				});
			return true;
		}
	}
}