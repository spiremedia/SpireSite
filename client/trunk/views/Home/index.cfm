<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/plax.js"></script>
	<script type="text/javascript" src="/ui/js/spire-index.js"></script>
</cfsavecontent>
<cfhtmlhead text="#pageHead#">
<body>
	<div id="header2">
		
		
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
	                	<div class="lc-box clientDish" id="0"></div>
	                    <div class="lc-box clientUsda" id="1"></div>
	                    <div class="lc-box clientWesternUnion" id="2"></div>
	                    <div class="lc-box clientRac" id="3"></div>
	                    <div class="lc-box clientIntermountain" id="4"></div>
	                    <div class="lc-box clientCharter" id="5"></div>
	                    <div class="lc-box clientFirstData" id="6"></div>
	                    <div class="lc-box clientToys" id="7"></div>
	                    <div class="lc-box clientCochlear" id="8"></div>
	                    <div class="lc-box clientDell" id="9"></div>
	                    <div class="lc-box clientCorn" id="10"></div>
	                    <div class="lc-box clientVw" id="11"></div>
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
            
            	<div class="clearfloat"></div>
        	</div><!--  end miMain -->
    	</div><!--  end main -->
	</div><!-- end mainIndex -->
	<cfinclude template="../footer.cfm">
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#
</body>
</html>
</cfoutput>