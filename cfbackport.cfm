<cfsilent>
	<cfscript>
		local.product = StructNew();
		local.product.major = ListFirst(server.coldfusion.productVersion);
		local.product.minor = ListFirst(Replace(ListDeleteAt(server.coldfusion.productVersion, 1), ",", "."));
	</cfscript>
	<cfif local.product.major lt 9>
		<cfinclude template="cf9.cfm" />
	</cfif>
	<cfif local.product.major lt 10>
		<cfinclude template="cf10.cfm" />
	</cfif>
	<cfif local.product.major lt 11 AND local.product.major gte 9>
		<cfinclude template="cf11.cfm" />
	</cfif>
</cfsilent>
