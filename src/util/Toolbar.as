/*------------------------------------------------------------------------------
 |
 |  WinChatty
 |  Copyright (C) 2010, Brian Luft.
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
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.text.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.core.UIComponent;
	import mx.events.*;
	import mx.styles.*;
	
	/*	Data provider must be an ArrayCollection where each element is:
		{
			name: <String>,
			largeIcon: <Class>,
			smallIcon: <Class>,
			label: <String>,
			enabled: <Boolean>
		}	*/
	
	[Style(name="backgroundGradientColor1", type="uint", format="Color", inherit="no")]
	[Style(name="backgroundGradientColor2", type="uint", format="Color", inherit="no")]
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	[Style(name="hoverBackgroundColor", type="uint", format="Color", inherit="no")]
	[Style(name="hoverBorderColor", type="uint", format="Color", inherit="no")]
	[Style(name="depressBackgroundColor", type="uint", format="Color", inherit="no")]
	[Style(name="depressBorderColor", type="uint", format="Color", inherit="no")]
	[Style(name="textColor", type="uint", format="Color", inherit="no")]
	[Style(name="disabledTextColor", type="uint", format="Color", inherit="no")]
	[Event(name="sizeChange", type="util.ToolbarEvent")]
	[Event(name="buttonClick", type="util.ToolbarEvent")]
	public class Toolbar extends UIComponent
	{
		// 
		//  Constants
		//
		
		public static const DESIREDHEIGHT_CHANGE : String = "desiredHeightChanged";
		
		/**
		 * Small 16x16 icons. 
		 */		
		public static const ICON_SMALL : int = 1
		
		/**
		 * Large 32x32 icons. 
		 */		
		public static const ICON_LARGE : int = 2;

		/**
		 * No text is displayed. 
		 */
		public static const TEXT_NONE : int = 0;
		
		/**
		 * Text is displayed to the right of each icon. 
		 */		
		public static const TEXT_RIGHT : int = 1;
		
		/**
		 * Text is displayed below each icon. 
		 */		
		public static const TEXT_BOTTOM : int = 2;

		// 
		//  Private Members
		//

		/**
		 * The user-provided toolbar button information. 
		 */
		private var _dataProvider : ArrayCollection = new ArrayCollection();
		
		/**
		 * The user-provided icon style. 
		 */
		private var _iconStyle : int = ICON_LARGE;
		
		/**
		 * The user-provided text style. 
		 */		
		private var _textStyle : int = TEXT_RIGHT;
		
		/**
		 * Our measured height. 
		 */
		private var _desiredHeight : int = 0;
		
		/**
		 * Precomputed button layouts. 
		 */
		private var _layouts : ArrayCollection = new ArrayCollection();
		
		/**
		 * Whether the mouse is currently inside our toolbar control. 
		 */		
		private var _mouseInControl : Boolean = false;
		
		/**
		 * Whether the mouse button is currently down. 
		 */		
		private var _mouseIsDown : Boolean = false;
		
		/**
		 * This is set to the selected toolbar button index when the user 
		 * depresses the mouse button.  We compare against this when the
		 * subsequent MouseUp event happens, to make sure it's still the
		 * same button. 
		 */
		private var _mouseDownButton : int = -1;
		
		/**
		 * Text fields used to display each button's text.
		 */
		private var _textFields : ArrayCollection = new ArrayCollection();
		
		/**
		 * The font used for the button text. 
		 */
		private static var _font : String = Interface.getInterfaceFont();
		
		/**
		 * The name used when saving the user's toolbar configuration. 
		 */
		private var _name : String = "";
		
		/**
		 * Context menu. 
		 */
		private var _menu : Menu = null; 
		
		/**
		 * The context menu contents. 
		 */		
		[Bindable] private var _menuProvider : ArrayCollection = new ArrayCollection(
			[
				{label: "Large icons", data: "icon_large"},
				{label: "Small icons", data: "icon_small"},
				{type: "separator"},
				{label: "Text on right", data: "text_right"},
				{label: "Text below", data: "text_bottom"},
				{label: "No text", data: "text_none"}
			]);

		// 
		//  Default Styles
		//
		private static var defaultsSet : Boolean = setDefaults(); 
		
		private static function setDefaults() : Boolean 
		{
			var style : CSSStyleDeclaration = StyleManager.getStyleDeclaration("Toolbar");
            if (!style)
                style = new CSSStyleDeclaration();
            
            style.defaultFactory = 
            	function() : void 
            	{
	        	    this.backgroundGradientColor1 = 0xF7F7F7;
	        	    this.backgroundGradientColor2 = 0xDEDFDE;
	        	    this.borderColor = 0xB7BABC;
	        	    this.hoverBackgroundColor = 0xD7E6F3;
	        	    this.hoverBorderColor = 0x7C9AC6;
	        	    this.depressBackgroundColor = 0xB6CDE3;
	        	    this.depressBorderColor = 0x4F80B0;
	        	    this.textColor = 0x000000;
	        	    this.disabledTextColor = 0x999999;
	        	    this.fontSize = 12;
	        	    this.fontFamily = _font;
	        	};
			StyleManager.setStyleDeclaration("Toolbar", style, true);      	
            return true;
        };		
		
		//
		//  Public Properties
		//
		
		public function get dataProvider() : ArrayCollection
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value : ArrayCollection) : void
		{
			_dataProvider = value;
		}
		
		public function get iconStyle() : int
		{
			return _iconStyle;
		}
		
		public function set iconStyle(style : int) : void
		{
			_iconStyle = style;
			saveSettings();
		}
		
		public function get textStyle() : int
		{
			return _textStyle;
		}
		
		public function set textStyle(style : int) : void
		{
			_textStyle = style;
			saveSettings();
		}
		
		[Bindable(event="desiredHeightChanged")]
		public function get desiredHeight() : Number 
		{
			return _desiredHeight;
		}
		
		public function get toolbarName() : String
		{
			return _name;
		}
		
		public function set toolbarName(value : String) : void
		{
			_name = value;
			loadSettings();
		}
		
		//
		//  Public Methods
		//
		
		/**
		 * Constructor. 
		 */
		public function Toolbar()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,  mouseMove);
			this.addEventListener(MouseEvent.MOUSE_DOWN,  mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,    mouseUp);
			this.addEventListener(MouseEvent.MOUSE_OVER,  mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,   mouseOut);
			this.addEventListener(MouseEvent.RIGHT_CLICK, rightClick);
			this.addEventListener(ResizeEvent.RESIZE,     resize);
		}
		
		/**
		 * Gets the bounding box for the requested button. 
		 * @param command Command string.
		 * @return Rectangle.
		 * 
		 */
		public function getButtonBounds(command : String) : Rectangle
		{
			var x : int = 0;
			var i : int;
			
			for (i = 0; i < _layouts.length; i++)
			{
				var layout : Object = _layouts[i];
				var data : Object = _dataProvider[i];
				
				if (data.command == command)
					return new Rectangle(x, 0, layout.w, layout.h);
				else
					x += layout.w;
			}
			
			return null;
		}
		
		/**
		 * Redraws the toolbar. 
		 */
		public function repaint() : void
		{
			updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * Re-reads the data provider and lays out the buttons. 
		 */		
		public function refresh() : void
		{
			var btnData : Object;
			var layout : Object;
			var i : int;
			
			// Lay out each of the buttons
			_layouts.removeAll();
			for each (btnData in _dataProvider)
				_layouts.addItem(layoutButton(btnData));
			
			// If there is a gap in the list (at most one), then figure out what 
			// its width should be.
			var totalWidth : Number = 0;
			
			for each (layout in _layouts)
				totalWidth += layout.w;
			
			// We might not have enough room to display all of these buttons.
			if (totalWidth > unscaledWidth)
			{
				// Start evicting buttons based on the evictOrder, until we are
				// within the viewable size.
				var evictPosition : int;
				
				for (evictPosition = 1; evictPosition < _dataProvider.length && totalWidth > unscaledWidth; evictPosition++)
				{
					for (i = 0; i < _dataProvider.length; i++)
					{
						if (_dataProvider[i].evictOrder == evictPosition)
						{
							// Evict this button.
							totalWidth -= _layouts[i].w;
							_layouts[i].w = 0;
						}
					}
				}				
			}
				
			for (i = 0; i < _dataProvider.length; i++)
				if (_dataProvider[i].command == "gap")
					_layouts[i].w = unscaledWidth - totalWidth - 1;

			// Adjust our list of text fields so we have exactly enough.
			while (_textFields.length > _dataProvider.length)
			{
				removeChild(_textFields[0]);
				_textFields.removeItemAt(0);
			}
			
			while (_textFields.length < _dataProvider.length)
			{
				var textField : TextField = new TextField();
				textField.selectable = false;
				addChild(textField);
				_textFields.addItem(textField);
			}
		}
		
		//
		//  Private Implementation
		//
		
		/**
		 * Responds to ResizeEvent events. 
		 * @param event ResizeEvent.
		 */		
		private function resize(event : ResizeEvent) : void
		{
			refresh();
		}
		
		/**
		 * Responds to MouseMove events, so we can do hover effects. 
		 * @param event MouseEvent
		 */
		private function mouseMove(event : MouseEvent) : void
		{
			repaint();
		}
		
		/**
		 * Responds to MouseDown events, so we can show the depressed state for
		 * toolbar buttons.
		 * @param event MouseEvent.
		 */
		private function mouseDown(event : MouseEvent) : void
		{
			_mouseDownButton = hitTest();
			if (_mouseDownButton >= 0)
				_mouseIsDown = true;
			repaint();
		}
		
		/**
		 * Responds to MouseUp events, so we can trigger our button clicked event. 
		 * @param event MouseEvent.
		 */
		private function mouseUp(event : MouseEvent) : void
		{
			var btnIndex : int = hitTest();
			var command : String = (btnIndex == -1) ? "" : _dataProvider[btnIndex].command;
			
			// Ignore this if:
			//   - It's not the same button that was initially mouseDown'd on
			//   - This is out of the toolbar's jurisdiction
			//   - This is a gap or a separator "button"
			//   - The button is disabled
			if (btnIndex == _mouseDownButton && btnIndex != -1 && 
			    command != "gap" && 
			    command != "separator" &&
			    _dataProvider[btnIndex].enabled)
	    	{
				dispatchEvent(new ToolbarEvent(ToolbarEvent.BUTTON_CLICK, command));
		    }

			_mouseIsDown = false;
			_mouseDownButton = -1;
			repaint();
		}
		
		/**
		 * Responds to MouseOver events. 
		 * @param event MouseEvent.
		 */
		private function mouseOver(event : MouseEvent) : void
		{
			_mouseInControl = true;
			_mouseIsDown = false;
			repaint();
		}

		/**
		 * Responds to MouseOut events. 
		 * @param event MouseEvent.
		 */
		private function mouseOut(event : MouseEvent) : void
		{
			_mouseInControl = false;
			_mouseIsDown = false
			repaint();
		}
		
		/**
		 * Reponds to RightClick events. 
		 * @param event MouseEvent.
		 * 
		 */
		private function rightClick(event : MouseEvent) : void
		{
			var i : int;
			
			if (event.stageY > height)
				return;
			
			if (_menu != null)
				_menu.hide();
			
			// Clear all checkmarks
			for (i = 0; i < _menuProvider.length; i++)
				_menuProvider[i].icon = null;
			
			// Set the current checkmarks
			switch (_iconStyle)
			{
				case ICON_LARGE:
					_menuProvider[0].icon = Icons.Checkmark16;
					break;
				case ICON_SMALL:
					_menuProvider[1].icon = Icons.Checkmark16;
					break;
			}
			
			switch (_textStyle)
			{
				case TEXT_RIGHT:
					_menuProvider[3].icon = Icons.Checkmark16;
					break;
				case TEXT_BOTTOM:
					_menuProvider[4].icon = Icons.Checkmark16;
					break;
				case TEXT_NONE:
					_menuProvider[5].icon = Icons.Checkmark16;
					break;
			}
			
            _menu = Menu.createMenu(this, _menuProvider, false);
            _menu.labelField = "label";
            _menu.iconField = "icon";
            _menu.setStyle("openDuration", 0);
            _menu.setStyle("fontSize", 11);
            _menu.addEventListener("itemClick", 
            	function menuClick(event : MenuEvent) : void
            	{
            		switch (event.item.data)
            		{
            			case "icon_large":
            				iconStyle = ICON_LARGE;
            				break;
            			case "icon_small":
            				iconStyle = ICON_SMALL;
            				break;
            			case "text_right":
            				textStyle = TEXT_RIGHT;
            				break;
            			case "text_bottom":
            				textStyle = TEXT_BOTTOM;
            				break;
            			case "text_none":
            				textStyle = TEXT_NONE;
            				break;
            		}
            		refresh();
            		repaint();
            	});         
            _menu.show(Math.min(this.width - 110, event.stageX), event.stageY);
		}
		
		/**
		 * UIComponent function for creating the children components, such as 
		 * static text controls.
		 */
		override protected function createChildren() : void
		{
			super.createChildren();
			refresh();
		}
		
		/**
		 * UIComponent function called when our properties have changed. 
		 */
		override protected function commitProperties() : void
		{
			super.commitProperties();
			refresh();
		}
		
		/**
		 * UIComponent function called to measure the intended size of this 
		 * control. 
		 */
		override protected function measure() : void
		{
        	super.measure();
        	measuredHeight = _desiredHeight;
        	measuredMinHeight = _desiredHeight;
        	measuredWidth = parent.width;
        	measuredMinWidth = 0;
 		}
		
		/**
		 * UIComponent function called to repaint the control. 
		 * @param unscaledWidth  Width in pixels
		 * @param unscaledHeight Height in pixels
		 */
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var i : int;
			var x : int = 0;
			
			graphics.clear();
			paintGradientBackground();
			paintBorder();
			
			// Determine if the mouse is hovering over one of the buttons.
			var hoverIndex : int = hitTest();
			
			if (_layouts.length == 0)
				return;
			
			for (i = 0; i < _layouts.length; i++)
			{
				var btn : Object = _dataProvider[i];
				var hover : Boolean = (hoverIndex == i);
				var layout : Object = _layouts[i];
				
				x = paintButton(layout, btn, i, x, hover && !_mouseIsDown, hover && _mouseIsDown);
			}
			
			// The desired height may have changed.
			if (_desiredHeight != _layouts[0].h + 1)
			{
				_desiredHeight = _layouts[0].h + 1;
				dispatchEvent(new Event(DESIREDHEIGHT_CHANGE));
			}
		}

		/**
		 * Paint the gradient background of the toolbar, using the user's
		 * specified colors. 
		 */
		private function paintGradientBackground() : void
		{
			var topColor    : uint = uint(getStyle("backgroundGradientColor1"));
			var bottomColor : uint = uint(getStyle("backgroundGradientColor2"));
			
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(unscaledWidth, unscaledHeight - 1, Math.PI / 2, 0, 0);
			
			graphics.beginGradientFill(
				GradientType.LINEAR, 
				[topColor, bottomColor],
				[1, 1],
				[0, 255], 
				matrix, 
				SpreadMethod.PAD, 
				InterpolationMethod.LINEAR_RGB, 
				0);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight - 1);
		}
		
		/**
		 * Paint the bottom border of the control,  using the user's specified
		 * color. 
		 */
		private function paintBorder() : void
		{
			var color : uint = uint(getStyle("borderColor"));
			graphics.lineStyle(1, color);
			graphics.drawRect(0, unscaledHeight - 2, unscaledWidth, 0);  
		}
		
		/**
		 * Paint an icon at the specified location.  
		 * @param icon   Embedded icon resource.
		 * @param x      Left coordinate
		 * @param y      Top coordinate
		 * @param width  Width of the icon
		 * @param height Height of the icon.
		 * @param alpha  Overall alpha multipler
		 * @param badge  Badge number
		 */
		private function paintIcon(icon : Class, x : int, y : int, width : int, height : int, alpha : Number = 1, badge : int = 0) : void
		{
			var bmp : BitmapData = new BitmapData(width, height, true, 0);
			var colorTransform : ColorTransform = new ColorTransform(1, 1, 1, alpha);
			bmp.draw(new icon, null, colorTransform);
			var matrix : Matrix = new Matrix();
			matrix.translate(x, y);
			graphics.lineStyle();
			graphics.beginBitmapFill(bmp, matrix, false);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
			
			if (badge > 0)
			{
				graphics.beginFill(0xFF0000);
				graphics.drawCircle(x + width - 7, y + 7, 7);
				graphics.endFill();
				
			}
		}
		
		/**
		 * Lays out one of the buttons. 
		 * @param data    The button information from the dataProvider.
		 * @return {icon: {x:#, y:#, w:#, h:#}, 
		 *          text: {x:#, y:#, w:#, h:#}, 
		 *          box: {x:#, y:#, w:#, h:#},
		 *          w: #}
		 */
		private function layoutButton(data : Object) : Object
		{
			var ret : Object = 
			{
				icon: {x: 0, y: 0, w: 0, h: 0},
				text: {x: 0, y: 0, w: 0, h: 0},
				box:  {x: 0, y: 0, w: 0, h: 0},
				w:    0,
				h:    0
			};
			
			var margin : int = 5;

			if (data.command == "separator")
			{
				ret.w = 6;
				ret.box.x = 3;
				ret.box.y = margin; 
				ret.box.h = (_iconStyle == ICON_LARGE) ? 32 : 16;
				return ret;  
			}
			else if (data.command == "gap")
			{
				return ret;			
			}

			//
			//  Set all the heights and widths first.
			//
			switch (_iconStyle)
			{
				case ICON_LARGE:
					ret.icon.w = 32;
					ret.icon.h = 32;
					break;
					
				case ICON_SMALL:
					ret.icon.w = 16;
					ret.icon.h = 16;
					break;
			}

			if (_textStyle != TEXT_NONE)
			{
				var metrics : TextLineMetrics = measureText(data.label);
				ret.text.w = metrics.width + metrics.leading + 3;
				ret.text.h = metrics.height;
			}
			
			switch (_textStyle)
			{
				case TEXT_NONE:
					ret.box.w = ret.icon.w + 6;
					ret.box.h = ret.icon.h + 6;
					break;
				
				case TEXT_RIGHT:
					ret.box.w = ret.icon.w + 3 + ret.text.w + 6;
					ret.box.h = ret.icon.h + 6;
					break;
				
				case TEXT_BOTTOM:
					if (ret.icon.w > ret.text.w)
						ret.box.w = ret.icon.w + 6;
					else
						ret.box.w = ret.text.w + 6;
						
					ret.box.h = ret.icon.h + ret.text.h + 6;
					break;
			}
			
			// Now set the X and Y coordinates 
			ret.box.x = 1;
			ret.box.y = 1;
			
			switch (_textStyle)
			{
				case TEXT_NONE:
					ret.icon.x = margin;
					ret.icon.y = margin;
					break;
					
				case TEXT_RIGHT:
					ret.icon.x = margin;
					ret.icon.y = margin;
					ret.text.x = margin + ret.icon.x + ret.icon.w;
					ret.text.y = margin + Math.floor(ret.icon.h / 2 - ret.text.h / 2) - 1;
					
					// For aesthetics, we add some extra margin on the right 
					// side in this particular case.
					ret.box.w += 4;
					break;
					
				case TEXT_BOTTOM:
					if (ret.icon.w > ret.text.w)
					{
						ret.icon.x = margin;
						ret.icon.y = margin;
						ret.text.x = margin + Math.ceil(ret.icon.w / 2 - ret.text.w / 2);
						ret.text.y = margin + ret.icon.h;
					}
					else
					{
						ret.icon.x = margin + Math.ceil(ret.text.w / 2 - ret.icon.w / 2) - 1;
						ret.icon.y = margin;
						ret.text.x = margin;
						ret.text.y = margin + ret.icon.h;
					}
					break;			
			}
			
			// For aesthetics, we add some extra margin on the right.
			ret.box.w++;

			ret.w = ret.box.x + ret.box.w + 1;
			ret.h = ret.box.y + ret.box.h + 3;
			
			return ret;
		}
		
		/**
		 * Paints a button, including the icon, text, and hover box. 
		 * @param layout   Precomputed layout information.
		 * @param data     User's button data.
		 * @param btnIndex Which button this is.
		 * @param x        Left coordinate to begin at.
		 * @param hover    Whether the mouse is currently hovering over this button.
		 * @param depress  Whether the mouse button is currently depressed over this button.
		 * @return New X coordinate.
		 */
		private function paintButton(layout : Object, data : Object, btnIndex : int, x : int, hover : Boolean, depress : Boolean) : int
		{
			var textField : TextField = _textFields[btnIndex] as TextField;

			if (layout.w == 0)
			{
				textField.visible = false;
				return x;
			}
			else if (data.command == "separator")
			{
				var color : uint = uint(getStyle("borderColor"));
				graphics.lineStyle(1, color);
				graphics.drawRect(x + layout.box.x, layout.box.y, 0, unscaledHeight - layout.box.y * 2);
				return x + layout.w;
			}
			else if (data.command == "gap")
			{
				return x + layout.w;
			}
		
			if (data.enabled && (hover || depress))
			{
				var hoverBackgroundColor : uint = uint(getStyle("hoverBackgroundColor"));
				var hoverBorderColor : uint = uint(getStyle("hoverBorderColor"));
				var depressBackgroundColor : uint = uint(getStyle("depressBackgroundColor"));
				var depressBorderColor : uint = uint(getStyle("depressBorderColor"));

				// Draw a colored rectangle behind the button.
				if (hover)
				{
					graphics.beginFill(hoverBackgroundColor);
					graphics.lineStyle(1, hoverBorderColor);
				}
				else
				{
					graphics.beginFill(depressBackgroundColor);
					graphics.lineStyle(1, depressBorderColor);
				}
				
				graphics.drawRect(x + layout.box.x, layout.box.y, layout.box.w, layout.box.h);
				graphics.endFill();
			}
			
			var alpha : Number = (data.enabled ? 1 : 0.5);
			var textColor : uint = uint(getStyle("textColor"));
			var disabledTextColor : uint = uint(getStyle("disabledTextColor"));  
			var colorHex : String = (data.enabled ? textColor : disabledTextColor).toString(16);
			
			if (_iconStyle == ICON_LARGE && data.largeIcon != null)
				paintIcon(data.largeIcon, x + layout.icon.x, layout.icon.y, layout.icon.w, layout.icon.h, alpha, data.badge);
			else if (_iconStyle == ICON_SMALL && data.smallIcon != null)
				paintIcon(data.smallIcon, x + layout.icon.x, layout.icon.y, layout.icon.w, layout.icon.h, alpha, data.badge);
			
			textField.visible = (layout.text.h > 0);
			textField.htmlText = '<font size="12" color="#' + colorHex + '" face="' + _font + '">' + data.label + '</font>';
			textField.x = x + layout.text.x;
			textField.y = layout.text.y;
			
			return x + layout.w;
		}
		
		/**
		 * Loads the settings for this toolbar from disk. 
		 */
		private function loadSettings() : void
		{
			var settingsFile : File = File.applicationStorageDirectory.resolvePath("Toolbar Settings - " + _name);
			var stream       : FileStream = null;
			
			if (!settingsFile.exists)
				return;
			
			try
			{
				stream = new FileStream();
				stream.open(settingsFile, FileMode.READ);
				_iconStyle = stream.readInt();
				_textStyle = stream.readInt();
				stream.close();
			}
			catch (error : Error)
			{
				// Use default values for anything that cannot be read from the
				// settings file.
			}
		}
		
		/**
		 * Saves the settings for this toolbar to disk. 
		 */
		private function saveSettings() : void
		{
			var settingsFile : File = File.applicationStorageDirectory.resolvePath("Toolbar Settings - " + _name);
			var stream : FileStream;
			
			try
			{
				stream = new FileStream();
				stream.open(settingsFile, FileMode.WRITE);
			}
			catch (error : Error)
			{
				return;
			}
			
			stream.writeInt(_iconStyle);
			stream.writeInt(_textStyle);
			stream.close();
		}
		
		/**
		 * Checks if the given coordinates are inside one of the buttons. 
		 * @return -1, or a button index
		 */
		private function hitTest() : int 
		{
			if (_layouts.length == 0 || !_mouseInControl)
				return -1;
			
			var x : int = 0;
			
			for (var i : int = 0; i < _layouts.length; i++)
			{
				var btn : Object = _dataProvider[i];
				var hover : Boolean = _mouseInControl;
				var layout : Object = _layouts[i];
				
				if (mouseY < 0 || mouseY >= unscaledHeight)
					hover = false;
				if (stage.mouseX < x)
					hover = false;
				else if (stage.mouseX >= x + layout.w)
					hover = false;
				
				if (hover)
					return i;
				else
					x += layout.w;
			}
			
			return -1;
		}
	}
}