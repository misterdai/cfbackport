<!---<cfsetting showdebugoutput="true" requesttimeout="180"/>--->

<cfscript>
	startTime = getTickCount();
	results = createObject("component", "mxunit.runner.DirectoryTestSuite").run(expandPath("."), "cfbackport.test");
</cfscript>

<cfoutput>
	#results.getResultsOutput("html")#
	<p>
		Total Test Time: 
		#(getTickCount() - startTime) / 1000# 
		seconds
	</p>
	<br/>
</cfoutput>
