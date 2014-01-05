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