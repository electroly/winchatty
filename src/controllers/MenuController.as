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
	import flash.net.*;
	
	import mx.collections.*;
	import mx.core.WindowedApplication;
	
	import util.*;
	
	/**
	 * Manages the content and behavior of the WinChatty menu. 
	 */
	public class MenuController
	{
		/**
		 * Opens the Shackmessages window. 
		 * @param window Parent window.
		 */
		public static function showShackmessages(window : WindowedApplication) : void
		{
			if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				new MessageBox().go(window, 'Enter a username and password first.');
				return;
			}
			
			Singleton.instance(Shackmessages).go(window);
		}
		
		/**
		 * Gets the list of bookmark menu items to display.
		 * @return Array of menu items.
		 */
		public static function getBookmarkMenuItems() : ArrayCollection
		{
			var shackmarks : ArrayCollection = new ArrayCollection;
			var shackmark : Object;
			
			//shackmarks.addItem({label: "Organize...", data: "organize", icon: Icons.FolderFavorites16});
			
			for each (shackmark in OptionsStorage.taggedPosts)
			{
				shackmarks.addItem(
					{
						label: (shackmark.note != null && shackmark.note != "" ? shackmark.note + " | " : "") + shackmark.preview + " : " + shackmark.author,
						data: shackmark.id
					});
			}
			
			return shackmarks;
		}
		
		/**
		 * Gets the hierarchical list of menu items to display. 
		 * @return Array of menu items.
		 */
		public static function getMenuItems() : ArrayCollection
		{
			return new ArrayCollection(
				[
					{label: "Shackmessages...", data: "shackmessages", icon: Icons.Mail16},
					{label: "New Message...", data: "newshackmessage"},
					{type: "separator"},
					{label: "Comment Search...", data: "search", icon: Icons.Search16},
					{label: "Post History...", data:"posthistory"},
					{label: "Vanity Search...", data:"vanitysearch"},
					{label: "Replies...", data:"replies"},
					{type: "separator"},
					//{label: "Bookmarks", icon: Icons.Star16, children: MenuController.getBookmarkMenuItems()},
					//{label: "Organize Bookmarks...", data: "organize"},
					//{type: "separator"},
					{label: "LOLs and INFs...", data: "lol", icon: Icons.Tag16},
					{type: "separator"},
					{label: "Options...", data: "options"},
					{type: "separator"},
					{label: "Help", data: "legend"},
					{label: "About WinChatty...", data: "about"}
				]);
		}
		
		/**
		 * Gets the hierarchical list of search menu items to display. 
		 * @return Array of menu items.
		 */
		public static function getSearchMenuItems() : ArrayCollection
		{
			return new ArrayCollection(
				[
					{label: "Post History...", data:"posthistory"},
					{label: "Vanity Search...", data:"vanitysearch"},
					{label: "Replies...", data:"replies"},
				]);
		}
		
		/**
		 * Gets the list of possible tags (for ThomW's LOL script) 
		 * @return Array of menu items.
		 */
		public static function getTagMenuItems() : ArrayCollection
		{
			return new ArrayCollection(
				[
					{label: "LOL", data: "lol"},
					{label: "INF", data: "inf"},
					{label: "TAG", data: "tag"},
					{label: "UNF", data: "unf"},
					{label: "WTF", data: "wtf"},
					{label: "0WN", data: "0wn"},
					{label: "TTH", data: "tth"}
				]);
		}

		/**
		 * Responds to a menu item being clicked. 
		 * @param window  Parent window.
		 * @param key     Menu item that was clicked.
		 * @param repaint () Called to repaint the chatty and thread listboxes.
		 * @param reparse () Called to reparse the chatty and thread data.
		 * @param reload  () Called to refresh all elements of the display and reparse the chatty/thread data.
		 * @param jump    (int story, int page, int thread, int reply) Called to jump to a particular post. 
		 */
		public static function menuClick(window : WindowedApplication, key : String, repaint : Function, reparse : Function, reload : Function, jump : Function) : void
		{
			switch (key)
			{
				/*case 'login':
					Login.instance.go(window, 
						function() : void
						{
							// We highlight the threads and replies made by the logged-in user,
							// so we need to reparse that data.
							reparse();
							
							// We also need to refresh the Shackmarks.
							BookmarkController.downloadAll(repaint);
						});
					break;*/
				
				case 'options':
					new Options().go(window, reload); 
					break;	
				
				/*case 'organize':
					if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
					{
						new MessageBox().go(window, 'Enter a username first.');
						break;
					}
				
					Singleton.instance(Tags).go(window, reparse, jump); 
					break;*/
				
				case 'about':
					new About().go(window);
					break;
				
				case 'newshackmessage':
					new ComposeShackmessage().go(window, null, null, null,
						function() : void 
						{
						});
					break;
				
				case 'shackmessages':
					showShackmessages(window);
					break;
				
				case 'search':
					Singleton.instance(CommentSearch).go(window, null, null, null, 0, false, jump);
					break;
					
				case 'posthistory':
					if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
					{
						new MessageBox().go(window, 'Enter a username first.');
						return;
					}
					Singleton.instance(CommentSearch).go(window, '', OptionsStorage.username, '', 0, true, jump);
					break;

				case 'vanitysearch':
					if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
					{
						new MessageBox().go(window, 'Enter a username first.');
						return;
					}

					Singleton.instance(CommentSearch).go(window, OptionsStorage.username, '', '', 0, true, jump);
					break;
					
				case 'replies':
					if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
					{
						new MessageBox().go(window, 'Enter a username first.');
						return;
					}

					Singleton.instance(CommentSearch).go(window, '', '', OptionsStorage.username, 0, true, jump);
					break;
					
				case 'lol':
					if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
						navigateToURL(new URLRequest("http://www.lmnopc.com/greasemonkey/shacklol/"));
					else
						navigateToURL(new URLRequest("http://www.lmnopc.com/greasemonkey/shacklol/user.php?user=" + OptionsStorage.username));
					break;
				
				case 'legend':
					new Legend().go(window);
					break;
				
				default:
					// Search through the bookmarks to find this record.
					var bookmark : Object;
					for each (bookmark in OptionsStorage.taggedPosts)
					{
						if (bookmark.id.toString() == key)
						{
							new Locating().go(bookmark.id, bookmark.story_id, window,
								jump, 
								function failure() : void
								{
									new MessageBox().go(window, "Unable to locate the post.");
								});
							break;							
						}
					}
					break;	
			}
		}
	}
}