<cfcomponent output="false">

	<cfscript>
		this.name = "cfbackport" & hash(getCurrentTemplatePath());
	</cfscript>
	
</cfcomponent>