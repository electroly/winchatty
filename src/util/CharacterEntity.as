package util {

/**
 * @author Jim Cheng <a href="jim.cheng@effectiveui.com">jim.cheng@effectiveui.com</a>
 *
 * A static class for encoding and decoding XML and HTML character entities.
 * 
 */
public class CharacterEntity {
	//import flash.utils.Dictionary;

	//@----------------------------------------------------------   REQUIRED INFO
	//@exclude
	public var version:String = "1.0.0.0";
	//@exclude
	public static var symbolName:String = "CharacterEntity";
	//@exclude
	public static var symbolOwner:Object = CharacterEntity;
	//@exclude
	public var className : String = "CharacterEntity";
	//@----------------------------------------------------------   CONSTRUCTOR
	
	public function CharacterEntity() { }
	
	//@----------------------------------------------------------   PRIVATE VARS
	
	private static var initialized:Boolean = false;
	
	private static var xmlEntities:Object;
	private static var entities:Object;
	
	//@----------------------------------------------------------   PUBLIC VARS
	
	// Specified by XML 1.0
	
	
	//@----------------------------------------------------------   DEFAULT STYLE
	
	//@----------------------------------------------------------   GETTERS/SETTERS
	
	//@----------------------------------------------------------   ASSETS
	
	//@----------------------------------------------------------   CORE METHODS
	
	//@----------------------------------------------------------   MOUSE EVENTS
	
	//@----------------------------------------------------------   PUBLIC METHODS
	
	/**
	* Decodes character entities in a given string to UTF-8 Unicode equivalents.
	* 
	* @param	The character entities encoded text to decode.
	* @param	Whether to only use the XML character entity set or
	*           the full 252 character HTML entity set.
	* 
	* @usage    decode('M&yacute; string', true);
	*/
	public static function decode(text:String, xmlOnly:Boolean):String {
		
		if (typeof text != 'string') { return text; }
		
		if (initialized == false)
			initialize();
				
		var i:String;
		var translationTable:Object = xmlOnly ? xmlEntities : entities;
		
//		var start:Number = getTimer();
		
		// Simple check to avoid decoding if its obvious that there
		// aren't any XML/HTML character entities to be found.
		if (text.indexOf('&') == -1) { return text; }
		
		for (i in translationTable) {
			text = text.split(i).join(String.fromCharCode(translationTable[i]));	
		}
		
		text = decodeNumericReferences(text);
		
//		trace('time: ' + (getTimer() - start));
		return text;
		
	}
	
	/**
	* Decodes numeric entity references in a given string to UTF-8 Unicode equivalents.
	* 
	* @param	The string to decode.
	* 
	* @usage	decodeNumericReferences('&#0221');
	*/
	public static function decodeNumericReferences(text:String):String {
		
		if (typeof text != 'string') { return text; }
		
		var output : String = '';
		var lastPosition:Number = 0;		
		var cursor:Number = 0;
		var semi:Number;
		var code:String;
		
		cursor = text.indexOf('&#', 0);
		
		while (cursor != -1) {
			semi = text.indexOf(';', cursor);
			code = text.substring(cursor + 2, semi);
			
			output += text.substring(lastPosition, cursor);
			
			if (code.charAt(0) == 'x') {
				output += String.fromCharCode(parseInt('0' + code, 16));
			}
			else {
				output += String.fromCharCode(parseInt(code, 10));
			}
			lastPosition = semi + 1;
			cursor = text.indexOf('&#', lastPosition);
		} 
		
		output += text.substr(lastPosition);		

		return output;
	}
	
	/**
	* Encodes a Unicode string, transforming characters with character entity
	* equivalents from their Unicode bytecode to the character entity representation.
	* 
	* @param	The Unicode text (e.g. Actionscript string) to encode.
	* @param	Whether to only use the XML character entity set or
	*           the full 252 character HTML entity set.
	* 
	* @usage    encode('Â Unicode string', true);
	*/
	public static function encode(text:String, xmlOnly:Boolean):String {
		
		if (typeof text != 'string') { return text; }
		
		var i:String;
		var translationTable:Object = xmlOnly ? xmlEntities : entities;
		for (i in translationTable) {
			text = text.split(translationTable[i]).join(i);	
		}
		return text;
	}
	
	//@----------------------------------------------------------   PRIVATE METHODS

	/**
	* Initialization method -- do not call, it is invoked on class initialzation.
	*/
	private static function initialize() : void {	
		
		if (initialized) return;
		
		var i:String;
		var hacked:Object = { LT: true, GT: true, NOT: true, AND: true, OR:true, NE:true, LE:true, GE:true };
		var str:String;
		
		xmlEntities = new Object();
		xmlEntities["&quot;"]		= 0x0022;	// " quotation mark
		xmlEntities["&amp;"]		= 0x0026;	// & ampersand
		xmlEntities["&apos;"]		= 0x0027;	// ' apostrophe		
		xmlEntities["&lt;"]			= 0x003C;	// < less-than sign
		xmlEntities["&gt;"]			= 0x003E;	// > greater-than sign
		
		entities = new Object();
		entities["&quot;"]		= 0x0022;	// " quotation mark
		entities["&amp;"]		= 0x0026;	// & ampersand
		entities["&apos;"]		= 0x0027;	// ' apostrophe		
		entities["&lt;"]			= 0x003C;	// < less-than sign
		entities["&gt;"]			= 0x003E;	// > greater-than sign
		
		// Specified by HTML and XHTML DTDs
			
		entities["&nbsp;"]		= 0x00A0;	//   no-break space
		entities["&iexcl;"]		= 0x00A1;	// ¡ inverted exclamation mark
		entities["&cent;"]		= 0x00A2;	// ¢ cent sign
		entities["&pound;"]		= 0x00A3;	// £ pound sign
		entities["&curren;"]		= 0x00A4;	// ¤ currency sign
		entities["&yen;"]		= 0x00A5;	// ¥ yen sign
		entities["&brvbar;"]		= 0x00A6;	// ¦ broken bar
		entities["&sect;"]		= 0x00A7;	// § section sign
		entities["&uml;"]		= 0x00A8;	// ¨ diaeresis
		entities["&copy;"]		= 0x00A9;	// © copyright sign
		entities["&ordf;"]		= 0x00AA;	// ª feminine ordinal indicator
		entities["&laquo;"]		= 0x00AB;	// « left-pointing double angle quotation mark
	//	entities["&not;"]		= 0x00AC;	// ¬ not sign
		entities["&shy;"]		= 0x00AD;	// ­ soft hyphen
		entities["&reg;"]		= 0x00AE;	// ® registered sign
		entities["&macr;"]		= 0x00AF;	// ¯ macron
		entities["&deg;"]		= 0x00B0;	// ° degree sign
		entities["&plusmn;"]		= 0x00B1;	// ± plus-minus sign
		entities["&sup2;"]		= 0x00B2;	// ² superscript two
		entities["&sup3;"]		= 0x00B3;	// ³ superscript three
		entities["&acute;"]		= 0x00B4;	// ´ acute accent
		entities["&micro;"]		= 0x00B5;	// µ micro sign
		entities["&para;"]		= 0x00B6;	// ¶ pilcrow sign
		entities["&middot;"]		= 0x00B7;	// · middle dot
		entities["&cedil;"]		= 0x00B8;	// ¸ cedilla
		entities["&sup1;"]		= 0x00B9;	// ¹ superscript one
		entities["&ordm;"]		= 0x00BA;	// º masculine ordinal indicator
		entities["&raquo;"]		= 0x00BB;	// » right-pointing double angle quotation mark
		entities["&frac14;"]		= 0x00BC;	// ¼ vulgar fraction one quarter
		entities["&frac12;"]		= 0x00BD;	// ½ vulgar fraction one half
		entities["&frac34;"]		= 0x00BE;	// ¾ vulgar fraction three quarters
		entities["&iquest;"]		= 0x00BF;	// ¿ inverted question mark
	
		entities["&Agrave;"]		= 0x00C0;	// À latin capital letter a with grave
		entities["&Aacute;"]		= 0x00C1;	// Á latin capital letter a with acute
		entities["&Acirc;"]		= 0x00C2;	// Â latin capital letter a with circumflex
		entities["&Atilde;"]		= 0x00C3;	// Ã latin capital letter a with tilde
		entities["&Auml;"]		= 0x00C4;	// Ä latin capital letter a with diaeresis
		entities["&Aring;"]		= 0x00C5;	// Å latin capital letter a with ring above
		entities["&AElig;"]		= 0x00C6;	// Æ latin capital letter ae
		entities["&Ccedil;"]		= 0x00C7;	// Ç latin capital letter c with cedilla
		entities["&Egrave;"]		= 0x00C8;	// È latin capital letter e with grave
		entities["&Eacute;"]		= 0x00C9;	// É latin capital letter e with acute
		entities["&Ecirc;"]		= 0x00CA;	// Ê latin capital letter e with circumflex
		entities["&Euml;"]		= 0x00CB;	// Ë latin capital letter e with diaeresis
		entities["&Igrave;"]		= 0x00CC;	// Ì latin capital letter i with grave
		entities["&Iacute;"]		= 0x00CD;	// Í latin capital letter i with acute
		entities["&Icirc;"]		= 0x00CE;	// Î latin capital letter i with circumflex
		entities["&Iuml;"]		= 0x00CF;	// Ï latin capital letter i with diaeresis
		entities["&ETH;"]		= 0x00D0;	// Ð latin capital letter eth
		entities["&Ntilde;"]		= 0x00D1;	// Ñ latin capital letter n with tilde
		entities["&Ograve;"]		= 0x00D2;	// Ò latin capital letter o with grave
		entities["&Oacute;"]		= 0x00D3;	// Ó latin capital letter o with acute
		entities["&Ocirc;"]		= 0x00D4;	// Ô latin capital letter o with circumflex
		entities["&Otilde;"]		= 0x00D5;	// Õ latin capital letter o with tilde
		entities["&Ouml;"]		= 0x00D6;	// Ö latin capital letter o with diaeresis
		entities["&times;"]		= 0x00D7;	// × multiplication sign
		entities["&Oslash;"]		= 0x00D8;	// Ø latin capital letter o with stroke
		entities["&Ugrave;"]		= 0x00D9;	// Ù latin capital letter u with grave
		entities["&Uacute;"]		= 0x00DA;	// Ú latin capital letter u with acute
		entities["&Ucirc;"]		= 0x00DB;	// Û latin capital letter u with circumflex
		entities["&Uuml;"]		= 0x00DC;	// Ü latin capital letter u with diaeresis
		entities["&Yacute;"]		= 0x00DD;	// Ý latin capital letter y with acute
		entities["&THORN;"]		= 0x00DE;	// Þ latin capital letter thorn
		entities["&szlig;"]		= 0x00DF;	// ß latin capital letter sharp s
		
		entities["&agrave;"]		= 0x00E0;	// à latin small letter a with grave
		entities["&aacute;"]		= 0x00E1;	// á latin small letter a with acute
		entities["&acirc;"]		= 0x00E2;	// â latin small letter a with circumflex
		entities["&atilde;"]		= 0x00E3;	// ã latin small letter a with tilde
		entities["&auml;"]		= 0x00E4;	// ä latin small letter a with diaeresis
		entities["&aring;"]		= 0x00E5;	// å latin small letter a with ring
		entities["&aelig;"]		= 0x00E6;	// æ latin small letter ae
		entities["&ccedil;"]		= 0x00E7;	// ç latin small letter c with cedilla
		entities["&egrave;"]		= 0x00E8;	// è latin small letter e with grave
		entities["&eacute;"]		= 0x00E9;	// é latin small letter e with acute
		entities["&ecirc;"]		= 0x00EA;	// ê latin small letter e with circumflex
		entities["&euml;"]		= 0x00EB;	// ë latin small letter e with diaeresis
		entities["&igrave;"]		= 0x00EC;	// ì latin small letter i with grave
		entities["&iacute;"]		= 0x00ED;	// í latin small letter i with acute
		entities["&icirc;"]		= 0x00EE;	// î latin small letter i with circumflex
		entities["&iuml;"]		= 0x00EF;	// ï latin small letter i with diaeresis
		entities["&eth;"]		= 0x00F0;	// ð latin small letter eth
		entities["&ntilde;"]		= 0x00F1;	// ñ latin small letter n with tilde
		entities["&ograve;"]		= 0x00F2;	// ò latin small letter o with grave
		entities["&oacute;"]		= 0x00F3;	// ó latin small letter o with acute
		entities["&ocirc;"]		= 0x00F4;	// ô latin small letter o with circumflex
		entities["&otilde;"]		= 0x00F5;	// õ latin small letter o with tilde
		entities["&ouml;"]		= 0x00F6;	// ö latin small letter o with diaeresis
		entities["&divide;"]		= 0x00F7;	// ÷ division sign
		entities["&oslash;"]		= 0x00F8;	// ø latin small letter o with stroke
		entities["&ugrave;"]		= 0x00F9;	// ù latin small letter u with grave
		entities["&uacute;"]		= 0x00FA;	// ú latin small letter u with acute
		entities["&ucirc;"]		= 0x00FB;	// û latin small letter u with circumflex
		entities["&uuml;"]		= 0x00FC;	// ü latin small letter u with diaeresis
		entities["&yacute;"]		= 0x00FD;	// ý latin small letter y with acute
		entities["&thorn;"]		= 0x00FE;	// þ latin small letter thorn
		entities["&yuml;"]		= 0x00FF;	// ÿ latin small letter y with diaeresis
		entities["&OElig;"]		= 0x0152;	// Œ latin capital ligature oe
		entities["&oelig;"]		= 0x0153;	// œ latin small ligature oe
		entities["&Scaron;"]		= 0x0160;	// Š latin capital letter s with caron
		entities["&scaron;"]		= 0x0161;	// š latin small letter s with caron
		entities["&Yuml;"]		= 0x0178;	// Ÿ latin cpital letter y with diaeresis
		entities["&fnof;"]		= 0x0192;	// ƒ latin small letter f with hook
		entities["&circ;"]		= 0x02C6;	// ˆ modifier letter circumflex accent
		entities["&tilde;"]		= 0x02DC;	// ˜ small tilde
		
		entities["&Alpha;"]		= 0x0391;	// Α greek capital letter alpha
		entities["&Beta;"]		= 0x0392;	// Β greek capital letter beta
		entities["&Gamma;"]		= 0x0393;	// Γ greek capital letter gamma
		entities["&Delta;"]		= 0x0394;	// Δ greek capital letter delta
		entities["&Epsilon;"]	= 0x0395;	// Ε greek capital letter epsilon
		entities["&Zeta;"]		= 0x0396;	// Ζ greek capital letter zeta
		entities["&Eta;"]		= 0x0397;	// Η greek capital letter eta
		entities["&Theta;"]		= 0x0398;	// Θ greek capital letter theta
		entities["&Iota;"]		= 0x0399;	// Ι greek capital letter iota
		entities["&Kappa;"]		= 0x039A;	// Κ greek capital letter kappa
		entities["&Lambda;"]		= 0x039B;	// Λ greek capital letter lambda
		entities["&Mu;"]			= 0x039C;	// Μ greek capital letter mu
		entities["&Nu;"]			= 0x039D;	// Ν greek capital letter nu
		entities["&Xi;"]			= 0x039E;	// Ξ greek capital letter xi
		entities["&Omicron;"]	= 0x039F;	// Ο greek capital letter omicron
		entities["&Pi;"]			= 0x03A0;	// Π greek capital letter pi
		entities["&Rho;"]		= 0x03A1;	// Ρ greek capital letter rho
		entities["&Sigma;"]		= 0x03A3;	// Σ greek capital letter sigma
		entities["&Tau;"]		= 0x03A4;	// Τ greek capital letter tau
		entities["&Upsilon;"]	= 0x03A5;	// Υ greek capital letter upsilon
		entities["&Phi;"]		= 0x03A6;	// Φ greek capital letter phi
		entities["&Chi;"]		= 0x03A7;	// Χ greek capital letter chi
		entities["&Psi;"]		= 0x03A8;	// Ψ greek capital letter psi
		entities["&Omega;"]		= 0x03A9;	// Ω greek capital letter omega
		
		entities["&alpha;"]		= 0x03B1;	// α greek small letter alpha
		entities["&beta;"]		= 0x03B2;	// β greek small letter beta
		entities["&gamma;"]		= 0x03B3;	// γ greek small letter gamma
		entities["&delta;"]		= 0x03B4;	// δ greek small letter delta
		entities["&epsilon;"]	= 0x03B5;	// ε greek small letter epsilon
		entities["&zeta;"]		= 0x03B6;	// ζ greek small letter zeta
		entities["&eta;"]		= 0x03B7;	// η greek small letter eta
		entities["&theta;"]		= 0x03B8;	// θ greek small letter theta
		entities["&iota;"]		= 0x03B9;	// ι greek small letter iota
		entities["&kappa;"]		= 0x03BA;	// κ greek small letter kappa
		entities["&lambda;"]		= 0x03BB;	// λ greek small letter lambda
		entities["&mu;"]			= 0x03BC;	// μ greek small letter mu
		entities["&nu;"]			= 0x03BD;	// ν greek small letter nu
		entities["&xi;"]			= 0x03BE;	// ξ greek small letter xi
		entities["&omicron;"]	= 0x03BF;	// ο greek small letter omicron
		entities["&pi;"]			= 0x03C0;	// π greek small letter pi
		entities["&rho;"]		= 0x03C1;	// ρ greek small letter rho
		entities["&sigmaf;"]		= 0x03C2;	// ς greek small letter final sigma
		entities["&sigma;"]		= 0x03C3;	// σ greek small letter sigma
		entities["&tau;"]		= 0x03C4;	// τ greek small letter tau
		entities["&upsilon;"]	= 0x03C5;	// υ greek small letter upsilon
		entities["&phi;"]		= 0x03C6;	// φ greek small letter phi
		entities["&chi;"]		= 0x03C7;	// χ greek small letter chi
		entities["&psi;"]		= 0x03C8;	// ψ greek small letter psi
		entities["&omega;"]		= 0x03C9;	// ω greek small symbol omega
		entities["&thetasym;"]	= 0x03D1;	// ϑ greek theta symbol
		entities["&upsih;"]		= 0x03D2;	// ϒ greek upsilon with hook symbol
		entities["&piv;"]		= 0x03D6;	// ϖ greek pi symbol
		
		entities["&ensp;"]		= 0x2002;	//   en space
		entities["&emsp;"]		= 0x2003;	//   em space
		entities["&thinsp;"]		= 0x2009;	//   thin space
		entities["&zwnj;"]		= 0x200C;	//   zero width non-joiner
		entities["&zwj;"]		= 0x200D;	//   zero width joiner
		entities["&lrm;"]		= 0x200E;	//   left-to-right mark
		entities["&rlm;"]		= 0x200F;	//   right-to-left mark
		entities["&ndash;"]		= 0x2013;	// – en dash
		entities["&mdash;"]		= 0x2014;	// — em dash
		entities["&lsquo;"]		= 0x2018;	// ‘ left single quotation mark
		entities["&rsquo;"]		= 0x2019;	// ’ right single quotation mark
		entities["&sbquo;"]		= 0x201A;	// ‚ single low-9 quotation mark
		entities["&ldquo;"]		= 0x201C;	// “ left double quotation mark
		entities["&rdquo;"]		= 0x201D;	// ” right double quotation mark
		entities["&bdquo;"]		= 0x201E;	// „ double low-9 quotation mark
		entities["&dagger;"]		= 0x2020;	// † dagger
		entities["&Dagger;"]		= 0x2021;	// ‡ double dagger
		entities["&bull;"]		= 0x2022;	// • bullet
		entities["&hellip;"]		= 0x2026;	// … horizontal ellipsis
		entities["&permil;"]		= 0x2030;	// ‰ per mille sign
		entities["&prime;"]		= 0x2032;	// ′ prime
		entities["&Prime;"]		= 0x2033;	// ″ double prime
		entities["&lsaquo;"]		= 0x2039;	// ‹ single left-pointing angle quotation mark
		entities["&rsaquo;"]		= 0x203A;	// › single right-pointing angle quotation mark
		entities["&oline;"]		= 0x203E;	// ‾ overline
		entities["&frasl;"]		= 0x2044;	// ⁄ fraction slash
		entities["&euro;"]		= 0x20AC;	// € euro sign
		entities["&image;"]		= 0x2111;	// ℑ black-letter capital i
		entities["&weierp;"]		= 0x2118;	// ℘ script capital p
		entities["&real;"]		= 0x211C;	// ℜ black-letter capital r
		entities["&trade;"]		= 0x2122;	// ™ trade mark sign
		entities["&alefsym;"]	= 0x2135;	// ℵ alef symbol
		
		entities["&larr;"]		= 0x2190;	// ← leftwards arrow
		entities["&uarr;"]		= 0x2191;	// ↑ upwards arrow
		entities["&rarr;"]		= 0x2192;	// → rightwards arrow
		entities["&darr;"]		= 0x2193;	// ↓ downwards arrow
		entities["&harr;"]		= 0x2194;	// ↔ left right arrow
		entities["&crarr;"]		= 0x21B5;	// ↵ downwards arrow with corner leftwards
		entities["&lArr;"]		= 0x21D0;	// ⇐ leftwards double arrow
		entities["&uArr;"]		= 0x21D1;	// ⇑ upwards double arrow
		entities["&rArr;"]		= 0x21D2;	// 	⇒ rightwards double arrow
		entities["&dArr;"]		= 0x21D3;	// ⇓ downwards double arrow
		entities["&hArr;"]		= 0x21D4;	// ⇔⇔  left right double arrow
		entities["&forall;"]		= 0x2200;	// ∀  for all
		entities["&part;"]		= 0x2202;	// ∂ partial differential
		entities["&exist;"]		= 0x2203;	// ∃  there exists
		entities["&empty;"]		= 0x2205;	// ∅ empty set
		entities["&nabla;"]		= 0x2207;	// ∇  nabla
		entities["&isin;"]		= 0x2208;	// 	∈ element of
		entities["&notin;"]		= 0x2209;	// ∉ not an element of
		entities["&ni;"]			= 0x220B;	// 	∋ contains as member
		entities["&prod;"]		= 0x220F;	// ∏ n-ary product
		entities["&sum;"]		= 0x2211;	// ∑ n-ary summation
		entities["&minus;"]		= 0x2212;	// − minus sign
		entities["&lowast;"]		= 0x2217;	// ∗ asterisk operator
		entities["&radic;"]		= 0x221A;	// √ square root
		entities["&prop;"]		= 0x221D;	// ∝  proportional to
		entities["&infin;"]		= 0x221E;	// ∞ infinity
		entities["&ang;"]		= 0x2220;	// ∠  angle
	//	entities["&and;"]		= 0x2227;	// ∧  logical and
	//	entities["&or;"]			= 0x2228;	// 	∨ logical or
		entities["&cap;"]		= 0x2229;	// ∩ intersection
		entities["&cup;"]		= 0x222A;	// ∪  union
		entities["&int;"]		= 0x222B;	// ∫ integral
		entities["&there4;"]		= 0x2234;	// ∴  therefore
		entities["&sim;"]		= 0x223C;	// ∼  tilde operator
		entities["&cong;"]		= 0x2245;	// ≅ congruent to
		entities["&asymp;"]		= 0x2248;	// ≈ almost equal to
	//	entities["&ne;"]			= 0x2260;	// ≠ not equal to
		entities["&equiv;"]		= 0x2261;	// ≡ identical to
	//	entities["&le;"]			= 0x2264;	// ≤ less-than or equal to
	//	entities["&ge;"]			= 0x2265;	// ≥ greater-than or equal to
		entities["&sub;"]		= 0x2282;	// 	⊂ subset of
		entities["&sup;"]		= 0x2283;	// ⊃  superset of
		entities["&nsub;"]		= 0x2284;	// ⊄ not a subset of
		entities["&sube;"]		= 0x2286;	// ⊆  subset of or equal to
		entities["&supe;"]		= 0x2287;	// ⊇  superset of or equal to
		entities["&oplus;"]		= 0x2295;	// ⊕  circled plus
		entities["&otimes;"]		= 0x2297;	// ⊗ circled times
		entities["&perp;"]		= 0x22A5;	// ⊥  up tack
		entities["&sdot;"]		= 0x22C5;	// ⋅ dot operator
		entities["&lceil;"]		= 0x2308;	// 	⌈ left ceiling
		entities["&rceil;"]		= 0x2309;	// 	⌉ right ceiling
		entities["&lfloor;"]		= 0x230A;	// ⌊  left floor
		entities["&rfloor;"]		= 0x230B;	// 	⌋ right floor
		entities["&lang;"]		= 0x2329;	// 	⌋ left-pointing angle bracket
		entities["&rang;"]		= 0x232A;	// 	〉⌋ right-pointing angle bracket
		entities["&loz;"]		= 0x25CA;	// ◊ lozenge
		entities["&spades;"]		= 0x2660;	// ♠ black spade suit
		entities["&clubs;"]		= 0x2663;	// ♣ black club suit
		entities["&hearts;"]		= 0x2665;	// ♥ black heart suit
		entities["&diams;"]		= 0x2666;	// ♦ black diamond suit
	
		// Disallowed by Flash 4 backwards-compatibility, hacked using all caps
		// here, though the lower-case version also works via __resolve().
	
		entities["&LT;"]			= 0x003C;	// < less-than sign
		entities["&GT;"]			= 0x003E;	// > greater-than sign
		entities["&NOT;"]		= 0x00AC;	// ¬ not sign
		entities["&AND;"]		= 0x2227;	// ∧  logical and
		entities["&OR;"]			= 0x2228;	// 	∨ logical or
		entities["&NE;"]			= 0x2260;	// ≠ not equal to
		entities["&LE;"]			= 0x2264;	// ≤ less-than or equal to
		entities["&GE;"]			= 0x2265;	// ≥ greater-than or equal to
		
		initialized = true;
	}
	
	/**
	* Low-level resolution of entity names conflicting with Flash 4 reserved keywords
	*/
	private static function __resolve(o:Object):Object {
		if (typeof o == 'string') {
/*			switch (o) {
				case 'lt':	return CharacterEntity.LT; 
				case 'gt':	return CharacterEntity.GT;
				case 'not': return CharacterEntity.NOT;
				case 'and': return CharacterEntity.AND;
				case 'or':  return CharacterEntity.OR;
				case 'ne':  return CharacterEntity.NE;
				case 'le':  return CharacterEntity.LE;
				case 'ge':  return CharacterEntity.GE;
			}*/
		}
		
		return null;
	}
	
	//@----------------------------------------------------------   EVENT LISTENERS
		
	
}
}