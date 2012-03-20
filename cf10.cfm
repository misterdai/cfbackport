<!--- Temporary structure to hold information while we build functions --->
<cfset cfbackport = StructNew() />

<cffunction name="GetApplicationMetadata" output="false" returntype="struct">
  <cfscript>
    var lc = StructNew();
    if (IsDefined("application")) {
      lc.settings = Duplicate(application.getApplicationSettings());
      for (lc.key in lc.settings) {
        if (IsCustomFunction(lc.settings[lc.key])) {
          StructDelete(lc.settings, lc.key);
        }
      }
      if (StructKeyExists(lc.settings, "scriptProtect") And Len(lc.settings.scriptProtect)) {
        lc.settings.scriptProtect = ListToArray(UCase(lc.settings.scriptProtect));
      }
      return lc.settings;
    }
    return StructNew();
  </cfscript>
</cffunction>

<!--- Mimic duplicate form field names as arrays --->
<cfscript>
  cfbackport.app = GetApplicationMetadata();
  if (StructKeyExists(cfbackport.app, 'sameFormFieldsAsArray') And cfbackport.app.sameFormFieldsAsArray) {
    //
  }
</cfscript>

<cffunction name="ArraySlice" output="false" returntype="array" description="Returns part of an array, as specified">
  <cfargument name="array" type="array" required="true" />
  <cfargument name="offset" type="numeric" required="true" />
  <cfargument name="length" type="numeric" required="false" />
  <cfscript>
    var lc = StructNew();
    if (Not StructKeyExists(arguments, "length")) {
      lc.from = arguments.offset - 1;
      arguments.length = ArrayLen(arguments.array) - lc.from;
    } else if (arguments.offset Lt 0) {
      lc.from = ArrayLen(arguments.array) + arguments.offset;
    } else {
      lc.from = arguments.offset - 1;
    }
    lc.to = lc.from + arguments.length;
    // subList(from [inclusive], to [exclusive]), start index is 0
    lc.slice = arguments.array.subList(lc.from, lc.to);
    // Slice is the wrong type java.util.Collections$SynchronizedRandomAccessList#
    // Recreate as a normal CF array
    lc.array = ArrayNew(1);
    lc.array.addAll(lc.slice);
    return lc.array;
  </cfscript>
</cffunction>

<cffunction name="SessionInvalidate" output="false" returntype="void">
  <cfscript>
    var lc = StructNew();
    lc.sessionId = session.cfid & '_' & session.cftoken;

    // Fire onSessionEnd
    lc.appEvents = application.getEventInvoker();
    lc.args = ArrayNew(1);
    lc.args[1] = application;
    lc.args[2] = session;
    lc.appEvents.onSessionEnd(lc.args);

    // Make sure that session is empty
    StructClear(session);

    // Clean up the session
    lc.sessionTracker = CreateObject("java", "coldfusion.runtime.SessionTracker");
    lc.sessionTracker.cleanUp(application.applicationName, lc.sessionId);
  </cfscript>
</cffunction>

<cffunction name="SessionStartTime" output-="false" returntype="date">
  <cfscript>
    var lc = StructNew();
    lc.mirror = ArrayNew(1);
    lc.class = lc.mirror.getClass().forName("coldfusion.runtime.SessionScope");
    // See blog post for how "mStartTime" was found.
    lc.start = lc.class.getDeclaredField("mStartTime");
    lc.start.setAccessible(true);
    // Credit to Styggiti http://rob.brooks-bilson.com/index.cfm/2007/10/11/Some-Notes-on-Using-Epoch-Time-in-ColdFusion
    return DateAdd("s", lc.start.get(session) / 1000, DateConvert("utc2Local", "January 1 1970 00:00:00"));
  </cfscript>
</cffunction>

<cffunction name="CallStackGet" output="false" returntype="array">
  <cfscript>
    var lc = StructNew();
    lc.trace = CreateObject("java", "java.lang.Throwable").getStackTrace();
    lc.op = ArrayNew(1);
    lc.elCount = ArrayLen(lc.trace);
    for (lc.i = 1; lc.i Lte lc.elCount; lc.i = lc.i + 1) {
      if (ListFindNoCase('runPage,runFunction', lc.trace[lc.i].getMethodName())) {
        lc.info = StructNew();
        lc.info["Template"] = lc.trace[lc.i].getFileName();
        if (lc.trace[lc.i].getMethodName() Eq "runFunction") {
          lc.info["Function"] = ReReplace(lc.trace[lc.i].getClassName(), "^.+\$func", "");
        } else {
          lc.info["Function"] = "";
        }
        lc.info["LineNumber"] = lc.trace[lc.i].getLineNumber();
        ArrayAppend(lc.op, Duplicate(lc.info));
      }
    }
    // Remove the entry for this function
    ArrayDeleteAt(lc.op, 1);
    return lc.op;
  </cfscript>
</cffunction>

<cffunction name="CallStackDump" output="false" returntype="void">
  <cfargument name="destination" required="false" type="string" default="browser" />
  <cfscript>
    var lc = StructNew();
    lc.trace = CallStackGet();
    lc.op = ArrayNew(1);
    lc.elCount = ArrayLen(lc.trace);
    // Skip 1 (CallStackDump)
    for (lc.i = 2; lc.i lte lc.elCount; lc.i = lc.i + 1) {
      if (Len(lc.trace[lc.i]["Function"]) Gt 0) {
        ArrayAppend(lc.op, lc.trace[lc.i].Template & ":" & lc.trace[lc.i]["Function"] & ":" & lc.trace[lc.i].LineNumber);
      } else {
        ArrayAppend(lc.op, lc.trace[lc.i].Template & ":" & lc.trace[lc.i].LineNumber);
      }
    }
    lc.op = ArrayToList(lc.op, Chr(10));

    if (arguments.destination Eq "browser") {
      // Use the buffer since output = false
      GetPageContext().getCFOutput().print(lc.op);
    } else if (arguments.destination Eq "console") {
      CreateObject("java", "java.lang.System").out.println(lc.op);
    } else {
      lc.fp = FileOpen(arguments.destination, "append");
      FileWrite(lc.fp, lc.op & Chr(10));
      FileClose(lc.fp);
    }
  </cfscript>
</cffunction>

<cffunction name="CsrfGenerateToken" output="false" returntype="string">
  <cfargument name="key" type="string" required="false" default="" />
  <cfargument name="random" type="string" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    // TODO: Session locking?
    if (Not StructKeyExists(session, '_cfbackportcsrf')) {
      session['_cfbackportcsrf'] = StructNew();
    }
    if (arguments.random Or Not StructKeyExists(session._cfbackportcsrf, arguments.key)) {
      lc.token = Now();
      // Throw in the datetime for a little more randomisation
      lc.times = 3;
      // Combinations = 65536^lc.times
      // e.g. 65536^3 = 281,474,976,710,656 possible values to pick from
      // This should be secure enough as the value is either per
      // generation (random=true) or only lives for the session lifetime
      for (lc.i = 1; lc.i Lte lc.times; lc.i = lc.i + 1) {
        lc.token = lc.token & RandRange(0, 65535, "SHA1PRNG");
      }
      // Hash the token, trim to 40 characters (20-bytes), upper case
      lc.token = UCase(Left(Hash(lc.token, "SHA-256"), 40));
      session._cfbackportcsrf[arguments.key] = lc.token;
    } else {
      return session._cfbackportcsrf[arguments.key];
    }
    return lc.token;
  </cfscript>
</cffunction>

<cffunction name="CsrfVerifyToken" output="false" returntype="boolean">
  <cfargument name="token" type="string" required="true" />
  <cfargument name="key" type="string" required="false" default="" />
  <cfscript>
    // TODO: Session locking?
    if (StructKeyExists(session, '_cfbackportcsrf')
      And StructKeyExists(session._cfbackportcsrf, arguments.key)
      And session._cfbackportcsrf[arguments.key] Eq arguments.token) {
      return true;
    }
    return false;
  </cfscript>
</cffunction>

<cffunction name="isClosure" output="false" returntype="boolean">
	<!--- Couldn't resist, closures cannot be backported so no test possible --->
	<cfreturn false />
</cffunction>

<cffunction name="ReEscape" output="false" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfreturn ReReplace(arguments.string, "([\[\]\(\)\^\$\.\+\?\*\-\|])", "\$1", "all") />
</cffunction>

<cffunction name="Canoncicalize" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="restrictMultiple" type="boolean" required="true" />
  <cfargument name="restrictMixed" type="boolean" required="true" />
  <cfreturn CreateObject("java", "org.owasp.esapi.ESAPI").encoder().canonicalize(arguments.string, arguments.restrictMultiple, arguments.restrictMixed) />
</cffunction>

<cffunction name="EncodeForCSS" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="strict" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    return lc.encoder.encodeForCSS(lc.encoder.canoncicalize(arguments.inputString, arguments.strict));
  </cfscript>
</cffunction>

<cffunction name="EncodeForHTML" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="strict" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    return lc.encoder.encodeForHTML(lc.encoder.canoncicalize(arguments.inputString, arguments.strict));
  </cfscript>
</cffunction>

<cffunction name="EncodeForHTMLAttribute" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="strict" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    return lc.encoder.encodeForHTMLAttribute(lc.encoder.canoncicalize(arguments.inputString, arguments.strict));
  </cfscript>
</cffunction>

<cffunction name="EncodeForJavaScript" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="strict" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    return lc.encoder.encodeForJavaScript(lc.encoder.canoncicalize(arguments.inputString, arguments.strict));
  </cfscript>
</cffunction>

<cffunction name="EncodeForURL" output="false" returntype="string">
  <cfargument name="inputString" type="string" required="true" />
  <cfargument name="strict" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    return lc.encoder.encodeForURL(lc.encoder.canoncicalize(arguments.inputString, arguments.strict));
  </cfscript>
</cffunction>

<!---
  ESAPI library requires CF9.0.1+ or have the library added manually.

  Function tags cannot be wrapped in "if" statements to exclude creation.
  Instead, test for the required ESAPI class and destroy if missing.
--->
<cfset cfbackport.temp = ArrayNew(1) />
<cftry>
  <!--- If the Java class doesn't exist, catch the exception --->
  <cfset cfbackport.temp.getClass().forName("org.owasp.esapi.ESAPI", false, JavaCast("null", "")) />
  <cfcatch type="any">
    <cfset StructDelete(variables, "Canoncicalize") />
    <cfset StructDelete(variables, "EncodeForCSS") />
    <cfset StructDelete(variables, "EncodeForHTML") />
    <cfset StructDelete(variables, "EncodeForHTMLAttribute") />
    <cfset StructDelete(variables, "EncodeForJavaScript") />
    <cfset StructDelete(variables, "EncodeForURL") />
  </cfcatch>
</cftry>

<cfset StructDelete(variables, "cfbackport") />