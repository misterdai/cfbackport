<cffunction name="QueryExecute" output="false" returntype="query">
	<cfargument name="sql_statement" required="true">
	<cfargument name="queryParams"  default="#structNew()#">
	<cfargument name="queryOptions" default="#structNew()#">

	<cfset arguments.parameters = []>
	
	<cfif isArray(queryParams)>
		<cfloop array="#queryParams#" index="local.param">
			<cfif isSimpleValue(param)>
				<cfset arrayAppend(parameters, {value=param})>
			<cfelse>
				<cfset arrayAppend(parameters, param)>
			</cfif>
		</cfloop>
	<cfelseif isStruct(queryParams)>
		<cfloop collection="#queryParams#" item="local.key">
			<cfif isSimpleValue(queryParams[key])>
				<cfset arrayAppend(parameters, {name=local.key, value=queryParams[key]})>
			<cfelse>
				<cfset arrayAppend(parameters, queryParams[key])>
			</cfif>
		</cfloop>
	<cfelse>
		<cfthrow message="unexpected type for queryParams">
	</cfif>
	
	<cfreturn new Query(sql=sql_statement, parameters=parameters, argumentCollection=queryOptions).execute().getResult()>
</cffunction>
