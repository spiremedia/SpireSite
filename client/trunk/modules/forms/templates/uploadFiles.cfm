<cfoutput>
	<cffile action="upload" destination="#expandpath('./upload')#" nameconflict="makeunique" filefield="myupload"> <cfoutput>#serializeJSON({STATUS=200,MESSAGE='Passed'})#</cfoutput>
</cfoutput>