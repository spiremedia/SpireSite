<cfoutput>
	
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- our work, wayin -->
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/spire-webwork.js"></script>
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
		</div><!-- end ##head -->
	</div><!-- end ##header2 -->

	<div id="mainWork">
		<div id="main">
	<div id="main_ww">
		<div id="BGSITE"></div>
		<div id="wrapper3">

			<div id="scrollweb">
				<img src="/ui/images/webbg-wayin.png" width="2100px" height="512px"/>
				<div class="ww_text">
					<div class="title-ww">WAYIN <span class="sz12dm">Mobile Polling Application</span></div>
					<div class="desc-ww">Spire helped launch Scott McNealy's startup into the stratosphere by building its initial proof-of-concept mobile polling application. Wayin had four employees when they first engaged Spire for our strategy and development services; since then they have raised over $20M in funding and built a staff of over 50 people.</div>
				</div><!--- < end .ww_text --->
				<div class="ww-social">
					<div class="soc-fb"><a href="#shareOnFacebook#" class="socialpopup" target="_blank"></a></div>
					<div class="soc-tw"><a href="#shareOnTwitter#" target="_blank" id="twitter" class="socialpopup"></a></div>
					<div class="soc-de"><a href="#shareonDelicious#" class="socialpopup" target="_blank"></a></div>
				</div><!--- < end .ww_social --->
			</div><!--- <<<< end #scrollweb --->
			<div id="navigator">
				<div class="btn-prev"><a href="/our-work/swiss-log"></a></div>
				<div class="btn-main"><a href="/our-work"></a></div>
				<div class="btn-next"><a href="/our-work/sms-by-50"></a></div>
			</div><!--- <<<< end #navigator --->
		</div><!--- <<<<<< end #wrapper --->
	</div><!--- >> end #main_ww --->

		</div><!--- >>>> end #main --->
	</div><!--- >>>>>> end #mainWork --->

	<!--- footer --->
	<cfinclude template="../footer.cfm">
	<!--- /footer --->
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#
</body>
</html>
</cfoutput>