<cfsilent>
	<cfscript>
		cfbackport = StructNew();
		cfbackport.major = ListFirst(server.coldfusion.productVersion);
		cfbackport.minor = ListFirst(Replace(ListDeleteAt(server.coldfusion.productVersion, 1), ",", "."));
	</cfscript>
	<cfif cfbackport.major lt 9>
		<cfinclude template="cf9.cfm" />
	</cfif>
	<cfif cfbackport.major lt 10>
		<cfinclude template="cf10.cfm" />
	</cfif>
	<cfif cfbackport.major lt 11>
		<cfinclude template="cf11.cfm" />
	</cfif>
</cfsilent>