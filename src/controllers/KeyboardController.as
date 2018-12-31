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
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	
	/**
	 * Deals with keyboard hotkeys. 
	 */
	public class KeyboardController
	{
		public static const REFRESH             : int =  10;
		//public static const REFRESH_THREAD      : int =  20;
		public static const PREVIOUS_REPLY      : int =  30;
		public static const NEXT_REPLY          : int =  40;
		public static const FIRST_POST          : int =  50;
		public static const NEWEST_REPLY        : int =  60;
		public static const PARENT_POST         : int =  61;
		public static const REVEAL_SPOILERS     : int =  62;
		public static const PREVIOUS_THREAD     : int =  70; 
		public static const NEXT_THREAD         : int =  80;
		public static const FIRST_THREAD        : int =  81;
		public static const LAST_THREAD         : int =  82;
		public static const PREVIOUS_PAGE       : int =  90;
		public static const NEXT_PAGE           : int = 100;
		//public static const OPEN_STORY          : int = 110;
		public static const NEW_THREAD          : int = 120;
		public static const REPLY               : int = 130;
		public static const PIN_THREAD          : int = 140; 
		public static const COLLAPSE_THREAD     : int = 150; 
		public static const MARK_LOL            : int = 160;
		public static const MARK_INF            : int = 170;
		public static const OPEN_LOL_PAGE       : int = 180;
		//public static const SET_BOOKMARK        : int = 190;
		//public static const OPEN_BOOKMARKS      : int = 200;
		public static const OPEN_SHACKMESSAGES  : int = 210;
		public static const OPEN_SEARCH         : int = 220;
		public static const SEARCH_POST_HISTORY : int = 230;
		public static const SEARCH_VANITY       : int = 240;
		public static const SEARCH_REPLIES      : int = 250;
		
		public static const MASK_ALT            : uint = 0x80000000;
		public static const MASK_CONTROL        : uint = 0x40000000;
		public static const MASK_COMMAND        : uint = 0x20000000;
		public static const MASK_SHIFT          : uint = 0x10000000;
		public static const MASK_ALL            : uint = 0xF0000000;
		
		/**
		 * keyCodeNames[Key Code] = "Name" 
		 */
		private static var keyCodeNames : Array = null; 
		
		/**
		 * List of commands and English names for them. 
		 */
		public static const keyboardCommands : Array = [
			{name: "Chatty Navigation",       command: null},
			{name: "Refresh all",             command: REFRESH},
			//{name: "Refresh thread",          command: REFRESH_THREAD},
			{name: "Compose reply",           command: REPLY},
			{name: "Compose new thread",      command: NEW_THREAD}, 
			//{name: "Read story text",         command: OPEN_STORY}, 

			{name: "Replies", command: null},
			{name: "Jump to previous reply",  command: PREVIOUS_REPLY}, 
			{name: "Jump to next reply",      command: NEXT_REPLY}, 
			{name: "Jump to OP",              command: FIRST_POST},
			{name: "Jump to newest reply",    command: NEWEST_REPLY},
			{name: "Jump to parent",          command: PARENT_POST},
			{name: "Reveal spoilers",         command: REVEAL_SPOILERS},

			{name: "Threads", command: null},
			{name: "Jump to previous thread", command: PREVIOUS_THREAD}, 
			{name: "Jump to next thread",     command: NEXT_THREAD}, 
			{name: "Jump to first thread",    command: FIRST_THREAD},
			{name: "Jump to last thread",     command: LAST_THREAD},
			{name: "Jump to previous page",   command: PREVIOUS_PAGE}, 
			{name: "Jump to next page",       command: NEXT_PAGE}, 

			{name: "Tagging and Flagging",    command: null},
			{name: "Pin thread",              command: PIN_THREAD}, 
			{name: "Collapse thread",         command: COLLAPSE_THREAD}, 
			{name: "Mark LOL",                command: MARK_LOL}, 
			{name: "Mark INF",                command: MARK_INF}, 
			{name: "Open LOL website",        command: OPEN_LOL_PAGE}, 
			//{name: "Bookmark",                command: SET_BOOKMARK}, 
			//{name: "Organize bookmarks",      command: OPEN_BOOKMARKS},

			{name: "Tools",                   command: null}, 
			{name: "Open Shackmessages",      command: OPEN_SHACKMESSAGES}, 
			{name: "Open comment search",     command: OPEN_SEARCH}, 
			{name: "Search post history",     command: SEARCH_POST_HISTORY}, 
			{name: "Search vanity",           command: SEARCH_VANITY}, 
			{name: "Search replies",          command: SEARCH_REPLIES}]; 
		
		/**
		 * Converts a KeyboardEvent into an integer. 
		 * @param event KeyboardEvent
		 * @return Integer representation of KeyboardEvent.
		 */
		public static function keystrokeFromEvent(event : KeyboardEvent) : uint
		{
			var mask : uint = event.keyCode;
			
			if ((mask & MASK_ALL) != 0)
				throw new Error("That keycode is unsupported."); 
			
			if (event.altKey)
				mask |= MASK_ALT;
			if (event.controlKey)
				mask |= MASK_CONTROL;
			if (event.commandKey)
				mask |= MASK_COMMAND;
			if (event.shiftKey)
				mask |= MASK_SHIFT;
			
			return mask;
		}
		
		/**
		 * Construct a user-readable name of the keystroke. 
		 * @param key Keystroke mask.
		 * @return String.
		 */
		public static function keystrokeName(key : uint) : String
		{
			var str : String = '';

            var isMac : Boolean = flash.system.Capabilities.os.indexOf("Mac") > -1;
			
			if (isMac)
			{
				if (key & MASK_SHIFT)
					str += '⇧';
				if (key & MASK_CONTROL)
					str += '^';
				if (key & MASK_ALT)
					str += '\u2325';
				if (key & MASK_COMMAND)
					str += '⌘';
			}
			else
			{
				if (key & MASK_CONTROL)
					str += 'Ctrl+';
				if (key & MASK_ALT)
					str += 'Alt+';
				if (key & MASK_SHIFT)
					str += 'Shift+';
			}
			str += keyCodeName(keyCodeFromKeystroke(key));
			return str;
		}
		
		/**
		 * Return the keyCode portion of a keystroke mask. 
		 * @param key Keystroke mask.
		 * @return KeyCode portion.
		 */
		public static function keyCodeFromKeystroke(key : uint) : uint
		{
			return key & ~MASK_ALL;
		}
		
		/**
		 * Returns a user-readable string for a keyCode.  
		 * @param keyCode KeyCode
		 * @return String
		 */
		public static function keyCodeName(keyCode : uint) : String
		{
			if (keyCode > 255)
				throw new Error("Invalid key code");
			
			if (keyCodeNames == null)
			{
				keyCodeNames = new Array(223);
				keyCodeNames[8] = "Backspace";
				keyCodeNames[9] = "Tab";
				keyCodeNames[12] = "NumPad=";
				keyCodeNames[13] = "Enter";
				keyCodeNames[20] = "CapsLock";
				keyCodeNames[27] = "Esc";
				keyCodeNames[32] = "Space";
				keyCodeNames[33] = "PageUp";
				keyCodeNames[34] = "PageDown";
				keyCodeNames[35] = "End";
				keyCodeNames[36] = "Home";
				keyCodeNames[37] = "Left";
				keyCodeNames[38] = "Up";
				keyCodeNames[39] = "Right";
				keyCodeNames[40] = "Down";
				keyCodeNames[46] = "Del";
				keyCodeNames[48] = "0";
				keyCodeNames[49] = "1";
				keyCodeNames[50] = "2";
				keyCodeNames[51] = "3";
				keyCodeNames[52] = "4";
				keyCodeNames[53] = "5";
				keyCodeNames[54] = "6";
				keyCodeNames[55] = "7";
				keyCodeNames[56] = "8";
				keyCodeNames[57] = "9";
				keyCodeNames[65] = "A";
				keyCodeNames[66] = "B";
				keyCodeNames[67] = "C";
				keyCodeNames[68] = "D";
				keyCodeNames[69] = "E";
				keyCodeNames[70] = "F";
				keyCodeNames[71] = "G";
				keyCodeNames[72] = "H";
				keyCodeNames[73] = "I";
				keyCodeNames[74] = "J";
				keyCodeNames[75] = "K";
				keyCodeNames[76] = "L";
				keyCodeNames[77] = "M";
				keyCodeNames[78] = "N";
				keyCodeNames[79] = "O";
				keyCodeNames[80] = "P";
				keyCodeNames[81] = "Q";
				keyCodeNames[82] = "R";
				keyCodeNames[83] = "S";
				keyCodeNames[84] = "T";
				keyCodeNames[85] = "U";
				keyCodeNames[86] = "V";
				keyCodeNames[87] = "W";
				keyCodeNames[88] = "X";
				keyCodeNames[89] = "Y";
				keyCodeNames[90] = "Z";
				keyCodeNames[96] = "NumPad0";
				keyCodeNames[97] = "NumPad1";
				keyCodeNames[98] = "NumPad2";
				keyCodeNames[99] = "NumPad3";
				keyCodeNames[100] = "NumPad4";
				keyCodeNames[101] = "NumPad5";
				keyCodeNames[102] = "NumPad6";
				keyCodeNames[103] = "NumPad7";
				keyCodeNames[104] = "NumPad8";
				keyCodeNames[105] = "NumPad9";
				keyCodeNames[106] = "NumPad*";
				keyCodeNames[107] = "NumPad+";
				keyCodeNames[109] = "NumPad-";
				keyCodeNames[110] = "NumPad.";
				keyCodeNames[111] = "NumPad/";
				keyCodeNames[112] = "F1";
				keyCodeNames[113] = "F2";
				keyCodeNames[114] = "F3";
				keyCodeNames[115] = "F4";
				keyCodeNames[116] = "F5";
				keyCodeNames[117] = "F6";
				keyCodeNames[118] = "F7";
				keyCodeNames[119] = "F8";
				keyCodeNames[120] = "F9";
				keyCodeNames[121] = "F10";
				keyCodeNames[122] = "F11";
				keyCodeNames[123] = "F12";
				keyCodeNames[124] = "F13";
				keyCodeNames[125] = "F14";
				keyCodeNames[126] = "F15";
				keyCodeNames[127] = "F16";
				keyCodeNames[128] = "F17";
				keyCodeNames[129] = "F18";
				keyCodeNames[130] = "F19";
				keyCodeNames[144] = "NumLock";
				keyCodeNames[186] = ";";
				keyCodeNames[187] = "=";
				keyCodeNames[188] = ",";
				keyCodeNames[189] = "-";
				keyCodeNames[190] = ".";
				keyCodeNames[191] = "/";
				keyCodeNames[192] = "~";
				keyCodeNames[219] = "[";
				keyCodeNames[220] = "\\";
				keyCodeNames[221] = "]";
				keyCodeNames[222] = "'";
			}
			
			return keyCodeNames[keyCode];
		}
	}
}