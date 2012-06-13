<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/plax.js"></script>
	<script type="text/javascript" src="/ui/js/spire-index.js"></script>
	<link rel="stylesheet" href="/ui/css/homeanimation.css" type="text/css" media="screen" />
</cfsavecontent>
<cfhtmlhead text="#pageHead#">
<body>
	<div id="header2">
		<div id="shell">
		  <img src="/ui/images/plaximg/dot1.png" width="22" height="14" id="plax-dot-1" class="header-dot" />
          <img src="/ui/images/plaximg/dot2.png" width="23" height="14" id="plax-dot-2" class="header-dot" />
          <img src="/ui/images/plaximg/dot3.png" width="25" height="12" id="plax-dot-3" class="header-dot" />
          <img src="/ui/images/plaximg/dot4.png" width="19" height="8" id="plax-dot-4" class="header-dot" />
          <img src="/ui/images/plaximg/dot5.png" width="23" height="14" id="plax-dot-5" class="header-dot" />
          <img src="/ui/images/plaximg/dot6.png" width="23" height="14" id="plax-dot-6" class="header-dot" />
          <img src="/ui/images/plaximg/dot7.png" width="19" height="8" id="plax-dot-7" class="header-dot" />
          <img src="/ui/images/plaximg/dot8.png" width="23" height="14" id="plax-dot-8" class="header-dot" />
          <img src="/ui/images/plaximg/dot9.png" width="23" height="14" id="plax-dot-9" class="header-dot" />
          <img src="/ui/images/plaximg/dot10.png" width="19" height="8" id="plax-dot-10" class="header-dot" />
          <img src="/ui/images/plaximg/dot11.png" width="23" height="14" id="plax-dot-11" class="header-dot" />
          <img src="/ui/images/plaximg/dot12.png" width="19" height="8" id="plax-dot-12" class="header-dot" />
          <img src="/ui/images/plaximg/dot13.png" width="23" height="14" id="plax-dot-13" class="header-dot" />
          <img src="/ui/images/plaximg/dot14.png" width="23" height="14" id="plax-dot-14" class="header-dot" />
          <img src="/ui/images/plaximg/dot15.png" width="23" height="13" id="plax-dot-15" class="header-dot" />
          <img src="/ui/images/plaximg/dot16.png" width="23" height="14" id="plax-dot-16" class="header-dot" />
          <img src="/ui/images/plaximg/dot17.png" width="23" height="14" id="plax-dot-17" class="header-dot" />
          <img src="/ui/images/plaximg/dot18.png" width="19" height="8" id="plax-dot-18" class="header-dot" />
          <img src="/ui/images/plaximg/dot19.png" width="23" height="14" id="plax-dot-19" class="header-dot" />
          <img src="/ui/images/plaximg/step1.png" width="111" height="83" id="plax-step-1" class="header-wave" />
          <img src="/ui/images/plaximg/step2.png" width="110" height="80" id="plax-step-2" class="header-wave" />
          <img src="/ui/images/plaximg/step3.png" width="116" height="74" id="plax-step-3" class="header-wave" />
          <img src="/ui/images/plaximg/step4.png" width="149" height="110" id="plax-step-4" class="header-wave-extra" />
          <img src="/ui/images/plaximg/step5.png" width="133" height="125" id="plax-step-5" class="header-wave" />
          <img src="/ui/images/plaximg/step6.png" width="210" height="149" id="plax-step-6" class="header-wave" />
          <img src="/ui/images/plaximg/step7.png" width="193" height="170" id="plax-step-7" class="header-wave" />
          <img src="/ui/images/plaximg/step8.png" width="281" height="86" id="plax-step-8" class="header-wave" />
          <img src="/ui/images/plaximg/step9.png" width="179" height="155" id="plax-step-9" class="header-wave" />
          <img src="/ui/images/plaximg/step10.png" width="266" height="275" id="plax-step-10" class="header-wave" />
          <img src="/ui/images/plaximg/step11.png" width="242" height="214" id="plax-step-11" class="header-wave-extra" />
          <img src="/ui/images/plaximg/step12.png" width="250" height="217" id="plax-step-12" class="header-wave" />
          <img src="/ui/images/plaximg/step13.png" width="282" height="176" id="plax-step-13" class="header-wave-extra" />
          <img src="/ui/images/plaximg/crane.png" width="789" height="402" id="plax-crane" />
			<div id="splash">
				<p>Strategy.<br />Technology.<br />Design.</p>
				<div id="splashContent">
					Founded in 1998, SpireMedia is a consulting firm that architects, designs, and develops web and mobile solutions for the world's top companies. Our mission is simple: to make technology more meaningful, more useful, and more successful.
				</div> <!--  end splashContent -->
			   <a href="/what-we-do"><img src="/ui/images/btn_red.png" width="31" height="31" id="redbutton" /></a>
			</div><!-- end splash -->
		</div><!--end shell -->
		
		<div id="head2">
	    	<div id="logo"><a href="/"></a></div>
			#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=topnav')#
		</div><!-- end head2 -->
	</div><!-- end header2 -->
			
	<div id="mainIndex">
		<div id="main2">
			<div id="miMain">
        		#showContentObject('hometim', 'News', 'moduleaction=home')#
				<div class="mimRight">
	            	<div class="boxTitle">Clients</div>
	                <div class="logoClients">
	                	<div class="lc-box clientDish clientLogoPadding" id="0"></div>
	                    <div class="lc-box clientUsda clientLogoPadding" id="1"></div>
	                    <div class="lc-box clientWesternUnion clientLogoPadding" id="2"></div>
	                    <div class="lc-box clientRac clientLogoPadding" id="3"></div>
	                    <div class="lc-box clientIntermountain clientLogoPadding" id="4"></div>
	                    <div class="lc-box clientCharter clientLogoPadding" id="5"></div>
	                    <div class="lc-box clientFirstData clientLogoPadding" id="6"></div>
	                    <div class="lc-box clientToys clientLogoPadding" id="7" ></div>
	                    <div class="lc-box clientCochlear clientLogoPadding" id="8"></div>
	                    <div class="lc-box clientDell clientLogoPadding" id="9"></div>
	                    <div class="lc-box clientCorn clientLogoPadding" id="10"></div>
	                    <div class="lc-box clientVw clientLogoPadding" id="11"></div>
	                    <div class="clearfloat"></div>
	                </div><!--- <<<< end .logoClients --->
                	<div class="boxClients">
						<div class="btn-closeic"></div>
                    	<div class="bc-slide">	
							<ul id="sliderClient">
								<li>
							    	<div class="bcs-img"><img src="/ui/images/logo_dish_big.png" /></div>
							        <div class="bcs-desc">For more than 7 years, the satellite broadcaster has looked to Spire as its outsourced web team.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_usda_big.png" /></div>
							        <div class="bcs-desc">Spire's user experience consulting team is defining and architecting the user interfaces for next generation conservationist tools.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_westernunion_big.png" /></div>
							        <div class="bcs-desc">Spire helps this legendary financial services and communications company build web and mobile applications that fuel their e-commerce initiatives.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_rac_big.png" /></div>
							        <div class="bcs-desc">iPad-based corporate training, messaging, and KPI management are all made possible by Spire for this furniture and electronics rental company.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_intermountain_big.png" /></div>
							        <div class="bcs-desc">This medical powerhouse works with Spire to build clinical iPad applications that are integral to lifesaving procedures.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_charter_big.png" /></div>
							        <div class="bcs-desc">The nation's fourth-largest cable operator manages all of its digital assets on a proprietary platform built and maintained by Spire.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_firstdata_big.png" /></div>
							        <div class="bcs-desc">With this international payment processing company, Spire is building the mobile applications that will shape the future of portable finance.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_toysrus_big.png" /></div>
							        <div class="bcs-desc">Geoffrey the Giraffe and his colleagues look to Spire for user experience consulting and graphic design for their corporate web properties.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_cochlear_big.png" /></div>
							        <div class="bcs-desc">For the world leader in advanced hearing technologies, Spire developed a self-service community for patients and volunteers to share ideas on social channels.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_dell_big.png" /></div>
							        <div class="bcs-desc">The ubiquitous computer company utilized Spire to develop microsites and digital marketing materials.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_corn_big.png" /></div>
							        <div class="bcs-desc">The corn industry's trade association works with Spire to develop digital advocacy tools that highlight the many uses of this major crop.</div>
							    </li>
							    <li>
							    	<div class="bcs-img"><img src="/ui/images/logo_vw_big.png" /></div>
							        <div class="bcs-desc">Spire helped the automaker reimagine its cars online with animation and motion graphics.</div>
							    </li>							    
							</ul>          
                    	</div>
	                    <div class="bc-control">
	                        <div class="btn-c1" id="prevClient"></div>
	                        <div class="btn-c2"><a href="/our-work"></a></div>
	                        <div class="btn-c3" id="nextClient"></div>
	                        <div class="clearfloat"></div>
	                    </div>
                	</div><!-- end .boxClients -->
           		</div><!-- end .mimRight -->
            
            	<div class="clearfloat page-bottom"></div>
        	</div><!--  end miMain -->
    	</div><!--  end main -->
	</div><!-- end mainIndex -->
	<div id="fContainer">
		<cfinclude template="../footer.cfm">
	</div>
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#
</body>
</html>
</cfoutput>