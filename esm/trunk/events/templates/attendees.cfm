<cfset lcl.info = getDataItem('info')>
<cfset lcl.attendees = getDataItem('attendees')>
<cfif securityObj.isallowed("Events","View Attendees")>
	<cfif lcl.attendees.recordcount>
		<a href="../downloadxls/?id=<cfoutput>#lcl.info.getId()#</cfoutput>" target="_blank">Download XLS</a>
		<ul>
		<cfoutput query="lcl.attendees">
		<li>#title# #fname# #lname#, #phone#, #companyname#, #dateformat(signupdatetime,"mm/dd/yy")# #timeformat(signupdatetime,"hh:mm tt")#</li></cfoutput>
		</ul>
	<cfelse>
		No Attendees have registered yet.
	</cfif>
<cfelse>
	Permissions not set to view Attendees.
</cfif>