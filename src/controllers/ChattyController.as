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
	import flash.display.DisplayObject;
	
	import mx.collections.*;
	import mx.rpc.events.*;
	
	import services.*;
	
	import util.*;
	
	/**
	 * Glues the backend services to the frontend interface. 
	 */
	public class ChattyController
	{
		/**
		 * Used to communicate with the WinChatty server. 
		 */		
		private var chattyService : ChattyService = new ChattyService();

		/**
		 * Used to communicate with ThomW's LOL/INF database. 
		 */
		private var lolService : LOLService = new LOLService();
		
		/**
		 * Adds the appropriate CSS and structural tags to a raw snippet of HTML. 
		 * @param reply  Snippet of HTML.
		 * @param useCSS Whether to use CSS or <font>.
		 * @return HTML document suitable for display.
		 */
		public static function formatReplyHTML(reply : String, useCSS : Boolean, revealSpoilers : Boolean = false) : String
		{
			var pink : String = OptionsStorage.invertedColors ? '#f49ac1' : '#f4569a';
			
			var css : String = ''; 
			var html : String = reply;
			var spoilerCSS : String = '';
			
			if (!revealSpoilers)
				spoilerCSS = 'cursor: help; color: #383838; background-color: #383838;';

			if (!OptionsStorage.showShacktags && !useCSS)
			{
				// We will not use any formatting if Shacktags are turned off and this is a preview.
				for each (var str : String in ["<b>", "</b>", "<i>", "</i>"])
					html = Utility.replaceAll(html, str, "");
			}
			else if (useCSS)
			{
				var bodyCss : String = (OptionsStorage.invertedColors)
				                     ? "body { background: #222222; color: white; } a { color: #4444FF; }"
				                     : "";
				css = 
					'<html><meta http-equiv="Content-type" content="text/html; charset=utf-8">' + 
					"<style>" +
					"body { padding: 5px; }" + bodyCss + 
					"* { font-family: Tahoma; font-size: " + OptionsStorage.fontSize.toString() + "px; line-height: 150%; }" +
					"hr               { width: 100%; }" +
					".jt_red          { color: #f00; }" + 
					".jt_green        { color: #8dc63f; }" +
					".jt_pink         { color: " + pink + "; }" +
					".jt_olive        { color: olive; }" +
					".jt_fuchsia      { color: #c0ffc0; }" +
					".jt_yellow       { color: #c3a900; }" + /* ffde00 */
					".jt_blue         { color: #44aedf; }" +
					".jt_lime         { color: #90bf90; }" + /* c0ffc0 */
					".jt_orange       { color: #f7941c; }" +
					".jt_italic       { font-style: italic; }" +
					".jt_bold         { font-weight: bold; }" +
					".jt_underline    { text-decoration: underline; }" +
					".jt_strike       { text-decoration: line-through; }" +
					".jt_sample       { font-size: 80%; line-height: 10px; }" +
					".jt_quote        { font-family: serif; font-size: 110%; }" +
					".jt_spoiler      { " + spoilerCSS + " }" +
					".jt_spoiler_show { color: #f00; }" +
					".jt_codesmall    { font-family: monospace; }" +
					".jt_code         { white-space: pre; display: block; font-family: monospace; border-left: 1px solid #666; padding: 3px 0 3px 10px; margin: 5px 0 5px 10px; }" +
					".jt_wtf242       { color: #808080; }" +
					"</style>";
			}
			else
			{
				// For the sake of the DataGrid previews, we will convert as much of 
				// the CSS to old-school HTML as possible.  The Label control used
				// to render previews cannot use CSS.
				var colors : Array =
				[
					{name: 'jt_red',     color: '#ff0000'},
					{name: 'jt_green',   color: '#8dc63f'},
					{name: 'jt_pink',    color: pink},
					{name: 'jt_olive',   color: 'olive'},
					{name: 'jt_fuchsia', color: '#c0ffc0'},
					{name: 'jt_yellow',  color: '#c3a900'},
					{name: 'jt_blue',    color: '#44aedf'},
					{name: 'jt_lime',    color: '#90bf90'},
					{name: 'jt_orange',  color: '#f7941c'},
					{name: 'jt_wtf242',  color: '#808080'},
					{name: 'jt_strike',  color: '#909090'}
				];
				
				var styles : Array =
				[
					{name: 'jt_italic',    tag: '<i>'},
					{name: 'jt_bold',      tag: '<b>'},
					{name: 'jt_underline', tag: '<u>'},
				];
			
				for each (var color : Object in colors)
					html = Utility.replaceAll(html, '<span class="' + color.name + '">', '<font color="' + color.color + '">');
				for each (var style : Object in styles)
					html = Utility.replaceAll(html, '<span class="' + style.name + '">', '<font>' + style.tag);
				html = Utility.replaceAll(html, '</span>', '</font>');
			}
			
			return css + html;
		}

		/**
		 * Formats an error event into a user-friendly error string.
		 * @param error Error event returned from an RPC call, or a string.
		 * @return Verbose error string 
		 */
		public function buildErrorString(error : Object) : String
		{
			// Formats all the data in a FaultEvent into a user-readable string. 
			function formatFaultEvent(faultEvent : FaultEvent) : String
			{
				var str : String = error.fault.faultString;
				
				if (str == "error")
					str = "A mysterious error has occurred.";
				else if (str == "Send failed")
					str = "Is your modem plugged in?";
				
				str += ' (' + error.fault.faultCode + ')';

				return str;
			}	
					
			if (error is FaultEvent)
				return formatFaultEvent(error as FaultEvent);
			else if (error is String)
				return error as String;
			else
				return 'Unknown error.';
		}
		
		/**
		 * Loads a story and formats it for display. 
		 * @param storyID Story ID.
		 * @param page    Page number.
		 * @param result  Called when the story has been loaded.
		 * @param fault   Called when we fail to load the story.
		 */
		public function loadStory(storyID : int, page : int, result : Function, fault : Function) : void
		{
			chattyService.getStory(storyID, page,
				function(event : ResultEvent) : void
				{
					result(event.result);
				},
				fault);
		}
		
		/**
		 * Takes the raw story data returned from the server and adds pinned threads, as well
		 * as the 'participant' and 'recent' field of each thread. 
		 * @param data Raw story data.
		 * @return Story data massaged for display.
		 */
		public function augmentStory(data : Object) : ArrayCollection
		{
			var mostRecentID  : int;
			var pinnedThreads : ArrayCollection = null;
			var thread        : Object = null;
			var pinnedThread  : Object = null;
			var reply         : Object = null;
			var threads       : ArrayCollection = new ArrayCollection(Utility.clone(data.threads) as Array);
			
			mostRecentID = OptionsStorage.mostRecentThreadID(data.story_id);
			
			// The pinned threads will always appear at the top of the list, regardless
			// of the page we're on.
			pinnedThreads = OptionsStorage.getPinnedThreads(data.story_id);
			
			// Add the 'participant' and 'recent' fields to each thread.
			for each (thread in threads)
			{
				// Add the 'participant' field.
				thread.participant = false;
				
				for each (reply in thread.replies)
				{
					if ((reply.author as String).toUpperCase() == OptionsStorage.username.toUpperCase())
					{
						thread.participant = true;
						break;
					}
				}
				
				// Add the 'recent' field.
				thread.recent = (thread.last_reply_id > mostRecentID);
			}
			
			var filteredThreads : ArrayCollection = new ArrayCollection();
			for each (thread in threads)
			{
				var nuke : Boolean = false;
				thread.customFlag = -1;
				
				// If this thread is a pinned thread, then it is already in the list.
				// If it is a collapsed thread, then it shouldn't be here.
				for each (pinnedThread in pinnedThreads)
				{
					if (thread.id == pinnedThread.data.id)
					{
						pinnedThread.data.recent = thread.recent;
						pinnedThread.data.participant = thread.participant;
						pinnedThread.data.reply_count = thread.reply_count;
						nuke = true;
					}
				}
				
				// The user's own posts are whitelisted.
				if (thread.author.toUpperCase() != OptionsStorage.username.toUpperCase())
				{
					// Moderation flag filters
					if (!OptionsStorage.isCategoryInFilter(thread.category))
						nuke = true;
	
					// Custom filters
					for each (var filter : Object in OptionsStorage.customFilters)
					{
						var applyToThreads : Boolean =
							filter.applyTo == OptionsStorage.FILTER_IN_BOTH ||
							filter.applyTo == OptionsStorage.FILTER_IN_THREADS;
							
						var keywordMatch : Boolean =
							filter.type == OptionsStorage.FILTER_KEYWORD && 
							thread.body.toUpperCase().indexOf(filter.keyword.toUpperCase()) >= 0;
							
						var userMatch : Boolean = 
							filter.type == OptionsStorage.FILTER_SHACKNAME && 
							thread.author.toUpperCase() == filter.keyword.toUpperCase();
	
						if (applyToThreads && (keywordMatch || userMatch))
						{
							if (filter.action == 0)
								nuke = true;
							else
								thread.customFlag = filter.action;
							break;
						}
					}
				}
				
				if (!nuke)
					filteredThreads.addItem(thread);
			}
			
			for each (pinnedThread in pinnedThreads)
			{
				if (pinnedThread.which == OptionsStorage.PIN)
				{
					pinnedThread.data.pinned = true;
					filteredThreads.addItemAt(pinnedThread.data, 0);
				}
			}
			
			return filteredThreads;
		}
		
		/**
		 * Applies filtering to the thread replies. 
		 * @param data Raw thread data.
		 * @return ArrayCollection
		 */
		public function augmentThread(replies : Object, storyID : int, threadID : int) : ArrayCollection
		{
			var reply : Object;
			var augmentedReplies : ArrayCollection = new ArrayCollection();
			var inNukedSubthread : Boolean = false;
			var nukeDepth : int = -1;
			var lastReplyID : int = SessionStorage.getLastReplyID(threadID);
			
			for each (reply in replies as Array)
			{
				var nuke : Boolean = false;
				reply.customFlag = -1;
				
				if (inNukedSubthread && reply.depth > nukeDepth)
					continue;
				else
					inNukedSubthread = false;
				
				// Recent flag
				reply.recent = reply.id > lastReplyID;
				
				// The user's own posts are whitelisted.
				if (reply.author.toUpperCase() != OptionsStorage.username.toUpperCase())
				{
					// Moderation flag filters
					if (!OptionsStorage.isCategoryInFilter(reply.category))
						nuke = true;
	
					// Custom filters
					for each (var filter : Object in OptionsStorage.customFilters)
					{
						var body : String = reply.preview;
						var cachedObject : Object = PostCache.getPost(storyID, threadID, reply.id);
						
						if (cachedObject != null)
							body = cachedObject.body as String;
						
						var applyToReplies : Boolean =
							filter.applyTo == OptionsStorage.FILTER_IN_BOTH ||
							filter.applyTo == OptionsStorage.FILTER_IN_REPLIES;
	
						var keywordMatch : Boolean =
							filter.type == OptionsStorage.FILTER_KEYWORD && 
							body.toUpperCase().indexOf(filter.keyword.toUpperCase()) >= 0;
	
						var userMatch : Boolean =
							filter.type == OptionsStorage.FILTER_SHACKNAME && 
							reply.author.toUpperCase() == filter.keyword.toUpperCase();
	
						if (applyToReplies && (keywordMatch || userMatch))
						{
							if (filter.action == 0)
								nuke = true;
							else
								reply.customFlag = filter.action;
							break;
						}
					}
				}
				
				if (nuke)
				{
					// We will nuke the entire subthread.
					inNukedSubthread = true;
					nukeDepth = reply.depth;
				}
				else
				{
					augmentedReplies.addItem(reply);
				}
			}
			
			// Set the "order" flag on the 10 most recent replies.
			markMostRecent(augmentedReplies);

			// If more than 75% of the thread is marked "recent", then don't bother.  Just
			// mark the one most recent post as "recent".
			var recentCount : int = 0;
			for each (reply in augmentedReplies)
				if (reply.recent == true)
					recentCount++;

			if (recentCount > augmentedReplies.length * 3 / 4)
				for each (reply in augmentedReplies)
					reply.recent = (reply.order == 0);
			
			return augmentedReplies;
		}
		
		/**
		 * Set the "order" field for the most recently posted 9 posts.
		 * @param replies Array of replies, returned from augmentThread().
		 */
		private function markMostRecent(replies : ArrayCollection) : void
		{
			var postIDs : ArrayCollection = new ArrayCollection();
			var indexForID : Object = new Object();
			var i : int;
			var j : int = 0;
			
			for (i = 0; i < replies.length; i++)
			{
				postIDs.addItem(replies[i].id);
				indexForID[replies[i].id] = i; 
			}
			
			Utility.sort(postIDs,  
				function lessThan(left : Object, right : Object) : Boolean
				{
					return (left as String) < (right as String); 
				});
			
			for (i = postIDs.length - 1; i >= postIDs.length - 10 && i >= 0; i--)
				replies[indexForID[postIDs[i]]].order = j++;
		}
		
		/**
		 * Opens the Reply window for a new thread or reply.
		 * @param storyID    Story ID.
		 * @param threadID   Thread ID, or 0 for a new thread.
		 * @param parentID   0 for a new thread, or the ID of the parent post.
		 * @param parentText The text of the post being replied to.
		 * @param success    Called when the user has made the post.
		 */
		public function composeReply(parent : DisplayObject, storyID : int, threadID : int, parentID : int, parentText : String, success : Function) : void
		{
			if (parentID != 0 && threadID == 0)
				return;

			if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				new MessageBox().go(this, 'Enter a username and password first.');
				return;
			}
			
			new Reply().go(parent, storyID, parentID, threadID, parentText, success);
		}
		
		/**
		 * Either bookmarks or un-bookmarks a post.
		 * @param storyID Story ID
		 * @param reply   Reply record.  Need 'id', 'preview', and 'author' fields.
		 * @param success () Called upon success.
		 * @param failure () Called upon failure.
		 */
		public function toggleBookmark(storyID : int, reply : Object, success : Function, failure : Function) : void
		{
			if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				new MessageBox().go(this, 'Enter a username first.');
				failure();
				return;
			}
			
			var retVal : Boolean;
			
			if (OptionsStorage.isPostTagged(reply.id))
				retVal = BookmarkController.removeMark(reply.id, success);
			else
				retVal = BookmarkController.addMark(storyID, reply.id, reply.preview, reply.author, "", success);
			
			if (!retVal)
				failure();
		}

		/**
		 * Either LOLs or INFs a given post. 
		 * @param reply   Reply record.  Need 'id' field.
		 * @param tag     Either 'lol' or 'inf'.
		 * @param success () Called upon success.
		 * @param failure () Called upon failure.
		 */
		public function lolPost(reply : Object, tag : String, success : Function, failure : Function) : void
		{
			if (reply == null)
				return;
			else if (OptionsStorage.username == null || OptionsStorage.username.length == 0)
			{
				new MessageBox().go(this, 'Enter a username first.');
				failure();
				return;
			}
			
			lolService.tag(OptionsStorage.username, reply.id, tag, 
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
		 * Gets the menu data for the Stories drop-down.
		 * @param currentStory Story ID we're currently showing.
		 * @param success      (ArrayCollection) Called upon success.
		 * @param failure      () Called upon failure.
		 */
		public function getStoriesMenuData(currentStory : int, success : Function, failure : Function) : void
		{
			chattyService.getStories(
				function result(event : ResultEvent) : void
				{
					var data : ArrayCollection = new ArrayCollection();
					var story : Object;
					
					// Format the data into the normal ArrayCollection menu data provider format.
					for each (story in event.result as Array)
					{
						data.addItem({
							label: story.title,
							data:  story.story_id,
							icon:  story.story_id == currentStory.toString() ? Icons.Checkmark16 : ''
						});
					}
					
					success(data);
				},
				function fault(event : FaultEvent) : void
				{
					failure();
				});
		}
		
		/**
		 * Performs a comment search. 
		 * @param terms  Search terms.  Can be blank.
		 * @param author Post author.  Can be blank.
		 * @param parentAuthor Post's parent author.  Can be blank.
		 * @param category Moderation flag.  Can be blank.
		 * @param page    Page number
		 * @param success (Object) Called upon success.
		 * @param failure (String) Called upon failure.
		 */
		public function search(terms : String, author : String, parentAuthor : String, category : String, page : int, success : Function, failure : Function) : void
		{
			chattyService.search(terms, author, parentAuthor, category, page,
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
		 * Locates the page and thread in which we can find the specified post.
		 * @param postID  Post ID.
		 * @param storyID Story ID.
		 * @param success (int page, int threadID) Called upon success.
		 * @param failure () Called upon failure.
		 */
		public function locatePost(postID : int, storyID : int, success : Function, failure : Function) : void
		{
			chattyService.locatePost(postID, storyID,
				function result(event : ResultEvent) : void
				{
					if (event.result is Boolean)
						failure();
					else
						success(parseInt(event.result.page), parseInt(event.result.thread));
				},
				function fault(event : FaultEvent) : void
				{
					failure();
				});
		}
		
		/**
		 * Gets the full text of all replies to a thread.  
		 * @param threadID Thread ID.
		 * @param success  (Array replies) Called upon success.
		 * @param failure  () Called upon failure.
		 * 
		 */
		public function getThreadBodies(threadID : int, success : Function, failure : Function) : void
		{
			chattyService.getThreadBodies(threadID,
				function result(event : ResultEvent) : void
				{
					success(event.result.replies as Array);
				},
				function fault(event : FaultEvent) : void
				{
					new MessageBox().go(null, event.fault.faultString);
					failure();
				});
		}
		
		/**
		 * Gets the thread reply hierarchy and post previews.  
		 * @param threadID Thread ID.
		 * @param success  (Array replies) Called upon success.
		 * @param failure  () Called upon failure.
		 */
		public function getThreadTree(threadID : int, success : Function, failure : Function) : void
		{
			chattyService.getThreadTree(threadID,
				function result(event : ResultEvent) : void
				{
					success(event.result.replies as Array);
				},
				function fault(event : FaultEvent) : void
				{
					failure();
				});
		}
		
		/**
		 * Create a new thread or post a reply. 
		 * @param parentID Parent thread ID, or 0.
		 * @param storyID  Story ID
		 * @param body     Post body.
		 * @param success  () Called upon success.
		 * @param failure  (String) Called upon error.
		 */
		public function post(parentID : int, storyID : int, body : String, success : Function, failure : Function) : void
		{
			chattyService.post(OptionsStorage.username, OptionsStorage.password, parentID, storyID, body,
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
		 * Get the newest event ID.
		 * @param success  (int) Called upon success.
		 * @param failure  (String) Called upon error.
		 */
		public function getNewestEventId(success : Function, failure : Function) : void
		{
			chattyService.getNewestEventId(
				function result(event : ResultEvent) : void
				{
					success(event.result as int);
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		}
		
		/**
		 * Verify credentials.
		 * @param username Shackname.
		 * @param password Shack password.
		 * @param success  () Called upon success.
		 * @param failure  (String) Called upon error.
		 */
		public function verifyCredentials(username : String, password : String, success : Function, failure : Function) : void
		{
			chattyService.verifyCredentials(username, password, 
				function result(event : ResultEvent) : void
				{
					if ((event.result as String) == "valid")
						success();
					else
						failure("Invalid username or password.");
				},
				function fault(event : FaultEvent) : void
				{
					failure(event.fault.faultString);
				});
		}
	}
}