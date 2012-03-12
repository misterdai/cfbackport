<cffunction name="GetApplicationMetadata" output="false" returntype="struct">
	<cfset var lc = StructNew() />
	<cfif IsDefined("application")>
		<cfreturn application.getApplicationSettings() />
	</cfif>
	<cfreturn StructNew() />
</cffunction>

<cffunction name="ArraySlice" output="false" returntype="array" description="Returns part of an array, as specified">
	<cfargument name="array" type="array" required="true" />
	<cfargument name="offset" type="numeric" required="true" />
	<cfargument name="length" type="numeric" required="false" />
	<cfset var lc = StructNew() />
	<cfif Not StructKeyExists(arguments, "length")>
		<cfset lc.from = arguments.offset - 1 />
		<cfset arguments.length = ArrayLen(arguments.array) - lc.from />
	<cfelseif arguments.offset Lt 0>
		<cfset lc.from = ArrayLen(arguments.array) + arguments.offset />
	<cfelse>
		<cfset lc.from = arguments.offset - 1 />
	</cfif>
	<cfset lc.to = lc.from + arguments.length />
	<!--- subList(from [inclusive], to [exclusive]), start index is 0 --->
	<cfreturn arguments.array.subList(lc.from, lc.to) />
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