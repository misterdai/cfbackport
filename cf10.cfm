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
		lc.sessionId = session.cfid & '_' & session.cftoken;

		// Fire onSessionEnd
		lc.appEvents = application.getEventInvoker();
		lc.args = [application, session];
		lc.appEvents.onSessionEnd(lc.args);

		// Make sure that session is empty
		StructClear(session);

		// Clean up the session
		lc.sessionTracker = CreateObject("java", "coldfusion.runtime.SessionTracker");
		lc.sessionTracker.cleanUp(application.applicationName, lc.sessionId);


	</cfscript>
</cffunction>

<!---
Done
	ArraySlice			http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSf23b27ebc7b554b647112c9713585f0e10e-8000.html

Skipped
	* The following can't be backported as we can't force arrays to be passed by reference
	ArrayEach			http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSf23b27ebc7b554b6-179bf6ef13585ac1b4d-8000.html
	ArrayFilter			http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSf23b27ebc7b554b6-179bf6ef13585ac1b4d-7fff.html


To do
	ArrayFindAll		http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSf23b27ebc7b554b6-5b4bf12a13585ace297-8000.html
	ArrayFindNoCase		http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WS98CF660A-0C9E-4e85-BBA1-89862B60EB4D.html
	SessionInvalidate	http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WS932f2e4c7c04df8f-23f56e61353e3d07d1-8000.html
	SessionRotate		http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WS932f2e4c7c04df8f-23f56e61353e3d07d1-7fff.html
	SessionStartTime	http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSf23b27ebc7b554b6-67fd180f13585b7069d-8000.html
--->
