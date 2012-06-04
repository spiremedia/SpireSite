<cfsavecontent variable="thisJavascript">
	<SCRIPT language="JavaScript">
	function anchor_swap(thebtn) {
		$(thebtn).trigger('click');
	}
	</SCRIPT>
</cfsavecontent>
<cfoutput>
	<cfhtmlhead text="#thisJavascript#">

<div id="fContainer">
	<div id="footer">
		<div id="foot">
	    	<div class="footLeft">2911 Walnut Street  |  Denver, CO 80205  |  303.620.9974</div>
	        <div class="footRight">
	        	<div class="fr-box">
	            	<div class="title-fg"><a href="/what-we-do/">What We Do</a></div>
	            	<cfif isDefined("variables.pageinfo.urlpath") and variables.pageinfo.urlpath eq "what-we-do/">
	            		<cfset UXurl = "javascript:anchor_swap('.btn-uxd')">	  
	            		<cfset VDurl = "javascript:anchor_swap('.btn-vd')">
	            		<cfset WDurl = "javascript:anchor_swap('.btn-wd')">
	            		<cfset MDurl = "javascript:anchor_swap('.btn-md')">
	            	<cfelse>
	            		<cfset UXurl = "/what-we-do/##ux-design">
	            		<cfset VDurl = "/what-we-do/##visual-design">
	            		<cfset WDurl = "/what-we-do/##web-development">
	            		<cfset MDurl = "/what-we-do/##mobile-development">
	            	</cfif>
	            	<p><a href="#UXurl#">UX Design</a></p>
	            	<p><a href="#VDurl#">Visual Design</a></p>	                
	                <p><a href="#WDurl#">Web Development</a></p>	                
	                <p><a href="#MDurl#">Mobile Development</a></p>
	            </div>
	  
	            <div class="fr-box2">
	            	<div class="title-fg"><a href="/our-work/">Our Work</a></div>
	            	<cfif isDefined("variables.pageinfo.urlpath") and variables.pageinfo.urlpath eq "our-work/">
	            		<cfset weburl = "javascript:anchor_swap('.btn-web')">	  
	            		<cfset mobileurl = "javascript:anchor_swap('.btn-mobile')">
	            		<cfset clienturl = "javascript:anchor_swap('.btn-client')">
	            	<cfelse>
	            		<cfset weburl = "/our-work/##web">
	            		<cfset mobileurl = "/our-work/##mobile">
	            		<cfset clienturl = "/our-work/##client-list">
	            	</cfif>
	                <p><a href="#weburl#">Web</a></p>
	                <p><a href="#mobileurl#">Mobile</a></p>
	                <p><a href="#clienturl#">Client List</a></p>
	            </div>
	            <div class="fr-box3">
	            	<div class="title-fg"><a href="/who-we-are/">Who We Are</a></div>
	            	<cfif isDefined("variables.pageinfo.urlpath") and variables.pageinfo.urlpath eq "who-we-are/">
	            		<cfset leadershipurl = "javascript:anchor_swap('.btn-leadership')">	  
	            		<cfset historyurl = "javascript:anchor_swap('.btn-history')">
	            		<cfset careersurl = "javascript:anchor_swap('.btn-careers')">
	            	<cfelse>
	            		<cfset leadershipurl = "/who-we-are/##leadership">
	            		<cfset historyurl = "/who-we-are/##history">
	            		<cfset careersurl = "/who-we-are/##careers">
	            	</cfif>
	                <p><a href="#leadershipurl#">Leadership</a></p>
	                <p><a href="#historyurl#">History</a></p>
	                <p><a href="#careersurl#">Careers</a></p>
	            </div>
	            <div class="fr-box4">
	            	<div class="title-fo"><a href="" class="contactFooter">Contact Us</a></div>
	                <p><a href="/spire-news">Spire News</a></p>
	                <p><a href="/">Home</a></p>
	            </div>
	            <div class="clearfloat"></div>
	        </div>
	        <div class="clearfloat"></div>
	    </div><!--- end foot --->
	</div><!--- end footer --->
</div><!--- end fContainer --->
</cfoutput>