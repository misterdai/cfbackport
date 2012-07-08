
<!---
Based upon http://cflib.org/udf/Throw, modified to match CF9 throw() argument order
--->
<cffunction returnType="void" name="throw" output="false" hint="CFML Throw wrapper">
	<cfargument name="message" type="string" default="" hint="Message for Exception">
	<cfargument name="type" type="string" default="Application" hint="Type for Exception">
	<cfargument name="detail" type="string" default="" hint="Detail for Exception">
	<cfargument name="errorCode" type="string" default="" hint="Error Code for Exception">
	<cfargument name="extendedInfo" type="string" default="" hint="Extended Info for Exception">
	<cfargument name="object" type="any" hint="Object for Exception">
    
	<cfif NOT IsDefined("arguments.object")>
		<cfthrow message="#arguments.message#" type="#arguments.type#" detail="#arguments.detail#" errorCode="#arguments.errorCode#" extendedInfo="#arguments.extendedInfo#">
	<cfelse>
		<cfthrow object="#arguments.object#">
	</cfif>
    
</cffunction>