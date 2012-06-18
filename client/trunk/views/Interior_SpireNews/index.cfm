
<cfoutput>	
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!--- spire news --->
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<script type="text/javascript" src="/ui/js/jquery.easing.1.3.js"></script>
	<script type="text/javascript" src="/ui/js/spire-news.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.coda-slider-2.0.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			$('##coda-slider-1').codaSlider({
	         crossLinking: false,
	         firstPanelToLoad: 1
	     });
		});
	</script>
	<link rel="stylesheet" href="/ui/css/coda-slider-2.0.css" type="text/css" media="screen" />
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
		</div><!--- end ##head --->
	</div><!--- end ##header2 --->

	
	<div class="content">		
		<div id="mainNews">
			<div class="newsbg">			
				<div id="mainNewsBackground">
					<div id="mnMain">	
						<div id="MNWRAP">
							<div class="mnNews">						
								<cfif contentObjectNotEmpty('middleItem_1_Content')>
									#showContentObject('middleItem_1_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>
								<div id="tweetbox">
									<div style="width:360px; height:55px; position:relative; left:110px; ">
										<span id="twitter_update_list"></span>
									</div>
									<div class="btn-fb"><a href="https://www.facebook.com/pages/SpireMedia/124962880899722"></a></div>
									<div class="btn-tw"><a href="http://twitter.com/SpireUX"></a></div>
								</div><!---  end tweetbox --->							
							#showContentObject('middleItem_2_Content', 'Forms', 'moduleaction=spirewire')#
							</div><!--  end .mnNews -->			
														
						</div><!---  end MNWRAP --->
					</div><!---  end mnMain --->
				</div><!---  end main --->
			</div><!--end newsbg -->		
		</div><!---  end mainNews --->
	</div>
	<div class="page-bottom"></div>
	<!--- footer --->
	<cfinclude template="../footer.cfm">
	<!--- /footer --->
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#	
	<script src="http://twitter.com/javascripts/blogger.js" type="text/javascript"></script>
	<script src="http://twitter.com/statuses/user_timeline/SpireUX.json?callback=twitterCallback2&count=1" type="text/javascript"></script>
</body>
</html>
</cfoutput>