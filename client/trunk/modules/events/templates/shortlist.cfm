<h2><cfoutput>#variables.data.label#</cfoutput></h2>
<div>
	<cfoutput query="variables.eventslist" maxrows="#variables.data.pageing#">
		<p>		
			<a class="shortListLink" href="/NewsAndEvents/Events/#id#/">#dateformat(startdate, "mm.dd.yy")#:</a>
			#title#
		</p>
	</cfoutput>
</div>
<p>
	<a class="right" href="/NewsAndEvents/Events/" style="padding-right:25px;">View All Events &raquo;</a>&nbsp;
</p>