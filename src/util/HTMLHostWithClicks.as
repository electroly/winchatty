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
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;

	public class HTMLHostWithClicks extends HTMLHost
	{
		import flash.net.*;
				
	    import flash.html.*;
	    import flash.display.StageScaleMode;
	    import flash.display.NativeWindow;
	    import flash.display.NativeWindowInitOptions;
	    import flash.geom.*;
	    import flash.display.*;
	    
	    public var text : String = null;
    		
		override public function HTMLHostWithClicks()
		{
			super(true);
		}
		
		override public function updateLocation(locationURL : String) : void
		{
			if (locationURL == "http://adobe.com/apollo")
				return;
			
			if (locationURL.indexOf("http://") == 0 || locationURL.indexOf("https://") == 0)
			{
				navigateToURL(new URLRequest(locationURL));
				htmlLoader.loadString(text == null ? '' : text);
			}
		}
		
		override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader
		{
			var loader : HTMLLoader = new HTMLLoaderWithClicks();
			loader.htmlHost = new HTMLHostWithClicks;
			return loader;
		}
	}
}