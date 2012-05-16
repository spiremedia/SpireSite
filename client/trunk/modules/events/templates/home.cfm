<cfif variables.eventsItems.recordcount>
<ul class="bullets">
<cfoutput query="variables.eventsItems">
<li>
<b>#dateformat(startdate, "mm.dd.yy")#:</b> 
<a href="/NewsAndEvents/Events/#id#/">#title#</a>
</li></cfoutput>
</ul>
<cfelse>
No Events available.
</cfif>