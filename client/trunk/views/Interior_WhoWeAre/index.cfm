<cfoutput>
	
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!--- whoweare --->
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/jquery.mousewheel.min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.scrollTo-1.4.2-min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.ba-dotimeout.min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.fancybox.js?v=2.0.6"></script>
	<link rel="stylesheet" type="text/css" href="/ui/js/jquery.fancybox.css?v=2.0.6" media="screen" />
	<script type="text/javascript" src="/ui/js/spire-demo3000.js"></script>	
		
</cfsavecontent>
<cfhtmlhead text="#pageHead#">

<body>
	<div id="loading-image">
		<img src="/ui/images/loading2.gif" />
	</div>
	
	<div id="hContainer">
		<div id="header" >
			<div id="head">
				<div id="logo">
					<a href="/"></a>
				</div>
				#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=topnav')#
			</div><!-- end head -->
		</div><!-- end header -->
	</div><!-- end hContainer -->
	
	<div id="mainWho2">
	<div id="mainwwa">
    	<div id="mwwa2">
			<div class="fudge">
			
			
				<div class="mwwa2-BGslide1">			
					<div class="mwwa2-slide1">				
						<div id="main_wh">
							<div id="WHO">
								<div id="wh-left">      
									<div class="title">Who We Are</div>
									<div class="post">
										Founded in 1998, SpireMedia is a privately owned and self-funded consulting firm based in Denver, Colorado that architects, designs, and develops web and mobile solutions for the world's top companies. Our mission is simple: to make technology more meaningful, more useful, and more successful.
									</div>
									<div style="position: relative; left:-60px;"><img src="/ui/images/whoweare_infographic.png"></div>
								</div><!--  end wh-left -->
								<div id="wh-right">
									<ul id="firstboxes">
										<li><div class="whr-box1"><a href="##leadership" class="btn-leadership">Leadership<div class="arw-goto"></div></a></div></li>
										<li><div class="whr-box2"><a href="##history" class="btn-history">History<div class="arw-goto"></div></a></div></li>
										<li><div class="whr-box3"><a href="##careers" class="btn-careers">Careers<div class="arw-goto"></div></a></div></li>
									</ul>
								  	<div class="clearfloat"></div>
								</div><!-- end wh-right -->
								<div class="clearfloat"></div>
							</div><!-- end WHO -->
						</div><!--  end main_wh --> 
					</div><!-- end mwwa2-slide1 -->			
				</div><!-- end mwwa2-BGslide1 -->
		
		<div class="mwwa2-BGslide2">			
			<div class="mwwa2-slide2">
				<div id="main_le">
					<div id="people">
						<ul id="myList">
							<li><img src="/ui/images/people-a.png" /></li>
						    <li><img src="/ui/images/landing_mike.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person1">
						        	<div class="dar-name" id="bio_1">Michael Gellman<br /><span class="sz14">CEO</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/landing_adam.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person2">
						        	<div class="dar-name" id="bio_2">Adam Hasemeyer<br /><span class="sz14">VP of Sales</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/landing_jim.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person3">
						        	<div class="dar-name" id="bio_3">James P. Orsi<br /><span class="sz14">VP of Strategy and User Experience</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/landing_kendra.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person4">
						        	<div class="dar-name" id="bio_4">Kendra Smith<br /><span class="sz14">Director of Project Management</span></div>
						            </a>
						        </div>
						    </li>
						</ul>
						<div class="clearfloat"></div>
						<ul>
							<li><img src="/ui/images/landing_thad.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person5">
						        	<div class="dar-name" id="bio_5">Thaddeus Batt<br /><span class="sz14">CTO</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/landing_steve.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person6">
						        	<div class="dar-name" id="bio_6">Stephen Lloyd<br /><span class="sz14">CFO</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/people-b.png" /></li>
						    <li><img src="/ui/images/landing_josh.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person7">
						        	<div class="dar-name" id="bio_7">Josh Fuller<br /><span class="sz14">Creative Director</span></div>
						            </a>
						        </div>
						    </li>
						    <li><img src="/ui/images/landing_gregg.jpg" />
						    	<div class="darken">
						        	<a class="fancybox" href="##person8">
						        	<div class="dar-name" id="bio_8">Gregg Larson<br /><span class="sz14">VP of Technology</span></div>
						            </a>
						        </div>
						    </li>
						</ul>
        			</div><!-- end people -->
				</div><!-- end main_le -->
			</div><!-- end mwwa2-slide2 -->
		</div><!-- mwwa2-BGslide2 -->
		
		<div class="mwwa2-BGslide3">
			<div class="mwwa2-slide3"> 
				<div id="main_his">
        			<div id="scrollhis">
						<img src="/ui/images/history.png" width="2182" height="512" />
						<div class="pgtitle">History</div>
							<div class="text98"><span class="sz16">SPIRE MEDIA BEGINS:</span><span class="date"> AUGUST 1998</span><br />
								Michael Gellman and Paul Schrank incorporate as SpireMedia. The name comes from the goals of the company -- Inspire our clients and employees. Aspire to be the best. Perspire from hard work. They move into the basement of The Daniels and Fisher Warehouse ##2 with a few Mac clones, a big whiteboard, a recent Ivy League grad, and a whole lot of ambition.
							</div>
							<div class="text99"><span class="sz16">eBAGS LAUNCHES:</span><span class="date"> MARCH 1999</span><br />
								After more than six months of development Spire's first client, eBags, launches. It is one of the earliest large-scale e-commerce websites and it is instantly a success. The .com world takes notice, putting Spire on the map as a company that can actually make business happen on the Internet.
							</div>
							<div class="text00"><span class="sz16">EXPANSION OCCURS:</span><span class="date"> NOVEMBER 2000</span><br />
								SpireMedia employs more than 30 people. Outgrowing the basement, the company now resides on the second floor of D&amp;F ##2. Venture-funded start ups and progressive technology companies populate the client list. Fueled by a relationship with David Letterman, SpireMedia's New York office opens.
							</div>
							<div class="text02"><span class="sz16">USER EXPERIENCE BEGINS:</span><span class="date"> APRIL 2002</span><br />
								Driven by client desire for usable websites that produce real results, Spire establishes its User Experience practice. Providing information architecture and web strategy services, this will become one of the company's greatest differentiators. The work SpireMedia performed in this realm laid the foundation for what is now the thriving User Experience industry.
							</div>
							<div class="text05"><span class="sz16">SPIRE ESM RELEASED:</span><span class="date"> SEPTEMBER 2005</span><br />
								With eight years and hundreds of successful projects under its belt, SpireMedia combines the best of its technology to release the SpireESM platform. This open content management system is an innovative precursor to such widely used platforms as Drupal, WordPress, and Umbraco. From mid-sized enterprises to Fortune 500s, SpireESM simplifies the way in which companies interact with their web applications.
							</div>
							<div class="text08"><span class="sz16">MOBILE R&amp;d ESTABLISHED:</span><span class="date"> MARCH  2008</span><br />
								Over a year before the iPhone is introduced, SpireMedia (now occupying the 3rd floor of D&amp;F ##2) sees the potential of mobile technologies and establishes a mobile R&D department. Western Union hires the team to build innovative apps that run on company BlackBerries. SpireMedia is soon several steps ahead of its competitors as iOS’ and Android gain favor.
							</div>
							<div class="text10"><span class="sz16">AT&amp;T PARTNERSHIP FORGED:</span><span class="date"> JANUARY 2010</span><br />
								Fresh off of its iPhone exclusive, AT&T asks SpireMedia to evangelize mobile apps to its biggest business customers. This move quickly leads to a major partnership. That partnership continues to thrive today and has moved beyond iPhone apps into Android apps as well.
							</div>
							<div class="text11"><span class="sz16">CONSTRUCTION ON NEW HQ BEGINS:</span><span class="date"> NOVEMBER 2011</span><br />
								In its thirteenth year, SpireMedia is fresher than ever. New methodologies and processes; improved technologies and designs; great clients and solid numbers. Now, the company makes the decision to finally move out of The Daniels and Fisher Warehouse ##2. Construction on 2911 Walnut, the new SpireMedia World Headquarters, begins. By April 2012, the company will officially move and a whole new timeline begins.
							</div>
							<div id="crane"></div>
        			</div><!--  end scrollhis -->
				</div><!-- end main_his -->
			</div><!-- end mwwa2-slide3 -->			
		</div><!-- mwwa2-BGslide3 -->
		<div class="mwwa2-BGslide4">		
			<div class="mwwa2-slide4">
				<div id="main_car">
					<div id="CAR">
				    	<cfif isDefined("form.formid") and trim(form.formid) eq "9505301D-F464-7712-F32AB0AD9A0A2A84">
							<div style="width:960px; border:2px solid ##b43b16; padding:5px; color:white; background-color:##1b1b1b;margin-bottom:10px;text-align:center;">Thank you for submitting your resume.</div>
						</cfif>
				    	<div class="careers">				    	
				            <div class="subtitle">Careers</div>
				            <div class="subcontent">
				            	<ul class="leftline">
					                <li><span class="sz16">WHAT WE LOOK FOR</span><br />In general, we look for intelligence, reasonableness, flexibility, and strength of character, as well as domain knowledge and expertise, experience in relevant industries, work 
										discipline, interpersonal competence, cooperativeness, and communication skills.</li>
				                	<li><span class="sz16">THE OPPORTUNITY</span><br />
				    					We offer talented individuals the opportunity to break out of traditional "agency" models of Web strategy, design, and development and embrace a new level of specialization in Internet new product development, rich Internet application development, and high quality Web management consulting.<br /><br />We are currently ranked by the Denver Business Journal as one of Denver's Best Places to Work and Top Web Firms.</li>
				            	</ul>
				           </div>
				           <div class="subrightcol">
				            	<link rel="stylesheet" href="/ui/css/typo.css" type="text/css" />
								<link rel="stylesheet" href="/ui/css/widgets.css" type="text/css"/>
								<script type="text/javascript" src="/ui/js/jquery-ui-1.7.1.min.js"></script>
								<script type="text/javascript" src="/ui/js/jquery.accordion.min.1.7.1.js"></script>
				                <div class="srbox1">Current Openings</div>
				                <div class="weblinkjob"><a class="fancybox btn-corn" href="##QAAnalyst" ><div class="titlebox">Quality Assurance Analyst</span></div></a></div>
				                
				                <div id="QAAnalyst" class="popupWeb">											
						            <div style="padding:30px 20px 0px 30px;">
						                <div style="font-family: lubalingraphstd-demi,Helvetica,sans-serif; font-size: 28px; font-weight: normal; margin-bottom: 20px;">
							                Quality Assurance Analyst</div>
						                <div style="border-left: 4px solid ##A23217; line-height: 1.2; margin-bottom: 40px; padding-left: 5px;">
											<p>As Quality Assurance Analyst with Spiremedia, you will
											work with the Vice President of Technology to develop, maintain and execute
											Quality assurance testing procedures.  The primary responsibility is to evaluate and test mobile and web
											applications to ensure that they function according to specification. Your
											responsibilities will include developing and executing test plans for our web
											and mobile applications, entering defects into our bug tracking system, create
											the necessary documentation to successfully test an application, write test
											scripts, and validate installation instructions.<br><br>
											 
											Position responsibilities:<Br>
											 
											    * Develop and
											maintain test plans, manual and automated test scripts for user interface,
											functionality, system and "ad-hoc testing"<br>
											    * Execute
											regression tests, functional tests and data tests<br>
											    * Document
											quality assurance practices<br>
											    * Report, track
											and determine priority of reported bugs<br><br>
											 
											Requirements:<br>
											 
											    * BA/BS in
											Computer Sciences/Engineering or associated discipline or the equivalent
											experience<br>
											    * Well-versed
											in all testing methodologies (white vs. black box test work, system vs.
											functional).<br>
											    * Well-versed
											in software process methodologies.<br>
											    * A solid
											understanding of quality assurance as part of the development process.<br>
											    * Detail
											oriented and a problem solver<br>
											    * Ability to
											work in a rapidly changing environment<br>
											    * Automated
											Testing with Selenium or Jmeter<br>
											    * All
											applicants applying for this position must be authorized to work in the United
											States.<br>
											 
											About Spiremedia
											 
											SpireMedia creates business-critical Web and Mobile
											applications.  We serve an international
											clientèle from start-ups to Fortune 500 companies and have been in the Web
											industry for more than 10 years.
											
											If interested please send your resume and salary requirements to: kecnav at yahoo dot com</p>
										</div>
						            </div><!---  end .ww_text --->										            
								</div><!---- end .popupWeb --->
										
									
								
							<div class="srlink" id="submitResume"><a class="fancybox" href="##resume">Submit Resume</a></div>                
				            <div class="clearfloat"></div>
				           
				        </div><!--  end careers -->
					</div><!--  end CAR -->
				</div><!-- end main_car -->                 
			</div><!-- end mwwa2-slide4 -->
		</div> <!--  end .mwwa2-BGslide4 -->
		<div class="clearfloat"></div>      


		<div id="controlBox">
            <div id="slideReturn">
                <div class="sl-return">
                    <div class="slr-btn-off"><a href="##our-work" class="btn-start"></a></div>
                </div>
            </div><!---- end #slideReturn --->
            <div id="slideArrows">
                <div class="sl-arrows">
                	<div class="sla-up-off"></div>
                    <div class="sla-down-off"></div>
                    <div class="sla-left-off"><div class="btn-backarw"></div></div>
                    <div class="sla-right-off"><div class="btn-fwdarw"></div></div>
                </div>
            </div><!-- end slideArrows -->      
		</div><!-- end controlBox -->
	</div><!-- end fudge-->
			
		</div><!-- end mwwa2 -->
    </div><!-- end main -->
</div><!-- end mainWho2 -->

	<!--- footer --->
	<div id="fContainer">
		<cfinclude template="../footer.cfm">
	</div>
	<!--- /footer --->	
	#showContentObject('middleItem_2_Content', 'Forms', 'moduleaction=contactform')#


<div id="person1" class="popup" >
	<div class="pu-left"><img src="/ui/images/bio_mike.jpg" /></div>
    <div class="pu-right">    	
        <div class="desc" style="font-size:13px;">
			<div class="name">Michael Gellman</div>
        	<div class="title">CEO</div>
        	Michael Gellman is the founder and CEO of SpireMedia, where he is responsible for ensuring the success of every client and every employee.
			<br /><br  />
			He also directs Spire's management, vision, and strategy. Under his leadership, SpireMedia has grown to be a multi-million dollar company that has been profitable from day one without funding. Over the years, he has employed more than 300 people and prides himself on nurturing his staff and producing future leaders.
			<br /><br  />
			Prior to SpireMedia, Gellman founded his first company, GIG Media, in 1996. GIG was one of Colorado's first interactive agencies. Prior to GIG Media, he served as a writer and producer for television and film with companies including Troma Pictures and The Teaching Learning Network. He also performed stand-up comedy and had small acting roles in productions throughout New York City.
			<br /><br />
			Gellman earned a bachelor's degree in English from the University of Florida in 1994. In the following years, he gained a reputation as one of the industry's leading authorities on web technology, mobile applications, and social media.
			<br><br>
			Recently, Gellman was selected by Colorado Biz Magazine as a finalist for CEO of the Year. He has held a variety of board posts with industry groups and non-profits. In addition, he has been active on behalf of numerous philanthropic and political causes.
			<br><br>
			Gellman is a sought out speaker and has given lectures at The University of Denver Daniels College of Business, The University of Colorado Leeds School of Business, and South by Southwest among others. He is also a published author, an avid world traveler, and a self-professed "entrepreneurial nerd". 
        </div>	
    </div>	
	<div class="pu-btns-lt">
	  	<div class="pub1">&nbsp;</div>
	      <div class="pub2"><a href="http://www.linkedin.com/in/mgellman" target="_blank"></a></div>
	      <div class="pub3"><a href="http://twitter.com/mgellman" target="_blank"></a></div>
	 </div>
	 <div class="clearfloat"></div>	
</div><!-- end popup -->

<div id="person2" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_adam.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Adam Hasemeyer</div>
        <div class="title">VP of Sales</div>
        <div class="desc">
        	As Vice President of Sales, Adam Hasemeyer is responsible for leading the direct sales efforts at Spire, as well as organizing the teams that will scope and perform the projects sold.  He began as an account executive in 2006 and quickly rose through the ranks to attain his current position.
			<br /><br  />
			Hasemeyer is recognized as a thought leader in the application development world. Business leaders look to him as a source of knowledge on new technological advancements and how they affect e-commerce. In his role, he has developed numerous ideas and initiatives that were instrumental in taking Spire from a local player to a national presence.
			<br><Br>
			Committed to giving back to the community, Hasemeyer has devoted his time to Volunteers of America and Toys for Tots in addition to numerous other organizations. He is a Miami University alumnus and enjoys golfing, snowboarding, fishing, and music. Hasemeyer has a passion for bringing people together to deliver great results for his clients and volunteer organizations.
        </div>
    </div>
    <div class="pu-btns-lt">
    	<div class="pub1"></div>
        <div class="pub2"><a href="http://www.linkedin.com/in/adamhasemeyer" target="_blank"></a></div>
        <div class="pub3"><a href="http://twitter.com/Hasemeyer" target="_blank"></a></div>
    </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person3" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_jim.jpg" /></div>
    <div class="pu-right">
    	<div class="name">James P. Orsi</div>
        <div class="title">VP of Strategy and User Experience</div>
        <div class="desc">
        	Orsi leads the strategy and user experience design department at Spire. He has been mastering interactive solutions since 1996, when he helped build the nascent online advertising department for Time Inc.’s Pathfinder division, one of the web’s first news and entertainment portals. Since then he has spearheaded product development and user experience design efforts for a wide variety of customers, from Fortune 100 companies to government agencies and early-stage startups. He has over 16 years of executive experience in delivering intelligent, functional product solutions to major customers such as J.P. Morgan, The City of New York, Nestle Waters, USDA, Sprint, Swisslog, and Hearst Publications. 
        	<br><br>
        	Orsi is passionate about deploying user-centered design methods for creating products that delight customers and drive business results. He is an expert in interface design and business analysis, and uses his understanding of finance, management, and technology to sell and deliver effective answers for his clients.
        	<br><br>
        	Orsi received a bachelor's degree with High Honors in English from Colgate University, and a Masters of Public Administration from Columbia University. In his free time Orsi enjoys backcountry skiing and ski mountaineering in Colorado’s San Juan and Elk ranges, and hiking or rock climbing those same mountains once the snow melts. 
        </div>
    </div>
    <div class="pu-btns-lt">
    	<div class="pub1"></div>
        <div class="pub2"><a href="http://www.linkedin.com/in/jimorsi" target="_blank"></a></div>
        <div class="pub3"><a href="http://twitter.com/SpireUX" target="_blank"></a></div>
    </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person4" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_kendra.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Kendra Smith</div>
        <div class="title">Director of Project Management</div>
        <div class="desc">
        	Kendra Smith is the Director of our Project Management team at SpireMedia, and is responsible for the execution and success of web development and mobile projects.  Her goal is to have every project come in on time and within budget.
        	<br><br>
        	She has an extensive background in managing technology projects and teams, she enjoys translating technical jargon to information that lay people can understand.   She enjoys building teams that product outstanding results, and takes pride in getting it right.
        	<br><br>
        	Kendra also enjoys giving back to the communities in which she lives and works.  She has spent over 5 years leading community service efforts in which her teams help the less fortunate.  
		 </div>	
    </div>
    <div class="pu-btns-l">
    	<!--- <div class="pub1"></div> --->
        <div class="pub2"><a href="http://www.linkedin.com/pub/kendra-smith/23/400/278" target="_blank"></a></div>
        <!--- <div class="pub3"><a href="http://twitter.com/" target="_blank"></a></div> --->
    </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person5" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_thad.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Thaddeus Batt</div>
        <div class="title">CTO</div>
        <div class="desc">
        	Utilizing his 13 years of technical experience, Batt provides SpireMedia and its clients with strategic analysis and planning as well as application and system architecture. His agnostic stance on technology offers an objective perspective to clients and allows him to effectively lead the R&D efforts of SpireMedia.
        	<br><br>
        	Prior to joining SpireMedia in 1999, Batt developed Internet applications for San Mateo-based Siebel Systems, Inc. (Nasdaq: SEBL) out of their Boston location, where he applied his experience to Web-enable Siebel's flagship cient/server product offering. He also worked on the development, installation, and launch of Siebel's Sales.com SFA portal. Batt joined Siebel via the acquisition of Web-based sales force automation startup InterActive WorkPlace, where he was a founding member of the initial development team.
			<br><br>
			Previously, he was the technical producer for Hearst New Media & Technology, where he was responsible for the implementation, maintenance, and re-launch of the Homearts Network at www.homearts.com. Prior to that, Batt was production manager for Technologic Partners, publisher of ComputerLetter, VentureFinance, and VentureWire.
			<br><br>
			Batt earned a B.A. degree in Literature and Education from the University of Colorado at Boulder during the Orange Bowl Years. He enjoys spending time with his wife, Sarah, his children, Griffin and Genevieve, and his dogs, which are often at work.
        </div>
    </div>
    <div class="pu-btns-l">
    	<!--- <div class="pub1"></div> --->
        <div class="pub2"><a href="http://www.linkedin.com/in/thaddeusbatt" target="_blank"></a></div>
        <!--- <div class="pub3"><a href="http://twitter.com/SpireUX" target="_blank"></a></div> --->
    </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person6" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_steve.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Stephen Lloyd</div>
        <div class="title">CFO</div>
        <div class="desc">
       		Steve Lloyd oversees all of the firm's financial activities. Lloyd also heads up company administration and project management.
			<br><br>
			In addition to public accounting experience, Lloyd's career includes nearly thirty years in the communications industry, spanning a variety of roles from technician to corporate operations manager.
			<br><br>
			Lloyd graduated Magna Cum Laude from the University of North Florida with a BS in Accounting. He holds active CPA licenses in both Florida and Colorado. He is also a US Navy veteran.
			<br><br>
			Lloyd is active in community service, having served on the Board of Directors for a Jefferson County Open Space Park in Conifer.
			<br><br>
			In his off time, Lloyd, a licensed pilot, enjoys maintaining and flying his aircraft. He can also be found riding his Harley in the Colorado foothills or snowboarding at one of Colorado's beautiful ski resorts.
		</div>
    </div>    
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person7" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_josh.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Josh Fuller</div>
        <div class="title">Creative Directore</div>
        <div class="desc">
        	Josh Fuller leads all things creative for SpireMedia. His approach is rather simple, involving three key aspects: know your audience; know your technology; know your brand. He manages the creative team with a clear understanding of each client's goals by advocating clean, detailed, and strategy-driven design standards. 
			<br><Br>
			Prior to joining Spire, Fuller founded and operated TrebleRed, an interactive agency that produced award-winning work for more than nine years. Throughout his tenure there, he worked with some of Denver's top companies and agencies. 
			<br><Br>
			Fuller applies a sincere passion and proven understanding for design and strategy, ensuring each project connects and resonates with its intended audience. His clear understanding of the strategy behind user experience design, and his early involvement in that process, enables him to deliver the solid user interface solutions that are compelling, functional, and practical. 
			<br><Br>
			When not engaged with Spire's clients or his team of designers, Fuller is often found behind the screen of his MacBook Pro, creating, creating, and creating more. He also may be playing tennis or roaming the Front Range with his Newfoundland-Border Collie, Eastwood.
		</div>	
    </div>
    <div class="pu-btns-l">
    	<!--- <div class="pub1"></div> --->
        <div class="pub2"><a href="http://www.linkedin.com/in/treblered" target="_blank"></a></div>
        <!--- <div class="pub3"><a href="http://twitter.com/SpireUX" target="_blank"></a></div> --->
    </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->

<div id="person8" class="popup">
	<div class="pu-left"><img src="/ui/images/bio_gregg.jpg" /></div>
    <div class="pu-right">
    	<div class="name">Gregg Larson</div>
        <div class="title">VP of Technology</div>
        <div class="desc">
        	Gregg Larson oversees the software development process at SpireMedia. Gregg brings years of technical leadership to the Spire team, helping Fortune 500 clients plan, develop and implement e-commerce systems generating over $200 million dollars in annual revenue. Prior to joining Spire, Gregg earned a Masters Degree in Engineering Management, focusing on statistical methods for software development. He was also a Lead Architect at Cable Television Laboratories where he developed B2B platforms for the Cable Industry and national retailers including Best Buy, Wal-Mart, and Sprint.
		</div>
    </div>
    <div class="pu-btns-l">
    	<div class="pub2"><a href="http://www.linkedin.com/in/gregglarson" target="_blank"></a></div>
   </div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->


<div id="resume" class="popup">
	<div class="pu-left" style="overlap:hidden;"><img src="/ui/images/history-crane.png" /></div>
    <div class="pu-right">
    	<div class="name">Submit Resume</div>
        <div class="title">FILL FORM BELOW</div>
        <div class="desc">
        	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=resumeUploadForm')#
		</div>	
    </div>
    <div class="pu-close"></div>
    <div class="clearfloat"></div>
</div><!---- end .popup --->



</body>
</html>
</cfoutput>