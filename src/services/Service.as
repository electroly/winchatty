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
		
		private var remoteObject : RemoteObject = null;
		
		/**
		 * Connects to the WinChatty.com gateway.  
		 * @param className Must match the PHP class name.
		 */
		public function Service(className : String) : void
		{
			this.className = className;
			remoteObject = new RemoteObject();
			remoteObject.source = className;
			remoteObject.destination = className;
        	remoteObject.requestTimeout = 30;
			var url : String = "https://winchatty.com/service/gateway";
        	remoteObject.channelSet = new ChannelSet();
        	remoteObject.channelSet.addChannel(new AMFChannel(null, url));
		}
		
		protected function getObject(forceWinChattyURL : Boolean = false) : RemoteObject
		{
            return remoteObject;
		}
		
		/**
		 * Wraps a RemoteObject call and inserts the specified result and fault
		 * event handlers. 
		 * @param token  Return value from a RemoteObject call.
		 * @param result (ResultEvent) Called upon success.
		 * @param fault  (FaultEvent) Called upon failure.
		 */
		protected function call(token : AsyncToken, result : Function, fault : Function) : AsyncToken
		{
			token.addResponder(new Responder(result, fault));
			return token;
		}
	}
}