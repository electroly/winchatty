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
	import mx.messaging.*;
	import mx.messaging.channels.*;
	import mx.rpc.*;
	import mx.rpc.remoting.*;
	
	import util.*;

	/**
	 * Base class for WinChatty.com services.  Wraps a RemoteObject which 
	 * communicates to the server using AMF. 
	 */
	public class Service
	{
		protected var className : String;
		
		/**
		 * Connects to the WinChatty.com gateway.  
		 * @param className Must match the PHP class name.
		 */
		public function Service(className : String) : void
		{
			this.className = className;
		}
		
		protected function getObject(forceWinChattyURL : Boolean = false) : RemoteObject
		{
			var url : String;
			var remoteObject : RemoteObject = new RemoteObject();

			remoteObject.source = className;
			remoteObject.destination = className;
            remoteObject.requestTimeout = 30;
			
			if (forceWinChattyURL)
				url = "http://winchatty.com/service/gateway";
			else
				url = OptionsStorage.gatewayURL;
			
            remoteObject.channelSet = new ChannelSet();
            remoteObject.channelSet.addChannel(new AMFChannel(null, url));
            return remoteObject;
		}
		
		/**
		 * Wraps a RemoteObject call and inserts the specified result and fault
		 * event handlers. 
		 * @param token  Return value from a RemoteObject call.
		 * @param result (ResultEvent) Called upon success.
		 * @param fault  (FaultEvent) Called upon failure.
		 */
		protected function call(token : AsyncToken, result : Function, fault : Function) : void
		{
			token.addResponder(new Responder(result, fault));
		}
	}
}