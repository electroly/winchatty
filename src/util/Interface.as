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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.Window;
	import mx.events.AIREvent;
	
	/**
	 * Contains user interface helper functions. 
	 */
	public class Interface
	{
		/**
		 * Contains a mapping of children => parents, for makeWindowModal().
		 */
		private static var parentOf       : Dictionary = null;
		
		/**
		 * Contains a mapping of parents => children, for makeWindowModal().
		 */
		private static var childOf        : Dictionary = null;
		
		/**
		 * Whether to disable activate event handling temporarily, for makeWindowModal().
		 */
		private static var ignoreActivate : Boolean    = false;
		
		/**
		 * Centers a window on-screen in the middle of its praent.
		 * @param wnd    Window to center.
		 * @param parent Parent window.
		 */
		public static function centerWindowInParent(wnd : Window, parent : DisplayObject) : void
		{
			wnd.nativeWindow.x = (parent.stage.nativeWindow.width - wnd.nativeWindow.width) / 2 
			                     + parent.stage.nativeWindow.x;
			wnd.nativeWindow.y = (parent.stage.nativeWindow.height - wnd.nativeWindow.height) / 2 
			                     + parent.stage.nativeWindow.y;

		}
		
		/**
		 * Forces a window to stay on top of its parent.
		 * @param child  Child window.
		 * @param parent Parent window.
		 */
		public static function makeWindowModal(child : Window, parent : Object) : void
		{
			///////////////////////////////////////////////////////////////////
			// This function is an attempt to fake modal dialog functionality
			// using non-modal windows.
			//
			// The "parent" argument should be a Window, but I begrudgingly 
			// changed it to Object so that the main WindowedApplication can be 
			// used as the parent.
			///////////////////////////////////////////////////////////////////
			
			// The parentOf dictionary maps children (keys) to their parents (values).
			// The childOf dictionary is the reverse.
			if (parentOf == null || childOf == null)
			{
				parentOf = new Dictionary();
				childOf  = new Dictionary();
			}
				
			parentOf[child] = parent;
			childOf[parent] = child;
			
			// When the modal dialog appears, the parent window is disabled.
			var disableCanvas : Canvas = new Canvas();
			disableCanvas.width = parent.width;
			disableCanvas.height = parent.height;
			disableCanvas.alpha = 0.3;
			disableCanvas.setStyle("backgroundColor", 0);
			parent.addChild(disableCanvas);
			
			// When the user clicks a parent dialog, we want to make sure the
			// entire hierarchy of modal dialogs is activated in the correct
			// order.  So we walk backwards in the hierarchy to find the
			// root window, and then walk forwards to activate each window.
			var parentActivateFunc : Function =
				function(event : Event) : void
				{
					if (ignoreActivate)
						return;

					event.preventDefault();
						
					// Go backwards in the hierarchy until we've found the modal
					// dialog that should be at the back.
					var wnd : Object = child;
					
					while (parentOf[wnd] != null)
						wnd = parentOf[wnd];
					
					// We don't want to recursively generate these activate events,
					// so disable this event while we're reactivating things.
					ignoreActivate = true;

					// Starting at this ancestor window, work our way to the
					// youngest child window.
					do
					{
						wnd.activate();
						wnd = childOf[wnd];
					} while (wnd != null);
										
					ignoreActivate = false;
				};
			parent.addEventListener(AIREvent.WINDOW_ACTIVATE, parentActivateFunc);
			
			// If the user attempts to close the parent window while the modal
			// dialog is open, we cancel the event.
			var parentClosingFunc : Function =
				function(event : Event) : void
				{
					event.preventDefault();
				};
			parent.addEventListener(Event.CLOSING, parentClosingFunc);

			// When the modal dialog closes, the parent window is re-enabled.
			// We also remove the events we added earlier.
			child.addEventListener(Event.CLOSING,
				function(event : Event) : void
				{
					parentOf[child] = null;
					childOf[parent] = null;
					parent.removeChild(disableCanvas);
					parent.removeEventListener(AIREvent.WINDOW_ACTIVATE, parentActivateFunc);
					parent.removeEventListener(Event.CLOSING, parentClosingFunc);
				});
		} 
		
		/**
		 * Force a UIComponent to repaint itself.
		 * @param control Control to repaint.
		 */
		public static function forceRepaint(control : mx.core.UIComponent) : void
		{
			// Ugh.  I really wish I knew a better way to do this.
			var origHeight : Number = control.percentHeight;
			control.height++;
			control.validateNow();
			control.percentHeight = origHeight;
			control.validateNow();
		}
		
		/**
		 * Get the name of the system UI font. 
		 * @return Font name string.
		 */
		public static function getInterfaceFont() : String
		{
			/*var fonts : Array = Font.enumerateFonts(true);
			var font : Font;
			
			var helvetica : Boolean = false;
			
			for each (font in fonts)
				if (font.fontName == "Helvetica")
					return "Helvetica";
			
			return "Arial";*/
			return "Tahoma";
		}
	}
}