<cfoutput>
<div class="newsList">
	<cfset lcl.df1 = "mmmm d, yyyy">
<!---	<cfif variables.data.label NEQ "">
		<h2>#variables.data.label#</h2>
	</cfif>--->
	<cfif variables.eventslist.recordcount>
    <div class="right" style="padding-bottom:0px;position:relative;top:-13px;"> 
    <select id="seleventsorder" onchange="window.location.href='/Specials-Events/events?orderby='+this.options[this.selectedIndex].text;">
        <option value="" selected>View Events by:</option>
        <option value="startdate">Date</option>
        <option value="locationname">Location</option>
    </select>
    </div>	
    <hr class="fullwidthdottedhr" />
		<ul class="bullets"> 
		<cfloop query="variables.eventslist">
        	<div class="eventItem">
			<li>
				<h4 class="newsTitle"><a href="/NewsAndEvents/Events/#id#" style="color:##940A06">#title#</a></h4>
                <span class="newsevent_subtitle">#locationname#
                
				<cfif startdate EQ enddate>
					 - #dateformat(startdate,lcl.df1)#
				<cfelseif dateformat(startdate,"myyyy") EQ dateformat(enddate,"myyyy")>
					 - #dateformat(startdate,'mmmm')# #dateformat(startdate,'d')#-#dateformat(enddate,'d')#, #dateformat(startdate,'yyyy')#
				<cfelse>
					 - #dateformat(startdate,lcl.df1)# to #dateformat(enddate,lcl.df1)#
				</cfif></span><br /><br />
      
                    #shortdescription#
				
			</li>
            <div style="float:right;padding-bottom:10px;">
            	<a href="/NewsAndEvents/Events/#id#">
            		View Full Event Details <img src="/ui/images/arrowrightdouble.png" style="position:relative;top:-2px;" />
                </a></div>
            </div>
            <hr class="fullwidthdottedhr" />
		</cfloop>
		</ul>
		#variables.pager.showPageLinks()#
		<br class="clear"/>
	<cfelse>
		<p>There are currently no items to show.</p>
	</cfif>
</div>

</cfoutput>