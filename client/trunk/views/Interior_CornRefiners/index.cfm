<cfoutput>
	
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- our work, corn -->
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
				<img src="/ui/images/webbg-corn.png" width="2500px" height="512px"/>
				<div class="ww_text">
					<div class="title-ww">CORN REFINERS ASSOCIATION <span class="sz12dm">Public Site</span></div>
					<div class="desc-ww">SpireMedia joined forces with the CRA in 2007 and has become the Association's sole web and mobile partner for the past five years.  Spire has worked on six separate web properties providing Strategic Planning, User Experience, Design and Development services on a continuous basis.</div>
				</div><!--- < end .ww_text --->
				<div class="ww-social">
					<div class="soc-fb"><a href="#shareOnFacebook#" class="socialpopup" target="_blank"></a></div>
					<div class="soc-tw"><a href="#shareOnTwitter#" target="_blank" id="twitter" class="socialpopup"></a></div>
					<div class="soc-de"><a href="#shareonDelicious#" class="socialpopup" target="_blank"></a></div>
				</div><!--- < end .ww_social --->
			</div><!--- <<<< end #scrollweb --->
			<div id="navigator">
				<div class="btn-prev"><a href="/our-work/corepower-yoga"></a></div>
				<div class="btn-main"><a href="/our-work"></a></div>
				<div class="btn-next"><a href="/our-work/denver-water"></a></div>
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