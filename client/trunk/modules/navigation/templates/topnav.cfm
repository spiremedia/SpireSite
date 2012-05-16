
        <div id="nav">
        	<ul class="topnav">
            <li><a href="/what-we-do/" class="<cfif refindnocase("^what-we-do/", variables.requestObject.getformurlvar('path'))>active</cfif>" >WHAT WE DO</a></li>
            <li><a href="/our-work/" class="<cfif refindnocase("^our-work/", variables.requestObject.getformurlvar('path'))>active</cfif>">OUR WORK</a></li>
            <li><a href="/who-we-are/" class="<cfif refindnocase("^who-we-are/", variables.requestObject.getformurlvar('path'))>active</cfif>">WHO WE ARE</a></li>
            <li><a href="/spire-news/" class="<cfif refindnocase("^spire-news/", variables.requestObject.getformurlvar('path'))>active</cfif>">SPIRE NEWS</a></li>
            </ul>
            <div class="clearfloat"></div>
            <cfif variables.requestObject.getformurlvar('path') eq "what-we-do/">
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/what-we-do/#ux-design" class="btn-uxd">UX DESIGN</a></li>
			            <li><a href="/what-we-do/#visual-design" class="btn-vd">VISUAL DESIGN</a></li>
			            <li><a href="/what-we-do/#web-development" class="btn-wd">WEB DEVELOPMENT</a></li>
			            <li><a href="/what-we-do/#mobile-development" class="btn-md">MOBILE DEVELOPMENT</a></li>
		            </ul>
		   		</div>
			<cfelseif listcontainsnocase(variables.requestObject.getformurlvar('path'), "our-work/")>
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/our-work/#web" class="btn-web">WEB</a></li>
			            <li><a href="/our-work/#mobile" class="btn-mobile">MOBILE</a></li>
			            <li><a href="/our-work/#client-list" class="btn-client">CLIENT LIST</a></li>
		            </ul>
	            </div>
			<cfelseif variables.requestObject.getformurlvar('path') eq "who-we-are/">
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/who-we-are/#leadership" class="btn-leadership">LEADERSHIP</a></li>
			            <li><a href="/who-we-are/#history" class="btn-history">HISTORY</a></li>
			            <li><a href="/who-we-are/#careers" class="btn-careers">CAREERS</a></li>
		            </ul>
	            </div>
			</cfif>
        </div>        