<cfoutput>
<cfdump var="#variables.requestObject.getformurlvar('path')#">
<cfif variables.requestObject.getformurlvar('path') eq "/">
	<div id="header2">
    	<div id="shell">
          <img src="/ui/images/plaximg/dot1.png" width="22" height="14" id="plax-dot-1" />
          <img src="/ui/images/plaximg/dot2.png" width="23" height="14" id="plax-dot-2" />
          <img src="/ui/images/plaximg/dot3.png" width="18" height="8" id="plax-dot-3" />
          <img src="/ui/images/plaximg/dot4.png" width="19" height="8" id="plax-dot-4" />
          <img src="/ui/images/plaximg/dot5.png" width="23" height="14" id="plax-dot-5" />
          <img src="/ui/images/plaximg/dot6.png" width="23" height="14" id="plax-dot-6" />
          <img src="/ui/images/plaximg/dot7.png" width="19" height="8" id="plax-dot-7" />
          <img src="/ui/images/plaximg/dot8.png" width="23" height="14" id="plax-dot-8" />
          <img src="/ui/images/plaximg/dot9.png" width="23" height="14" id="plax-dot-9" />
          <img src="/ui/images/plaximg/dot10.png" width="19" height="8" id="plax-dot-10" />
          <img src="/ui/images/plaximg/dot11.png" width="23" height="14" id="plax-dot-11" />
          <img src="/ui/images/plaximg/dot12.png" width="19" height="8" id="plax-dot-12" />
          <img src="/ui/images/plaximg/dot13.png" width="23" height="14" id="plax-dot-13" />
          <img src="/ui/images/plaximg/dot14.png" width="23" height="14" id="plax-dot-14" />
          <img src="/ui/images/plaximg/dot15.png" width="19" height="8" id="plax-dot-15" />
          <img src="/ui/images/plaximg/dot16.png" width="23" height="14" id="plax-dot-16" />
          <img src="/ui/images/plaximg/dot17.png" width="23" height="14" id="plax-dot-17" />
          <img src="/ui/images/plaximg/dot18.png" width="19" height="8" id="plax-dot-18" />
          <img src="/ui/images/plaximg/dot19.png" width="23" height="14" id="plax-dot-19" />
          <img src="/ui/images/plaximg/step1.png" width="111" height="83" id="plax-step-1" />
          <img src="/ui/images/plaximg/step2.png" width="110" height="80" id="plax-step-2" />
          <img src="/ui/images/plaximg/step3.png" width="116" height="74" id="plax-step-3" />
          <img src="/ui/images/plaximg/step4.png" width="149" height="110" id="plax-step-4" />
          <img src="/ui/images/plaximg/step5.png" width="133" height="125" id="plax-step-5" />
          <img src="/ui/images/plaximg/step6.png" width="210" height="149" id="plax-step-6" />
          <img src="/ui/images/plaximg/step7.png" width="193" height="170" id="plax-step-7" />
          <img src="/ui/images/plaximg/step8.png" width="281" height="86" id="plax-step-8" />
          <img src="/ui/images/plaximg/step9.png" width="179" height="155" id="plax-step-9" />
          <img src="/ui/images/plaximg/step10.png" width="266" height="274" id="plax-step-10" />
          <img src="/ui/images/plaximg/step11.png" width="242" height="214" id="plax-step-11" />
          <img src="/ui/images/plaximg/step12.png" width="250" height="206" id="plax-step-12" />
          <img src="/ui/images/plaximg/step13.png" width="281" height="176" id="plax-step-13" />
          <img src="/ui/images/plaximg/crane.png" width="641" height="437" id="plax-crane" />
          <div id="splash">
            <p>Strategy.<br />Technology.<br />Design.</p>
            <div id="splashContent">Founded in 1998, SpireMedia is a consulting firm that architects, designs, and develops web and mobile solutions for the world's top companies. Our mission is simple: to make technology more meaningful, more useful, and more successful.
			</div> <!---  end #splashContent --->
            <a href="/who-we-are"><img src="/ui/images/btn_red.png" width="31" height="31" id="redbutton" /></a>
          </div>
          <!---<img src="/ui/images/words.png" width="451" height="231" id="words" /> --->
    	</div><!--- end shell --->
		<div id="head2">
	    	<div id="logo"><a href="/"></a></div>
	        <div id="nav">
	        	<ul class="topnav">
	            <li><a href="what-we-do">WHAT WE DO</a></li>
	            <li><a href="our-work">OUR WORK</a></li>
	            <li><a href="who-we-are">WHO WE ARE</a></li>
	            <li><a href="spire-news">SPIRE NEWS</a></li>
	            </ul>
	            <div class="clearfloat"></div>
	        </div>        
	    </div><!--- >>>> end #head2 --->
	</div><!--- >>>>>> end #header2 --->
</cfif>

<div id="loading-image">
	<img src="/ui/images/loading2.gif" />
</div>
<div id="header">
	<div id="head">
    	<div id="logo"><a href="/"></a></div>
        <div id="nav">
        	<ul class="topnav">
			<cfif variables.requestObject.getformurlvar('path') eq "what-we-do/">
            	<li><a href="what-we-do" class="active">WHAT WE DO</a></li>
			<cfelse>
				<li><a href="what-we-do">WHAT WE DO</a></li>
			</cfif>
			<cfif variables.requestObject.getformurlvar('path') eq "our-work/">
				<li><a href="##" class="active btn-ow">OUR WORK</a></li>
			<cfelse>
            	<li><a href="our-work">OUR WORK</a></li>
			</cfif>
            <cfif variables.requestObject.getformurlvar('path') eq "who-we-are/">
				<li><a href="##" class="active btn-wwa">WHO WE ARE</a></li>
			<cfelse>
				<li><a href="who-we-are">WHO WE ARE</a></li>
			</cfif>
			<cfif variables.requestObject.getformurlvar('path') eq "spire-news/">
            	<li><a href="spire-news" class="active">SPIRE NEWS</a></li>
			<cfelse>
				<li><a href="spire-news">SPIRE NEWS</a></li>
			</cfif>
            </ul>
            <div class="clearfloat"></div>
            <cfif variables.requestObject.getformurlvar('path') eq "what-we-do/">
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/what-we-do/##ux-design" class="btn-uxd">UX DESIGN</a></li>
			            <li><a href="/what-we-do/##visual-design" class="btn-vd">VISUAL DESIGN</a></li>
			            <li><a href="/what-we-do/##web-development" class="btn-wd">WEB DEVELOPMENT</a></li>
			            <li><a href="/what-we-do/##mobile-development" class="btn-md">MOBILE DEVELOPMENT</a></li>
		            </ul>
		   		</div>
			</cfif>
			<cfif listcontainsnocase(variables.requestObject.getformurlvar('path'), "our-work/")>
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/our-work/##web" class="btn-web">WEB</a></li>
			            <li><a href="/our-work/##mobile" class="btn-mobile">MOBILE</a></li>
			            <li><a href="/our-work/##client-list" class="btn-client">CLIENT LIST</a></li>
		            </ul>
	            </div>
			</cfif>
			<cfif variables.requestObject.getformurlvar('path') eq "who-we-are/">
				<div class="nav2">
		            <ul class="subnav">
			            <li><a href="/who-we-are/##leadership" class="btn-leadership">LEADERSHIP</a></li>
			            <li><a href="/who-we-are/##history" class="btn-history">HISTORY</a></li>
			            <li><a href="/who-we-are/##careers" class="btn-careers">CAREERS</a></li>
		            </ul>
	            </div>
			</cfif>
        </div>        
    </div><!--- >>>> end #head --->
</div><!--- >>>>>> end #header --->
</cfoutput>

