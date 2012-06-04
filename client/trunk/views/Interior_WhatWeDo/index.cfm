<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- what we do -->
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/spire-what.js"></script>
	<style type="text/css">
		##WWD { margin:0 auto; position:relative; overflow:hidden;}
	</style>	
</cfsavecontent>
<cfhtmlhead text="#pageHead#">
<body>
	<div id="loading-image">
		<img src="/ui/images/loading2.gif" />
	</div>
	
	<div id="header">
		<div id="head">
			<div id="logo"><a href="/"></a></div>
			#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=topnav')#
		</div><!-- end ##head2 -->
	</div><!-- end ##header2 -->
	
	<div id="mainWhat" style="height:871px;">
		<div id="main" >
			<div id="WWD" >

				<div id="main_wwd">
					<ul id="slider1">
					  <li style="margin-right:2400px;">
						<div class="bg0">
							<div id="wwd-0">
								<ul id="firstboxes">
									<li><div class="box1 btn-uxd"><a href="##ux-design">UX Design</a></div></li>
									<li><div class="box2 btn-vd"><a href="##visual-design">Visual Design</a></div></li>
									<li><div class="box3 btn-wd"><a href="##web-development">Web Development</a></div></li>
									<li><div class="box4 btn-md"><a href="##mobile-development">Mobile Development</a></div></li>
								</ul>
								<div class="clearfloat page-bottom"></div>
							</div>
						</div>
					  </li>
					  <li style="margin-right:2400px;">
						<div class="bg1">
							<div id="wwd-1">
								<div class="wwd-subbox">
									<div class="subtitle">UX Design</div>
									<div class="subcontent">
										<ul class="leftline">
											<li><span class="sz16">STRATEGY: DEFINING SUCCESS</span><br />At Spire, Strategy means leadership, at every stage of the product cycle. Spire believes real strategists ship -- we have the knowledge to theorize about solutions, but our focus is execution. We are purists about only one thing - success for our clients. The Spire strategy team has the tools and confidence to engage at any phase in the product cycle and produce solutions that drive real business results. Whether it's providing leadership to rescue a design project in crisis, or developing a disruptive new product from a basic idea, the Spire strategy team's toolkit is our process.</li>
											<li><span class="sz16">USER EXPERIENCE DESIGN</span><br />
											SpireMedia's User Experience Design team is expert in using the User-Centered Design (UCD) methodology to create products that are easy to use, intuitive, and innovative. UCD is an approach to creating solutions grounded in an understanding of the people who will use the product and the stakeholders who guide and approve it. The Spire UX Design team consistently delivers products that reward stakeholders and delight and engage customers, on time and on budget.</li>
										</ul>
									</div>
									<div class="subrightcol">
										<link rel="stylesheet" href="/ui/css/typo.css" type="text/css" />
										<link rel="stylesheet" href="/ui/css/widgets.css" type="text/css"/>
										<script type="text/javascript" src="/ui/js/jquery-ui-1.7.1.min.js"></script>
										<script type="text/javascript" src="/ui/js/jquery.accordion.min.1.7.1.js"></script>
										<div class="srbox1">Service Offerings</div>
										<div class="bclear accordion-width">
											<ul id="middleItem_1_Content_Accordion"  style="cursor:pointer;">
												<li><a>Product Strategy & Business Analysis<span class="arrow"></span></a>
														<div class="bclear">
															<p>Our Strategy and BA team gathers relevant information about the product, its users, and the rules or logic that will be embedded in the user interface. These requirements and rules, in conjunction with the knowledge of the users gained through the User-Centered Design process, form the basis of our design and development decisions.</p>
														</div>
												</li>
												<li ><a>Content Strategy<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia provides professional content-creation and messaging strategy services for Web and mobile applications. Our content strategists create, present, and maintain messaging that is relevant and enjoyable for users. We can also extend brand messaging across new channels and platforms, or produce new content to support an existing brand.</p>
														</div>
												</li>
												<li ><a>User Experience Design<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia's UX Designers have years of experience in creating user interfaces for web and mobile products. We are experts in using user-centered methods to create detailed interface designs that enable products to be built quickly and accurately, while engaging and delighting users.</p>
														</div>
												</li>
												<li ><a>Information Architecture<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia's Information Architects are skilled in organizing and labeling complex information, sites, and software to support usability and findability, and in the structural design of shared information environments.</p>
														</div>
												</li>
											</ul>
											<script type="text/javascript">
												$(function(){
													$("##middleItem_1_Content_Accordion").accordion({
														autoHeight: false, 
														active:false
													});
												});
											</script>
										</div><!--- end bclear --->
									</div><!--- subrightcol --->
								</div><!--- <<<< end .wwd-subbox --->
							</div>
						</div>
					  </li>
					  <li style="margin-right:2400px;">
						<div class="bg2">
							<div id="wwd-2">
								<div class="wwd-subbox">
									<div class="subtitle">Visual Design</div>
									<div class="subcontent">
										<ul class="leftline">
											<li><span class="sz16">Spire's visual design team is a collective of artists -- in both the traditional graphics and pure interactive disciplines. Our design approach blends authentic visual communications and user centered design (UCD) practices. Our creative process has been lauded, lionized, and imitated. The reason for this is simple -- it works.</li>
											<li><span class="sz16">From a project's inception, our visual design team collaborates with brand owners, our user experience team, and Spire's development teams to create holistic, goal-aligned innovative solutions designed to engage and resonate with the end user at each encounter.</li>
										</ul>
									</div>
									<div class="subrightcol">
										<div class="srbox1">Practice Areas</div>
										<div class="bclear accordion-width">
											<ul id="middleItem_4_Content_Accordion"  style="cursor:pointer;">
												<li><a>User Interface Design<span class="arrow"></span></a>
														<div class="bclear">
															<p>Web and mobile design that focuses on the user’s interactions and overall experience when engaged with the product to ensuring usability, efficiency, and reaction.</p>
														</div>
												</li>
												<li ><a>Data Visualization<span class="arrow"></span></a>
														<div class="bclear">
															<p>The Spire design team are experts at creating visual representations of complex information and fluid attributes using infographics and other visuals to engage and inform audiences.</p>
														</div>
												</li>
												<li ><a>Conceptual Design<span class="arrow"></span></a>
														<div class="bclear">
															<p>Leveraging information gathered during the business analysis process, we work with clients to conceptualize strategies and execute on those concepts by creating collateral, photo shoots, custom illustrations, and micro-branding vehicles.</p>
														</div>
												</li>
												<li ><a>Brand Alignment<span class="arrow"></span></a>
														<div class="bclear">
															<p>Our team has deep experience in strategic consulting and supportive design to ensure user perceptions are aligned with offline branding and marketing goals.</p>
														</div>
												</li>
											</ul>
											<script type="text/javascript">
												$(function(){
													$("##middleItem_4_Content_Accordion").accordion({
														autoHeight: false, 
														active:false
													});
												});
											</script>
										</div><!--- end bclear --->
									</div><!--- subrightcol --->
								</div><!---  end .wwd-subbox --->
							</div>
						</div>
					  </li>
					  <li style="margin-right:2400px;">
						<div class="bg3">
							<div id="wwd-3">
								<div class="wwd-subbox">
									<div class="subtitle">Web Development</div>
									<div class="subcontent">
										<ul class="leftline">
											<li><span class="sz16">SCALABLE SOLUTIONS FOR BIG IDEAS</span><br />Web application definition and design can mean nothing without a solid, scaleable technical implementation. SpireMedia's development team provides the expertise, foresight, and experience to ensure that your Big Ideas are fully realized on the Web. Development doesn't start when our User Experience team has fully defined the feature set and the UI, but rather development is involved out of the gate, ensuring that the features and functionality you are presented with are technologically feasible for implementation within your budget.</li>
											<li><span class="sz16">OBJECTIVE ANSWERS, PLATFORM-NEUTRAL</span><br />
												We are a platform-neutral development organization and are happy to work with you to define the right technology stack for your project. We leverage best-of-breed open source platforms across an array of programming languages along with our own library of code modules enabling us to build out complex web applications quickly. We use an automated cloud-based Continuous Integration, Quality Assurance, Source Code Control, and Issue Tracking environment for every project, ensuring that your codebase is always stable, available, and reliable.</li>
										</ul>
									</div>
									<div class="subrightcol">
										<div class="srbox1">Service Offerings</div>
										<div class="bclear accordion-width">
											<ul id="middleItem_2_Content_Accordion"  style="cursor:pointer;" >
												<li><a>Technology Agnostic<span class="arrow"></span></a>
														<div class="bclear">
															<p>Each member of the SpireMedia development team is a specialist in either enterprise .NET, Java, component-based ColdFusion, Flex or Flash development. The SpireMedia team is extremely strong in popular open-source languages like PHP and Ruby. Our database architects are proficient in Oracle, SQL Server, Postgres, and MySQL. SpireMedia Tech Leads typically have at least 10 years of web development experience.</p>
														</div>
												</li>
												<li ><a>CMS Experts<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia has been developing and fine-tuning content management systems for over 12 years.  We specialize in Drupal, Joomla, Umbraco and our own platform, SpireESM.</p>
														</div>
												</li>
												<li ><a>Web Application Development<span class="arrow"></span></a>
														<div class="bclear">
															<p>On the web, implementation requires knowledge, foresight, and experience. SpireMedia's Development team embraces those core values and offers clients platform-agnostic web development services that meet and exceed their business objectives.</p>
														</div>
												</li>
												<li ><a>Web Site Development<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia provides full-service design and development offerings for clients who do not have the resources in house or who are just too busy doing their jobs to worry about their web sites.</p>
														</div>
												</li>
												<li ><a>eCommerce<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia offers a range of expertise from simply integrating your site with payment gateway to working with best-of-breed eCommerce packages such as Commersus, AbleCommerce, Drupal/Ubercart, Shopify, and Magento to create a truly unique solution for your online business. SpireMedia can also work with clients to build revolutionary custom eCommerce systems that broaden the scope of the medium and allow for endless sales for an emerging company.</p>
														</div>
												</li>
											</ul>
											<script type="text/javascript">
												$(function(){
													$("##middleItem_2_Content_Accordion").accordion({
														autoHeight: false, 
														active:false
													});
												});
											</script>
										</div><!--- bclear --->
									</div><!--- subrightcol --->
								</div><!---  end wwd-subbox --->
							</div>
						</div>
					  </li>
					  <li style="margin-right:2400px;">
						<div class="bg4">
							<div id="wwd-4">
								<div class="wwd-subbox">
									<div class="subtitle">Mobile Development</div>
									<div class="subcontent">
										<ul class="leftline">
											<li><span class="sz16">ENTERPRISE READY</span><br />Utilizing the same methodologies and infrastructures as advanced Web Applications, SpireMedia also creates cutting-edge Mobile Applications for iOS and Android-based tablet devices and smartphones.  Combining our deep experience in Web services and the iOS and Android SDKs, along with top notch expertise in Java, Objective-C, and Cocoa, Spire's mobile developers bring to life complex mobile applications for the enterprise.  SpireMedia employs a rigorous, iterative mobile development process providing fast results with no surprises.</li>
											<li><span class="sz16">HTML5 TO NATIVE</span><br />
											Depending upon your project's requirements, your mobile application may be built as a fully native application, leveraging the target device's native functions and user control libraries with data resident to the device; a partially native application, leveraging the target device's native functions and user control libraries but with dynamic data pulled from an Internet-based Web Services platform; or as a thin client app rendered within a browser shell with both the user interface and the data being pulled via Web Services.</li>
										</ul>
									</div>
									<div class="subrightcol">
										<div class="srbox1">Service Offerings</div>
										<div class="bclear accordion-width">
											<ul id="middleItem_5_Content_Accordion"  style="cursor:pointer;">
												<li><a>iPhone and iPad<span class="arrow"></span></a>
														<div class="bclear">
															<p>Combining our deep experience of iPhone SDK along with our knowledge of Objective-C, Spire's developers bring to life complex mobile applications for the enterprise optimized for with the iPhone, iPad, or both.</p>
														</div>
												</li>
												<li ><a>Android<span class="arrow"></span></a>
														<div class="bclear">
															<p>Our Mobile team members are veteran Android developers, with capabilities equal to our iPhone development team, specializing in the unique aspects of developing for the wide range of devices available on the Android Platform.</p>
														</div>
												</li>
												<li ><a>Mobile Web<span class="arrow"></span></a>
														<div class="bclear">
															<p>SpireMedia builds web-enabled mobile applications built for both the Apple and Android browser platforms.  We take advantage of our deep web development practices with our Mobile Development knowledge to produce Mobile Web applications that look and feel like native applications.</p>
														</div>
												</li>
											</ul>
											<script type="text/javascript">
												$(function(){
													$("##middleItem_5_Content_Accordion").accordion({
														autoHeight: false, 
														active:false
													});
												});
											</script>
										</div><!--- bclear --->
									</div><!--- subrightcol --->
								</div><!---  end .wwd-subbox --->
							</div>
						</div>
					  </li>
					  <li>
						  <div class="bg5">
							  <div id="wwd-4">
								
							  </div>
						  </div>
					  </li>
					</ul>
					<div class="clearfloat"></div>
				</div>
				
				<div id="slideReturn">
	                <div class="sl-return">
	                    <div class="slr-btn-off"><a href="##" class="btn-wwd3"></a></div>
	                </div>
            	</div><!---- end #slideReturn --->
	            <div id="slideArrows">
	                <div class="sl-arrows">
	                	<div class="sla-up-off"></div>
	                    <div class="sla-down-off"></div>
	                    <div class="sla-left-off"><a href="##" class="btn-wwd2"></a><a href="##ux-design" class="btn-uxd2"></a><a href="##visual-design" class="btn-vd2"></a><a href="##web-development" class="btn-wd2"></a></div>
	                    <div class="sla-right-off"><a href="##ux-design" class="btn-uxd2"></a><a href="##visual-design" class="btn-vd2"></a><a href="##web-development" class="btn-wd2"></a><a href="##mobile-development" class="btn-md2"></a></div>
	                </div>
	            </div><!---- end slideArrows --->
	            
			</div><!---  end WWD --->
		</div><!--- end main --->
	</div><!---  end mainWhat --->
	<div class="page-bottom"></div>
	<!--- footer --->
	<cfinclude template="../footer.cfm">
	<!--- /footer --->
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#
</body>
</html>
</cfoutput>