<cfset lcl.activity = getDataItem('recentActivity')>

<cfoutput query="lcl.activity">
	<p>#dateformat(created, "mm/dd/yyyy")# #timeformat(created,"hh:mm tt")# <b>#fullname#</b> #Description#</p>
</cfoutput>