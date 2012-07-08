<cfcomponent displayname="cfbackportTest"  extends="mxunit.framework.TestCase">

	<cfinclude template="../cfbackport.cfm" />
	
	<cffunction name="setUp" access="public" returntype="void" output="false">

		<cfscript>
			// none
		</cfscript>

	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void" output="false">

		<cfscript>
			// none
		</cfscript>

	</cffunction>

<!---
	Tests for canonicalize, encodeforHTML, encodeForHTMLAttribute, encodeForCSS, encodeForJavaScript, encodeForXML
	based from CFESAPI EncoderTest.cfc (https://github.com/damonmiller/cfesapi/raw/master/test/org/owasp/esapi/reference/EncoderTest.cfc)
--->

	<cffunction name="testCanonicalize" access="public" returntype="void" output="false" hint="Test of canonicalize">
		<cfset var local = {}/>

		<cfscript>
			// Test null paths
			assertEquals("", canonicalize("", true, true));
			assertEquals("", canonicalize("", true, false));
			assertEquals("", canonicalize("", false, true));
			assertEquals("", canonicalize("", false, false));

			// test exception paths
			assertEquals("%", canonicalize("%25", true, true));
			assertEquals("%", canonicalize("%25", false, true));

			assertEquals("%", canonicalize("%25", false, false));
			assertEquals("%F", canonicalize("%25F", false, false));
			assertEquals("<", canonicalize("%3c", false, false));
			assertEquals("<", canonicalize("%3C", false, false));
			assertEquals("%X1", canonicalize("%X1", false, false));

			assertEquals("<", canonicalize("&lt", false, false));
			assertEquals("<", canonicalize("&LT", false, false));
			assertEquals("<", canonicalize("&lt;", false, false));
			assertEquals("<", canonicalize("&LT;", false, false));

			assertEquals("%", canonicalize("&##37;", false, false));
			assertEquals("%", canonicalize("&##37", false, false));
			assertEquals("%b", canonicalize("&##37b", false, false));

			assertEquals("<", canonicalize("&##x3c", false, false));
			assertEquals("<", canonicalize("&##x3c;", false, false));
			assertEquals("<", canonicalize("&##x3C", false, false));
			assertEquals("<", canonicalize("&##X3c", false, false));
			assertEquals("<", canonicalize("&##X3C", false, false));
			assertEquals("<", canonicalize("&##X3C;", false, false));

			// percent encoding
			assertEquals("<", canonicalize("%3c", false, false));
			assertEquals("<", canonicalize("%3C", false, false));

			// html entity encoding
			assertEquals("<", canonicalize("&##60", false, false));
			assertEquals("<", canonicalize("&##060", false, false));
			assertEquals("<", canonicalize("&##0060", false, false));
			assertEquals("<", canonicalize("&##00060", false, false));
			assertEquals("<", canonicalize("&##000060", false, false));
			assertEquals("<", canonicalize("&##0000060", false, false));
			assertEquals("<", canonicalize("&##60;", false, false));
			assertEquals("<", canonicalize("&##060;", false, false));
			assertEquals("<", canonicalize("&##0060;", false, false));
			assertEquals("<", canonicalize("&##00060;", false, false));
			assertEquals("<", canonicalize("&##000060;", false, false));
			assertEquals("<", canonicalize("&##0000060;", false, false));
			assertEquals("<", canonicalize("&##x3c", false, false));
			assertEquals("<", canonicalize("&##x03c", false, false));
			assertEquals("<", canonicalize("&##x003c", false, false));
			assertEquals("<", canonicalize("&##x0003c", false, false));
			assertEquals("<", canonicalize("&##x00003c", false, false));
			assertEquals("<", canonicalize("&##x000003c", false, false));
			assertEquals("<", canonicalize("&##x3c;", false, false));
			assertEquals("<", canonicalize("&##x03c;", false, false));
			assertEquals("<", canonicalize("&##x003c;", false, false));
			assertEquals("<", canonicalize("&##x0003c;", false, false));
			assertEquals("<", canonicalize("&##x00003c;", false, false));
			assertEquals("<", canonicalize("&##x000003c;", false, false));
			assertEquals("<", canonicalize("&##X3c", false, false));
			assertEquals("<", canonicalize("&##X03c", false, false));
			assertEquals("<", canonicalize("&##X003c", false, false));
			assertEquals("<", canonicalize("&##X0003c", false, false));
			assertEquals("<", canonicalize("&##X00003c", false, false));
			assertEquals("<", canonicalize("&##X000003c", false, false));
			assertEquals("<", canonicalize("&##X3c;", false, false));
			assertEquals("<", canonicalize("&##X03c;", false, false));
			assertEquals("<", canonicalize("&##X003c;", false, false));
			assertEquals("<", canonicalize("&##X0003c;", false, false));
			assertEquals("<", canonicalize("&##X00003c;", false, false));
			assertEquals("<", canonicalize("&##X000003c;", false, false));
			assertEquals("<", canonicalize("&##x3C", false, false));
			assertEquals("<", canonicalize("&##x03C", false, false));
			assertEquals("<", canonicalize("&##x003C", false, false));
			assertEquals("<", canonicalize("&##x0003C", false, false));
			assertEquals("<", canonicalize("&##x00003C", false, false));
			assertEquals("<", canonicalize("&##x000003C", false, false));
			assertEquals("<", canonicalize("&##x3C;", false, false));
			assertEquals("<", canonicalize("&##x03C;", false, false));
			assertEquals("<", canonicalize("&##x003C;", false, false));
			assertEquals("<", canonicalize("&##x0003C;", false, false));
			assertEquals("<", canonicalize("&##x00003C;", false, false));
			assertEquals("<", canonicalize("&##x000003C;", false, false));
			assertEquals("<", canonicalize("&##X3C", false, false));
			assertEquals("<", canonicalize("&##X03C", false, false));
			assertEquals("<", canonicalize("&##X003C", false, false));
			assertEquals("<", canonicalize("&##X0003C", false, false));
			assertEquals("<", canonicalize("&##X00003C", false, false));
			assertEquals("<", canonicalize("&##X000003C", false, false));
			assertEquals("<", canonicalize("&##X3C;", false, false));
			assertEquals("<", canonicalize("&##X03C;", false, false));
			assertEquals("<", canonicalize("&##X003C;", false, false));
			assertEquals("<", canonicalize("&##X0003C;", false, false));
			assertEquals("<", canonicalize("&##X00003C;", false, false));
			assertEquals("<", canonicalize("&##X000003C;", false, false));
			assertEquals("<", canonicalize("&lt", false, false));
			assertEquals("<", canonicalize("&lT", false, false));
			assertEquals("<", canonicalize("&Lt", false, false));
			assertEquals("<", canonicalize("&LT", false, false));
			assertEquals("<", canonicalize("&lt;", false, false));
			assertEquals("<", canonicalize("&lT;", false, false));
			assertEquals("<", canonicalize("&Lt;", false, false));
			assertEquals("<", canonicalize("&LT;", false, false));

			assertEquals('<script>alert("hello");</script>', canonicalize("%3Cscript%3Ealert%28%22hello%22%29%3B%3C%2Fscript%3E", false, false));
			assertEquals('<script>alert("hello");</script>', canonicalize("%3Cscript&##x3E;alert%28%22hello&##34%29%3B%3C%2Fscript%3E", false, false));

		</cfscript>
	</cffunction>		


	<cffunction access="public" returntype="void" name="testDoubleEncodingCanonicalization" output="false" hint="Test of canonicalize">
		<cfset var local = {}/>

		<cfscript>
			// note these examples use the strict=false flag on canonicalize to allow
			// full decoding without throwing an IntrusionException. Generally, you
			// should use strict mode as allowing double-encoding is an abomination.
			// double encoding examples
			assertEquals("<", canonicalize("&##x26;lt&##59", false, false)); //double entity
			assertEquals("\", canonicalize("%255c", false, false)); //double percent
			assertEquals("%", canonicalize("%2525", false, false)); //double percent
			
			// double encoding with multiple schemes example
			assertEquals("<", canonicalize("%26lt%3b", false, false)); //first entity, then percent
			assertEquals("&", canonicalize("&##x25;26", false, false)); //first percent, then entity

			// enforce neither mixed nor multiple encoding detection -should canonicalize but not throw an error
			assertEquals("< < < < < < <", canonicalize("%26lt; %26lt; &##X25;3c &##x25;3c %2526lt%253B %2526lt%253B %2526lt%253B", false, false));

			// nested encoding examples
			assertEquals("<", canonicalize("%253c", false, false)); //nested encode % with percent
			assertEquals("<", canonicalize("%%33%63", false, false)); //nested encode both nibbles with percent
			assertEquals("<", canonicalize("%%33c", false, false)); // nested encode first nibble with percent
			assertEquals("<", canonicalize("%3%63", false, false)); //nested encode second nibble with percent
			assertEquals("<", canonicalize("&&##108;t;", false, false)); //nested encode l with entity
			assertEquals("<", canonicalize("%2&##x35;3c", false, false)); //triple percent, percent, 5 with entity
			
			// nested encoding with multiple schemes examples
			assertEquals("<", canonicalize("&%6ct;", false, false)); // nested encode l with percent
			assertEquals("<", canonicalize("%&##x33;c", false, false)); //nested encode 3 with entity
			
			// multiple encoding tests
			assertEquals("% & <script> <script>", canonicalize("%25 %2526 %26##X3c;script&##x3e; &##37;3Cscript%25252525253e", false, false));
			assertEquals("< < < < < < <", canonicalize("%26lt; %26lt; &##X25;3c &##x25;3c %2526lt%253B %2526lt%253B %2526lt%253B", false, false));

		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testCanonicalizationMultipleTrue" output="false" hint="Test of canonicalize">
		<cfset var local = {}/>

		<cfscript>
			// enforce multiple but not mixed encoding detection
			try {
				canonicalize("%252525253C", true, false);
				fail("Multiple encoding not detected");
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
			}
		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testCanonicalizationMixedTrue" output="false" hint="Test of canonicalize">
		<cfset var local = {}/>

		<cfscript>
			// enforce mixed but not multiple encoding detection
			try {
				canonicalize("%25 %2526 %26##X3c;script&##x3e; &##37;3Cscript%25252525253e", false, true);
				fail("Mixed encoding not detected. Needs ESAPI 2.0.0GA+");
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
			}
		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testCanonicalizationMultipleAndMixedTrue" output="false" hint="Test of canonicalize">
		<cfset var local = {}/>

		<cfscript>
			// enforce multiple and mixed encoding detection
			try {
				canonicalize("%26lt; %26lt; &##X25;3c &##x25;3c %2526lt%253B %2526lt%253B %2526lt%253B", true, true);
				fail("Multiple and mixed encoding not detected");
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
			}

			// test strict mode with both mixed and multiple encoding
			try {
				assertEquals("< < < < < < <", canonicalize("%26lt; %26lt; &##X25;3c &##x25;3c %2526lt%253B %2526lt%253B %2526lt%253B", true, true));
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
				// expected
			}

			try {
				assertEquals("<script", canonicalize("%253Cscript", true, true));
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
				// expected
			}

			try {
				assertEquals("<script", canonicalize("&##37;3Cscript", true, true));
			}
			catch(org.owasp.esapi.errors.IntrusionException except) {
				// expected
			}
		</cfscript>

	</cffunction>

	<cffunction access="public" returntype="void" name="testDecodeForHTML" output="false" hint="Test of decodeForHTML">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", decodeForHTML(""));
			assertEquals("<script>", decodeForHTML("&lt;script&gt;"));
			assertEquals(",.-_ ", decodeForHTML(",.-_ "));
			assertEquals("!@$%()=+{}[]", decodeForHTML("&##x21;&##x40;&##x24;&##x25;&##x28;&##x29;&##x3d;&##x2b;&##x7b;&##x7d;&##x5b;&##x5d;"));
			assertEquals("one&two", decodeForHTML("one&amp;two"));
		</cfscript>

	</cffunction>


	<cffunction name="testEncodeForHTML" access="public" returntype="void" output="false" hint="Test of encodeForHTML">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", encodeForHTML(""));
			// test invalid characters are replaced with spaces
			assertEquals("a&##xfffd;b&##xfffd;c&##xfffd;d&##xfffd;e&##xfffd;f&##x9;g", encodeForHTML("a" & chr(1) & "b" & chr(4) & "c" & chr(128) & "d" & chr(150) & "e" & chr(159) & "f" & chr(9) & "g"));

			assertEquals("&lt;script&gt;", encodeForHTML("<script>"));
			
			// CF10 and CF9 return original string
			// assertEquals("&amp;lt&##x3b;script&amp;gt&##x3b;", encodeForHTML("&lt;script&gt;"));
			
			assertEquals("&##x21;&##x40;&##x24;&##x25;&##x28;&##x29;&##x3d;&##x2b;&##x7b;&##x7d;&##x5b;&##x5d;", encodeForHTML("!@$%()=+{}[]"));
			assertEquals("&##x21;&##x40;&##x24;&##x25;&##x28;&##x29;&##x3d;&##x2b;&##x7b;&##x7d;&##x5b;&##x5d;", encodeForHTML("&##33;&##64;&##36;&##37;&##40;&##41;&##61;&##43;&##123;&##125;&##91;&##93;"));
			assertEquals(",.-_ ", encodeForHTML(",.-_ "));
			assertEquals("dir&amp;", encodeForHTML("dir&"));
			assertEquals("one&amp;two", encodeForHTML("one&two"));
			assertEquals("" & chr(12345) & chr(65533) & chr(1244), "" & chr(12345) & chr(65533) & chr(1244));
		</cfscript>

	</cffunction>

	<cffunction access="public" returntype="void" name="testEncodeForHTMLAttribute" output="false" hint="Test of encodeForHTMLAttribute">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", encodeForHTMLAttribute(""));
			assertEquals("&lt;script&gt;", encodeForHTMLAttribute("<script>"));
			assertEquals(",.-_", encodeForHTMLAttribute(",.-_"));
			assertEquals("&##x20;&##x21;&##x40;&##x24;&##x25;&##x28;&##x29;&##x3d;&##x2b;&##x7b;&##x7d;&##x5b;&##x5d;", encodeForHTMLAttribute(" !@$%()=+{}[]"));
		</cfscript>

	</cffunction>

	<cffunction access="public" returntype="void" name="testEncodeForCSS" output="false" hint="Test of encodeForCSS">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("\3c script\3e ", encodeForCSS("<script>"));
			assertEquals("\21 \40 \24 \25 \28 \29 \3d \2b \7b \7d \5b \5d ", encodeForCSS("!@$%()=+{}[]"));
		</cfscript>

	</cffunction>

	<cffunction access="public" returntype="void" name="testEncodeForJavascript" output="false" hint="Test of encodeForJavaScript">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", encodeForJavaScript(""));
			assertEquals("\x3Cscript\x3E", encodeForJavaScript("<script>"));
			assertEquals(",.\x2D_\x20", encodeForJavaScript(",.-_ "));
			assertEquals("\x21\x40\x24\x25\x28\x29\x3D\x2B\x7B\x7D\x5B\x5D", encodeForJavaScript("!@$%()=+{}[]"));
			assertEquals( "\x00", encodeForJavaScript("\0"));
			assertEquals( "\x08", encodeForJavaScript("\b"));
			assertEquals( "\x09", encodeForJavaScript("\t"));
			assertEquals( "\x0a", encodeForJavaScript("\n"));
			assertEquals( "\x0b", encodeForJavaScript("\v"));
			assertEquals( "\x0c", encodeForJavaScript("\f"));
			assertEquals( "\x0d", encodeForJavaScript("\r"));
			assertEquals( "\x27", encodeForJavaScript("\'"));
			assertEquals( '\x22', encodeForJavaScript('\"'));
			assertEquals( "\x5c", encodeForJavaScript("\\"));
		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testDecodeFromURL" output="false" hint="Test of decodeFromURL">
		<cfset var local = {}/>

		<cfscript>
				assertEquals("", decodeFromURL(""));
				assertEquals("<script>", decodeFromURL("%3Cscript%3E"));
				assertEquals("     ", decodeFromURL("+++++"));
			
			try {
				decodeFromURL("%3xridiculous");
			}
			catch(Application AppExcept) {
				// expected
			}
		</cfscript>

	</cffunction>

	<cffunction access="public" returntype="void" name="testEncodeForURL" output="false" hint="Test of encodeForURL">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", encodeForURL(""));
			assertEquals("%3Cscript%3E", encodeForURL("<script>"));
		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testEncodeForXML" output="false" hint="Test of encodeForXML">
		<cfset var local = {}/>

		<cfscript>
			assertEquals("", encodeForXML(""));
			assertEquals(" ", encodeForXML(" "));
			assertEquals("&##x3c;script&##x3e;", encodeForXML("<script>"));
			assertEquals(",.-_", encodeForXML(",.-_"));
			assertEquals("&##x21;&##x40;&##x24;&##x25;&##x28;&##x29;&##x3d;&##x2b;&##x7b;&##x7d;&##x5b;&##x5d;", encodeForXML("!@$%()=+{}[]"));
			assertEquals("&##xa3;", encodeForXML("\u00A3"));
		</cfscript>

	</cffunction>


	<cffunction access="public" returntype="void" name="testHMAC" output="false" hint="Test of HMAC">
		<cfset var local = {}/>

		<cfscript>
			// test various algorithms
			assertEquals("80070713463E7749B90C2DC24911E275", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACMD5", "UTF-8"));
			assertEquals("DE7C9B85B8B78AA6BC8A7A36F70A90701C9DB4D9", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACSHA1", "UTF-8"));
			assertEquals("F7BC83F430538424B13298E6AA6FB143EF4D59A14946175997479DBC2D1A3CD8", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACSHA256", "UTF-8"));
			assertEquals("D7F4727E2C0B39AE0F1E40CC96F60242D5B7801841CEA6FC592C5D3E1AE50700582A96CF35E1E554995FE4E03381C237", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACSHA384", "UTF-8"));
			assertEquals("B42AF09057BAC1E2D41708E48A902E09B5FF7F12AB428A4FE86653C73DD248FB82F948A549F7B791A5B41915EE4D1EC3935357E4E2317250D0372AFA2EBEEB3A", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACSHA512", "UTF-8"));
			assertEquals("50278A77D4D7670561AB72E867383AEF6CE50B3E", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACRIPEMD160", "UTF-8"));
			assertEquals("88FF8B54675D39B8F72322E65FF945C52D96379988ADA25639747E69", HMAC("The quick brown fox jumps over the lazy dog", "key", "HMACSHA224", "UTF-8"));

			// test sending binary arrays
			assertEquals("DE7C9B85B8B78AA6BC8A7A36F70A90701C9DB4D9", HMAC(CharsetDecode("The quick brown fox jumps over the lazy dog", "UTF-8"), "key", "HMACSHA1", "UTF-8"));
			assertEquals("DE7C9B85B8B78AA6BC8A7A36F70A90701C9DB4D9", HMAC("The quick brown fox jumps over the lazy dog", CharsetDecode("key", "UTF-8"), "HMACSHA1", "UTF-8"));
			assertEquals("DE7C9B85B8B78AA6BC8A7A36F70A90701C9DB4D9", HMAC(CharsetDecode("The quick brown fox jumps over the lazy dog", "UTF-8"), CharsetDecode("key", "UTF-8"), "HMACSHA1", "UTF-8"));

			// using default encoding of system and HMACMD5, could fail since test is based on UTF-8 encoding
			assertEquals("63530468A04E386459855DA0063B6596", HMAC("", "key"));
			assertEquals("80070713463E7749B90C2DC24911E275", HMAC("The quick brown fox jumps over the lazy dog", "key"));
		</cfscript>

	</cffunction>

	
</cfcomponent>