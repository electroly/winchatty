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
	import mx.collections.ArrayCollection;
	
	/**
	 * Provides some miscellaneous utility functions. 
	 */
	public class Utility
	{
		import flash.utils.ByteArray;
		
		/**
		 * Makes a deep copy of the given object.
		 * @param source Source object.
		 * @return Cloned object.	  
		 */
		public static function clone(source : Object) : Object 
		{
		    var copier : ByteArray = new ByteArray();
		    copier.writeObject(source);
		    copier.position = 0;
		    return(copier.readObject());
		}
		
		/**
		 * Replaces all instances of 'needle' in 'haystack' with 'replacement'. 
		 * @param haystack    String to search in.
		 * @param needle      String to search for.
		 * @param replacement Replaces 'needle'.
		 * @return Updated string.
		 */
		public static function replaceAll(haystack : String, needle : String, replacement : String) : String 
		{
			while (haystack.indexOf(needle) >= 0)
				haystack = haystack.replace(needle, replacement);
			return haystack;
		}
		
		/**
		 * Sorts an array based on a caller-provided compare function. 
		 * @param array List to sort.
		 * @param lessThan (left:Object, right:Object) Returns true if left < right.
		 */
		public static function sort(array : ArrayCollection, lessThan : Function) : void
		{
			function swap(left : int, right : int) : void
			{
				if (left != right)
				{
					var temp : Object = array[left];
					array[left] = array[right];
					array[right] = temp;
				}
			}
			
			function partition(left : int, right : int, pivotIndex : int) : int
			{
				var pivotValue : Object = array[pivotIndex];
				var storeIndex : int = left;
				var i : int;

				swap(pivotIndex, right);
				
				for (i = left; i < right; i++)
				{
					if (lessThan(array[i], pivotValue))
					{
						swap(i, storeIndex);
						storeIndex++;
					}
				}
				
				swap(storeIndex, right);
				return storeIndex;
			}
			
			function quicksort(left : int, right : int) : void
			{
				if (right > left)
				{
					if (right - left == 1)
					{
						if (lessThan(array[right], array[left]))
							swap(left, right);
					}
					else
					{
						var pivotIndex : int = (left + right) / 2;
						var pivotNewIndex : int = partition(left, right, pivotIndex);
						quicksort(left, pivotNewIndex - 1);
						quicksort(pivotNewIndex + 1, right);
					}
				}
			}

			quicksort(0, array.length - 1);			
		}
		
		/**
		 * Strips HTML tags from a string. 
		 * @param html HTML text.
		 * @return Stripped text.
		 */
		public static function stripTags(html : String) : String
		{
			var matchTags : RegExp = new RegExp('<[^>]*>', 'gi');
			return html.replace(matchTags, '');			
		}
		
		/**
		 * Converts all newlines to Windows-style \r\n. 
		 * @param text Raw text.
		 * @return Formatted text.
		 */
		public static function fixNewlines(text : String) : String
		{
			var replacements : Array = [
				{original: "\r\n", interim: "\uE000", replacement: "\r\n"},
				{original: "\r",   interim: "\uE001", replacement: "\r\n"},
				{original: "\n",   interim: "\uE002", replacement: "\r\n"},
			];
			
			var pair : Object
			
			for each (pair in replacements)
				while (text.indexOf(pair.original) >= 0)
					text = text.replace(pair.original, pair.interim);
			for each (pair in replacements)
				while (text.indexOf(pair.interim) >= 0)
					text = text.replace(pair.interim, pair.replacement);
			
			return text;
		}
		
		/**
		 * "Fixes" the code tag for a user's post by escaping any Shacktags that appear
		 * inside a code tag. 
		 * @param text Raw text.
		 * @return Quoted text.
		 */
		public static function quoteCodeShacktag(text : String) : String
		{
			var replacements : Array = [
				{original: "b[",  interim: "\uE000", replacement: "by{}y["},
				{original: "b{",  interim: "\uE001", replacement: "by[]y{"},
				{original: "g{",  interim: "\uE002", replacement: "gb[]b{"},
				{original: "l[",  interim: "\uE003", replacement: "lb{}b["},
				{original: "e[",  interim: "\uE004", replacement: "eb{}b["},
				{original: "y{",  interim: "\uE005", replacement: "yb[]b{"},
				{original: "n[",  interim: "\uE006", replacement: "nb{}b["},
				{original: "r{",  interim: "\uE007", replacement: "rb[]b{"},
				{original: "p[",  interim: "\uE008", replacement: "pb{}b["},
				{original: "o[",  interim: "\uE009", replacement: "ob{}b["},
				{original: "s[",  interim: "\uE00A", replacement: "sb{}b["},
				{original: "q[",  interim: "\uE00B", replacement: "qb{}b["},
				{original: "*[",  interim: "\uE00C", replacement: "*b{}b["},
				{original: "/[",  interim: "\uE00D", replacement: "/b{}b["},
				{original: "_[",  interim: "\uE00E", replacement: "_b{}b["},
				{original: "-[",  interim: "\uE00F", replacement: "-b{}b["},
				{original: "d[",  interim: "\uE010", replacement: "db{}b["},
				{original: "g[",  interim: "\uE011", replacement: "gb{}b["},
				{original: "i[",  interim: "\uE012", replacement: "ib{}b["},
				{original: "r[",  interim: "\uE013", replacement: "rb{}b["},
				{original: "u[",  interim: "\uE014", replacement: "ub{}b["},
				{original: "y[",  interim: "\uE015", replacement: "yb{}b["},
				{original: "f[",  interim: "\uE016", replacement: "fb{}b["},
				{original: "p{",  interim: "\uE017", replacement: "pb[]b{"},
				{original: "`[",  interim: "\uE018", replacement: "`b{}b["},
				{original: "#[",  interim: "\uE019", replacement: "#b{}b["},
				{original: "~[",  interim: "\uE01A", replacement: "~b{}b["},
				{original: "/{{", interim: "\uE01B", replacement: "/b[]b{{"},
			];
			
			var quoted : String = "";
			
			while (text.length > 0)
			{
				var index : int = text.indexOf("/{{"); 
				if (index < 0)
				{
					quoted += text;
					text = "";
					break;
				}
				else
				{
					quoted += text.substring(0, index + 3);
					text = text.substring(index + 3);
				}
			
				index = text.indexOf("}}/");
				if (index < 0)
				{
					index = text.length;
				}
				
				var pair : Object
				var code : String = text.substring(0, index);
				text = text.substring(index);
				
				for each (pair in replacements)
					while (code.indexOf(pair.original) >= 0)
						code = code.replace(pair.original, pair.interim);
				for each (pair in replacements)
					while (code.indexOf(pair.interim) >= 0)
						code = code.replace(pair.interim, pair.replacement);
				
				quoted += code;
			}
			
			return quoted;
		}
	}
}