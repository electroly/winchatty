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
	 * Service to access ThomW's LOL/INF database. 
	 */
	public class LOLService extends Service
	{
		public function LOLService()
		{
			super("LOLService");
		}
		
		/**
		 * LOLs or INFs a specified post. 
		 * @param username Shackname.
		 * @param postID   Post ID.
		 * @param tag      "lol" or "inf"
		 * @param result   Called upon success.  Result value is Boolean success flag.
		 * @param fault    Called upon failure.
		 */
		public function tag(username : String, postID : int, tag : String, result : Function, fault : Function) : void
		{
			call(getObject().tag(username, postID, tag), result, fault);
		}
	}
}