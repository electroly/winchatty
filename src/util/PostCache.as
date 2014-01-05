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
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Caches the body text of thread replies. 
	 */
	public class PostCache
	{
		/**
		 * Local file to save the cache to. 
		 */
		private static const FILENAME : String = "WinChatty Cache";
		
		/**
		 * Maximum number of stories we will hold in the cache before culling the old ones. 
		 */
		private static const MAX_STORIES : int = 20;
		
		/**
		 * Contains all of the cached stories.  The key is the story ID. 
		 */		
		private static var stories : Object = {};
		
		/**
		 * Load the cache from disk. 
		 */
		/*public static function load() : void
		{
			var file   : File = File.applicationStorageDirectory.resolvePath(FILENAME);
			var stream : FileStream = new FileStream();
			
			try
			{
				stream.open(file, FileMode.READ);
				stories = stream.readObject();
				stream.close();
			}
			catch (error : Error)
			{
				// Use an empty cache.
				stories = null;
			}
			
			if (stories == null)
				stories = {};
			else
				cull();
		}*/
		
		/**
		 * Save the cache to disk. 
		 */
		/*public static function save() : void
		{
			var file   : File = File.applicationStorageDirectory.resolvePath(FILENAME);
			var stream : FileStream = new FileStream();
			
			cull();
			stream.open(file, FileMode.WRITE);
			stream.writeObject(stories);
			stream.close();
		}*/
		
		/**
		 * Retrieve a post body from the cache.  Throws an exception if the post is not in the cache.
		 * @param storyID  Story ID.
		 * @param threadID Thread ID.
		 * @param postID   Post ID.
		 * @return Post body text.
		 */
		public static function getPost(storyID : int, threadID : int, postID : int) : Object
		{
			var threads : Object = stories[storyID];
			if (threads == null)
				return null;
				
			var posts : Object = threads[threadID];
			if (posts == null)
				return null;
				
			var text : Object = posts[postID];
			if (text == null)
				return null;
			
			return text;
		}
		
		/**
		 * Add a thread of posts to the cache.
		 * @param storyID  Story ID.
		 * @param threadID Thread ID.
		 * @param posts    Dictionary of posts (key = post ID, value = post body)
		 */
		public static function setThread(storyID : int, threadID : int, posts : Dictionary) : void
		{
			var threads : Object = stories[storyID];

			if (threads == null)
			{
				threads = {};
				stories[storyID] = threads;
			}
			
			threads[threadID] = posts;
		}
		
		/**
		 * Removes old stories from the cache if needed. 
		 */
		private static function cull() : void
		{
			var storyIDs : ArrayCollection = new ArrayCollection();
			var i : int;
			var j : int;

			// Read the list of story IDs into an array.			
			for (var key : Object in stories)
				storyIDs.addItem(key);
			
			// Sort the IDs numerically
			function swap(a : int, b : int) : void
			{
				var temp : int = storyIDs[a];
				storyIDs[a] = storyIDs[b];
				storyIDs[b] = temp;
			}

			for (i = 0; i < storyIDs.length; i++)
				for (j = 0; j < storyIDs.length - 1; j++)
					if (storyIDs[j] as int > storyIDs[j + 1] as int)
						swap(j, j + 1);
			
			if (storyIDs.length > MAX_STORIES)
			{
				for (i = 0; i < storyIDs.length - MAX_STORIES; i++)
					delete stories[storyIDs[i]];
			}
		}
		
		/**
		 * Get statistics on the cache size. 
		 * @return Object with keys "stories", "threads", "posts", and "bytes".
		 */
		public static function getStatistics() : Object
		{
			var o : Object = {stories: 0, threads: 0, posts: 0, bytes: 0};
			
			for each (var threads : Object in stories)
			{
				o.stories++;
				
				for each (var posts : Object in threads)
				{
					o.threads++;
					
					for each (var post : Object in posts)
						o.posts++;
				} 
			}
			
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeObject(stories);
			o.bytes = byteArray.length;
			
			return o;
		}
		
		/**
		 * Clear the cache. 
		 */
		public static function clearCache() : void
		{
			stories = {};
			
			//save();
		}
	}
}