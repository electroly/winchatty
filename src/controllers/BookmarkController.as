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