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
package util
{
	import controllers.*;
	
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.*;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.core.WindowedApplication;
	
	/**
	 * Stores user-specified options which are saved to a file on disk. 
	 */
	[Bindable]
	public class OptionsStorage extends EventDispatcher
	{
		// Event types.
		public static const TAGGED_POSTS_CHANGE : String = "taggedPostsChange";
		
		// pinnedThreads flags.
		public static const NORMAL   : int = 0;
		public static const PIN      : int = 1;
		public static const COLLAPSE : int = 2;
		
		// postURL flags.
		public static const POST_SHACKNEWS   : int = 0;
		public static const POST_SHACKCHATTY : int = 1;
		
		// customFilters flags.
		public static const FILTER_SHACKNAME  : int = 0;
		public static const FILTER_KEYWORD    : int = 1;
		
		public static const FILTER_IN_THREADS : int = 0;
		public static const FILTER_IN_BOTH    : int = 1;
		public static const FILTER_IN_REPLIES : int = 2;		
		
		public static var username          : String  = "";
		public static var password          : String  = "";
		public static var invertedColors    : Boolean = false;
		public static var fontSize          : int     = 12;
		public static var left              : int     = -1;
		public static var top               : int     = -1;
		public static var width             : int     = 1200;
		public static var height            : int     = 900;
		public static var maximized         : Boolean = false;
		public static var vDivider          : int     = 200;
		public static var hDivider          : int     = 550;
		public static var filter            : Array   = [true, true, true, true, true];
		public static var chattyURL         : String  = ""; // Unused
		public static var gatewayURL        : String  = "https://winchatty.com/service/gateway";
		public static var customTitle       : String  = "";
		public static var fontSmoothingType : int     = 0;
		public static var viewedStories     : ArrayCollection = new ArrayCollection(); // {storyID: #, mostRecentID: #}
		public static var viewedThreads     : ArrayCollection = new ArrayCollection(); // {threadID: #, mostRecentID: #}
		public static var pinnedThreads     : ArrayCollection = new ArrayCollection(); // {storyID: #, threads: [{data: {...}, which: pin|collapse}]}
		public static var postURL           : int     = POST_SHACKNEWS;  
		public static var highlightUnread   : Boolean = true;
		public static var customFilters     : ArrayCollection = new ArrayCollection(); // {keyword: "", type: #, action: #}
		public static var keyBindings       : ArrayCollection = new ArrayCollection(); // {command: #, key1: #, key2: #/null}
		public static var taggedPosts       : ArrayCollection = new ArrayCollection(); // {id: #, preview: "", author: ""}
		public static var showToolbar       : Boolean = true;
		public static var showShacktags     : Boolean = true;
		
		public static var events            : EventDispatcher = new EventDispatcher();

		public static function setTaggedPosts(posts : ArrayCollection) : void
		{
			taggedPosts = posts;
			events.dispatchEvent(new Event(TAGGED_POSTS_CHANGE));
		}

		/**
		 * Populates all member variables with data from the WinChatty Settings file.
		 */
		public static function load() : void
		{
			var settingsFile : File = File.applicationStorageDirectory.resolvePath("WinChatty Settings");
			var stream       : FileStream;
			var storyID      : int;
			var mostRecentID : int;
			var count        : int;
			var i            : int;
			
			// Start off with the default key bindings.  These will get overwritten if 
			// the user's settings file contains custom key bindings.
			resetKeyBindings();

			try
			{
				stream = new FileStream();
				stream.open(settingsFile, FileMode.READ);
				username = stream.readUTF();
				password = stream.readUTF();
				invertedColors = stream.readBoolean();
				fontSize = stream.readInt();
				left = stream.readInt();
				top = stream.readInt();
				width = stream.readInt();
				height = stream.readInt();
				maximized = stream.readBoolean();
				vDivider = stream.readInt();
				hDivider = stream.readInt();

				count = stream.readInt();
				taggedPosts.removeAll();
				for (i = 0; i < count; i++)
					taggedPosts.addItem(stream.readObject());
					
				// The "repliedThreads" is no longer used.
				count = stream.readInt();
				for (i = 0; i < count; i++)
					stream.readObject();
					
				for (i = 0; i < 5; i++)
					filter[i] = stream.readBoolean();
					
				stream.readBoolean(); // "embedYouTube" is no longer used. (v3.0)
				
				// Version 1.4
				stream.readUTF(); // "chattyURL" is no longer used. (v3.0)
				
				// Version 2.0
				customTitle = stream.readUTF();
				
				// Version 2.1
				stream.readInt(); // Used to be fontSmoothingType; no longer used as of 3.1
				
				count = stream.readInt();
				viewedStories.removeAll();
				for (i = 0; i < count; i++)
				{
					storyID      = stream.readInt();
					mostRecentID = stream.readInt();
					viewedStories.addItem({storyID: storyID, mostRecentID: mostRecentID});
				}
				
				count = stream.readInt();
				viewedThreads.removeAll();
				for (i = 0; i < count; i++)
				{
					storyID      = stream.readInt();
					mostRecentID = stream.readInt();
					viewedThreads.addItem({threadID: storyID, mostRecentID: mostRecentID});
				}
				
				pinnedThreads.removeAll();
				pinnedThreads = stream.readObject() as ArrayCollection;
				
				postURL = stream.readInt();
				highlightUnread = stream.readBoolean();

				// Version 3.0
				customFilters = stream.readObject() as ArrayCollection;
				keyBindings = stream.readObject() as ArrayCollection;
				stream.readUTF(); // Used to be gateway; no longer used as of 3.1

				stream.close();
			}
			catch (error : Error)
			{
			}
		}

		/**
		 * Saves contents of all member variables to the WinChatty Settings file.
		 */
		public static function save() : void
		{
			var settingsFile : File = File.applicationStorageDirectory.resolvePath("WinChatty Settings");
			var stream : FileStream;
			var obj : Object;
			var i : int;
			var str : String;

			try
			{
				stream = new FileStream();
				stream.open(settingsFile, FileMode.WRITE);
			}
			catch (error : Error)
			{
				return;
			}
			
			try
			{
				stream.writeUTF(username);
				stream.writeUTF(password);
				stream.writeBoolean(invertedColors);
				stream.writeInt(fontSize);
				stream.writeInt(left);
				stream.writeInt(top);
				stream.writeInt(width);
				stream.writeInt(height);
				stream.writeBoolean(maximized);
				stream.writeInt(vDivider);
				stream.writeInt(hDivider);

				stream.writeInt(taggedPosts.length);
				for each (obj in taggedPosts)
					stream.writeObject(obj);

				// Unused: repliedThreads.
				stream.writeInt(0);
					
				for (i = 0; i < 5; i++)
					stream.writeBoolean(filter[i]);
					
				stream.writeBoolean(false); // Unused: embedYouTube
				
				// Version 1.4
				stream.writeUTF(""); // Unused: chattyURL
				
				// Version 2.0
				stream.writeUTF(customTitle);
				
				// Version 2.1
				stream.writeInt(fontSmoothingType);
				
				while (viewedStories.length > 25)
					viewedStories.removeItemAt(0);

				while (viewedThreads.length > 250)
					viewedThreads.removeItemAt(0);

				while (pinnedThreads.length > 25)
					pinnedThreads.removeItemAt(0);
				
				stream.writeInt(viewedStories.length);
				for each (obj in viewedStories)
				{
					stream.writeInt(obj.storyID);
					stream.writeInt(obj.mostRecentID);
				}

				stream.writeInt(viewedThreads.length);
				for each (obj in viewedThreads)
				{
					stream.writeInt(obj.threadID);
					stream.writeInt(obj.mostRecentID);
				}
				
				stream.writeObject(pinnedThreads);

				stream.writeInt(postURL);
				stream.writeBoolean(highlightUnread);
				
				// Version 3.0
				stream.writeObject(customFilters);
				stream.writeObject(keyBindings);
				stream.writeUTF(gatewayURL);
			}
			catch (error : Error)
			{
				// Will use defaults for remaining values.
			}
			
			stream.close();
		}
		
		/**
		 * Determines whether a post has been bookmarked.
		 * @param id Post ID
		 * @return True if bookmarked, false otherwise.
		 */
		public static function isPostTagged(id : int) : Boolean
		{
			var taggedPost : Object;
			
			for each (taggedPost in taggedPosts)
			{
				if (taggedPost.id == id)
					return true;
			}
			
			return false;
		}
		
		/**
		 * Returns the thread ID that was the most recent when we last refreshed the specified story.
		 * @param storyID Story ID.
		 * @return Thread ID.
		 */
		public static function mostRecentThreadID(storyID : int) : int
		{
			var viewedStory : Object;
			
			for each (viewedStory in viewedStories)
			{
				if (viewedStory.storyID == storyID)
					return viewedStory.mostRecentID;
			}
			
			return 0;
		}
		
		/**
		 * Returns the post ID that was the most recent when we last refreshed the specified thread.
		 * @param threadID Thread ID.
		 * @return Post ID.
		 */
		public static function mostRecentPostID(threadID : int) : int
		{
			var viewedThread : Object;
			
			for each (viewedThread in viewedThreads)
			{
				if (viewedThread.threadID == threadID)
					return viewedThread.mostRecentID;
			}
			
			return 0;
		}
		
		/**
		 * Updates the most recent thread for the specified story.
		 * @param storyID      Story ID.
		 * @param mostRecentID Thread ID.
		 */
		public static function touchStory(storyID : int, mostRecentID : int) : void
		{
			var viewedStory : Object;
			
			for each (viewedStory in viewedStories)
			{
				if (viewedStory.storyID == storyID)
				{
					if (viewedStory.mostRecentID < mostRecentID)
					{
						viewedStory.mostRecentID = mostRecentID;
						save();
					}
					return;
				}
			}
			
			viewedStories.addItem({storyID: storyID, mostRecentID: mostRecentID});

			while (viewedStories.length > 25)
				viewedStories.removeItemAt(0);
				
			save();
		}
		
		/**
		 * Updates the most recent post for the specified thread.
		 * @param threadID     Thread ID.
		 * @param mostRecentID Post ID.
		 */
		public static function touchThread(threadID : int, mostRecentID : int) : void
		{
			var viewedThread : Object;
			
			for each (viewedThread in viewedThreads)
			{
				if (viewedThread.threadID == threadID)
				{
					if (viewedThread.mostRecentID < mostRecentID)
					{
						viewedThread.mostRecentID = mostRecentID;
						save();
					}
					return;				
				}
			}
			
			viewedThreads.addItem({threadID: threadID, mostRecentID: mostRecentID});

			while (viewedThreads.length > 250)
				viewedThreads.removeItemAt(0);
				
			save();
		}
		
		/**
		 * Either pins or collapses the specified thread.
		 * @param storyID    Story ID.
		 * @param threadData Thread record, so we can display the author/preview/etc. without roundtripping to the server.
		 * @param which      normal, pin, or collapse.
		 */
		public static function pinCollapseThread(storyID : int, threadData : Object, which : int) : void
		{
			var story       : Object  = null;
			var storyFound  : Boolean = false;
			var thread      : Object  = null;
			var threadFound : Boolean = false;
			var threads     : ArrayCollection = null;
			
			for each (story in pinnedThreads)
			{
				if (story.storyID == storyID)
				{
					storyFound = true;
					break;
				}
			}
			
			if (storyFound == false)
			{
				story = {storyID: storyID, threads: new ArrayCollection()};
				pinnedThreads.addItem(story);
			}
			
			threads = story.threads as ArrayCollection;
			
			for each (thread in threads)
			{
				if (thread.data.id == threadData.id)
				{
					threadFound = true;
					break;
				}
			}
			
			if (threadFound == false)
			{
				thread = {data: threadData, which: which};
				threads.addItem(thread);
			}
			else
			{
				if (which == OptionsStorage.NORMAL)
				{
					threads.removeItemAt(threads.getItemIndex(thread));
				}
				else
				{
					thread.data  = threadData;
					thread.which = which;
				}
			}
			
			OptionsStorage.save();
		}
		
		/**
		 * Get a list of collapsed and pinned threads for a specified story.
		 * @param storyID Story ID.
		 * @return List of pinned thread data.
		 */
		public static function getPinnedThreads(storyID : int) : ArrayCollection
		{
			var story       : Object  = null;
			var storyFound  : Boolean = false;
			
			for each (story in pinnedThreads)
			{
				if (story.storyID == storyID)
				{
					storyFound = true;
					break;
				}
			}
			
			if (storyFound == false)
				return new ArrayCollection();
			else
				return story.threads as ArrayCollection;
		}
		
		/**
		 * Determine whether a given thread has been collapsed or pinned.
		 * @param storyID  Story ID.
		 * @param threadID Thread ID.
		 * @return normal, pin, or collapse.
		 * 
		 */
		public static function threadPinStatus(storyID : int, threadID : int) : int
		{
			var threads : ArrayCollection = getPinnedThreads(storyID);
			var thread  : Object = null;
			
			for each (thread in threads)
			{
				if (thread.data.id == threadID)
					return thread.which;	
			}
			
			return OptionsStorage.NORMAL;
		}
		
		/**
		 * Determines whether we're running on a Mac.
		 * @return True for Macs, false otherwise.
		 */
		private static function isMac() : Boolean
		{
			return flash.system.Capabilities.os.substring(0, 3) == "Mac";
		}
		
		/**
		 * Saves the position of the WinChatty window to the appropriate member variables. 
		 * @param window Main window.
		 */
		public static function saveWindowPosition(window : mx.core.WindowedApplication) : void
		{
			var nativeWindow : NativeWindow = window.nativeWindow;
			
			// Save the window position
			if (nativeWindow.displayState != flash.display.NativeWindowDisplayState.MINIMIZED)
			{
				left   = nativeWindow.x;
				top    = nativeWindow.y;
				width  = nativeWindow.width;
				height = nativeWindow.height;
			
				if (!isMac())
					maximized = (nativeWindow.displayState == flash.display.NativeWindowDisplayState.MAXIMIZED);
			}
		}

		/**
		 * Restores the position of the WinChatty window from the appropriate member variables.
		 * @param window Main window.
		 */
		public static function restoreWindowPosition(window : mx.core.WindowedApplication) : void
		{
			var nativeWindow : NativeWindow = window.nativeWindow;
			
			if (OptionsStorage.left != -1)
				nativeWindow.x = OptionsStorage.left;
			if (OptionsStorage.top != -1)
				nativeWindow.y = OptionsStorage.top;
			if (OptionsStorage.width != -1)
				nativeWindow.width = OptionsStorage.width;
			if (OptionsStorage.height != -1)
				nativeWindow.height = OptionsStorage.height;
			
			if (!isMac() && OptionsStorage.maximized)
				window.maximize();
		}
		
		/**
		 * Determines whether a category is shown or hidden based on the current filter.
		 * @param category Category string.
		 * @return True to display, false to hide.
		 */
		public static function isCategoryInFilter(category : String) : Boolean
		{
			switch (category)
			{
				case 'nws':
					return filter[0]; 
				case 'interesting':
				case 'informative':
					return filter[1]; 
				case 'offtopic':
				case 'tangent':
					return filter[2]; 
				case 'stupid':
					return filter[3]; 
				case 'political':
					return filter[4]; 
				case 'ontopic':
					return true;
			}
			
			return true;
		}
		
		/**
		 * Sorts the custom filters by type, keyword, and action. 
		 */
		public static function sortCustomFilters() : void
		{
			var i : int;
			var j : int;
			
			function swapNeeded(left : int, right : int) : Boolean
			{
				var a : Object = customFilters[left];
				var b : Object = customFilters[right];
				
				if (a.type > b.type)
					return true;
				else if (a.type < b.type)
					return false;

				if (a.keyword.toUpperCase() > b.keyword.toUpperCase())
					return true;
				else
					return false;

				if (a.action > b.action)
					return true;
				else if (a.action < b.action)
					return false;
			}
			
			function swap(left : int, right : int) : void
			{
				var temp : Object = customFilters[left];
				customFilters[left] = customFilters[right];
				customFilters[right] = temp;
			}
			
			for (i = 0; i < customFilters.length; i++)
				for (j = 0; j < customFilters.length - 1; j++)
					if (swapNeeded(j, j + 1))
						swap(j, j + 1);
		}
		
		/**
		 * Looks up the user's key binding for a particular command, if any. 
		 * @param command KeyboardController constant.
		 * @return null, or {command: #, key1: #, key2: #/null}
		 */
		public static function getKeyBinding(command : int) : Object
		{
			var binding : Object;
			
			for each (binding in keyBindings)
				if (binding.command == command)
					return binding;
			
			return null;
		}
		
		/**
		 * Delete all key bindings for a given command. 
		 * @param command KeyboardController constant.
		 */
		public static function removeKeyBinding(command : int) : void
		{
			var i : int;
			
			for (i = 0; i < keyBindings.length; i++)
			{
				if (keyBindings[i].command == command)
				{
					keyBindings.removeItemAt(i);
					return;
				}
			}
		}

		/**
		 * Unbinds a given keystroke from any key binding. 
		 * @param keystroke Keystroke mask.
		 */
		private static function unbindKey(key : uint) : void
		{
			var i : int;
			
			for (i = keyBindings.length - 1; i >= 0; i--)
			{
				if (keyBindings[i].key1 == key)
					keyBindings[i].key1 = null;
				if (keyBindings[i].key2 == key)
					keyBindings[i].key2 = null;
			}
		}
		
		/**
		 * Sets one of the two key bindings for a given command. 
		 * @param command KeyboardController constant.
		 * @param which   1 or 2
		 * @param key     Keystroke code.
		 */
		public static function setKeyBinding(command : int, which : int, key : uint) : void
		{
			unbindKey(key);
			
			var binding : Object = getKeyBinding(command);
			
			if (binding == null)
				binding = {command: command, key1: null, key2: null};
			
			if (which == 1)
				binding.key1 = key;
			else if (which == 2)
				binding.key2 = key;
			
			removeKeyBinding(command);
			keyBindings.addItem(binding);
			
			// Sort the key bindings by command number.
			Utility.sort(keyBindings,
				function lessThan(a : Object, b : Object) : Boolean
				{
					return a.command < b.command;
				});
		}
		
		/**
		 * Restores the default key bindings. 
		 */
		public static function resetKeyBindings() : void
		{
			keyBindings = new ArrayCollection([
				// F5, Ctrl+R
				{command: KeyboardController.REFRESH, key1: 116, key2: KeyboardController.MASK_CONTROL | 82},
				// A
				{command: KeyboardController.PREVIOUS_REPLY, key1: 65, key2: null}, 
				// Z
				{command: KeyboardController.NEXT_REPLY, key1: 90, key2: null},
				// 1
				{command: KeyboardController.FIRST_POST, key1: 49, key2: null},
				// Q
				{command: KeyboardController.NEWEST_REPLY, key1: 81, key2: null},
				// ~
				{command: KeyboardController.PARENT_POST, key1: 192, key2: null},
				// Ctrl+S
				{command: KeyboardController.REVEAL_SPOILERS, key1: KeyboardController.MASK_CONTROL | 83, key2: null}, 
				// S
				{command: KeyboardController.PREVIOUS_THREAD, key1: 83, key2: null}, 
				// X
				{command: KeyboardController.NEXT_THREAD, key1: 88, key2: null},
				// W
				{command: KeyboardController.FIRST_THREAD, key1: 50, key2: null},
				// 2
				{command: KeyboardController.LAST_THREAD, key1: 87, key2: null}, 
				// R
				{command: KeyboardController.REPLY, key1: 82, key2: null}, 
				// N
				{command: KeyboardController.NEW_THREAD, key1: 78, key2: null}, 
				// 5
				//{command: KeyboardController.REFRESH_THREAD, key1: 53, key2: null}
			]);

			// Sort the key bindings by command number.
			Utility.sort(keyBindings,
				function lessThan(a : Object, b : Object) : Boolean
				{
					return a.command < b.command;
				});			
		}
	}
}