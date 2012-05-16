<cfoutput>
<div class="newsDetail">
	<cfif StructKeyExists(variables.data,"eventInfo")>
		<cfset lcl.df1 = "mmmm d, yyyy">
        <div class="event_container">
          <div class="left">
             <h4 class="eventdetail">When:</h4>
            <p style="margin-bottom:10px">
                <cfif variables.data.eventInfo.startdate EQ variables.data.eventInfo.enddate>
                    #dateformat(variables.data.eventInfo.startdate,lcl.df1)#
                <cfelseif dateformat(variables.data.eventInfo.startdate,"myyyy") EQ dateformat(variables.data.eventInfo.enddate,"myyyy")>
                    #dateformat(variables.data.eventInfo.startdate,'mmmm')# #dateformat(variables.data.eventInfo.startdate,'d')#-#dateformat(variables.data.eventInfo.enddate,'d')#, #dateformat(variables.data.eventInfo.startdate,'yyyy')#
                <cfelse>
                    #dateformat(variables.data.eventInfo.startdate, "dddd, mm/dd/yyyy")# - #dateformat(variables.data.eventInfo.enddate, "dddd, mm/dd/yyyy")#
                </cfif>
                <cfif isdefined("variables.data.eventInfo.starttime")>
                    <br />#variables.data.eventInfo.starttime#
                </cfif>
                <cfif isdefined("variables.data.eventInfo.endtime")>
                     - #variables.data.eventInfo.endtime#
                </cfif>
                    
            </p>
            
            
            <h4 class="eventdetail" />Where:</h4>
            <p style="margin-bottom:10px">
                #variables.data.eventInfo.locationname#<br />
                #replace(variables.data.eventInfo.location,"#chr(10)#","<br>","all")#
                <cfif variables.data.eventInfo.maplink NEQ "">
                    <a href="#variables.data.eventInfo.maplink#" target="_blank"> (Map)</a>
                </cfif>	
            </p>
            </div>
            <div class="right">
            	<cfif #variables.data.eventInfo.imageassetid# neq "">
                	<cfset imgRetriever = createObject("component","modules.assets.model")>
                    <cfset imgRetriever.init(variables.requestObject)>
                    <cfset imgpath = imgRetriever.getAsset(#variables.data.eventinfo.imageassetid#)>
                    <img src="/docs/assets/#variables.data.eventInfo.imageassetid#/#imgpath.filename#" /><BR /><BR />
                </cfif>
            </div>
		</div>
        <br class="clear" />
        <h4 class="eventdetail" />Description:</h4>
        <p style="margin-bottom:10px">
		#variables.data.eventInfo.description#
        <cfif variables.data.eventInfo.filename NEQ "">
			<!--- added the snippet to the filetype following the text  this allows to dynamically display the file extension with no dot  - so jpg and jpeg will display.  02.20.2009 ~brian --->
            <a href="/docs/assets/#variables.data.eventInfo.asset_id#/#variables.data.eventInfo.filename#" target="_blank">
                <p><br /><img style="vertical-align:middle;" src="/ui/images/doctypes/#replace(right(variables.data.eventInfo.filename, "4"), ".", "")#.gif" /> 
                Download More Information Here</p>
            </a>
		</cfif>
        </p>	
        <hr class="fullwidthdottedhrwithmargins" />
		<!-- <p><a href="/NewsAndEvents/Events/Register/#variables.data.eventInfo.id#">Register</a></p> -->
		<p><h4 class="eventdetail"><a class="eventdetail" onclick='jQuery.noConflict();jQuery("##registrationForm").show();'>RSVP for This Event</a></h4></p>
		

		<cfinclude template="register.cfm">

	<cfelse>
	   There are currently no events to show.
	</cfif>
</div>
</cfoutput>