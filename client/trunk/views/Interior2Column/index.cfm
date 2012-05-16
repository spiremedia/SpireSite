<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- interior 2 column -->
<cfinclude template="../headtag.cfm"/>
<body>
	
	<div id="header">
		<div id="head">
			<div id="logo"><a href="/"></a></div>
			#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=topnav')#
		</div><!-- end ##head -->
	</div><!-- end ##header2 -->
	
	<div id="mainWhat">
		<div id="main">
			<div id="WWD">
					<div style=" margin-left:auto; margin-right:auto; width:70%;">
						<cfif contentObjectNotEmpty('middleItem_1_Content')>
							#showContentObject('middleItem_1_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
						</cfif>
					</div>
					<div class="clearfloat"></div>
			</div><!--  end ##WWD -->
		</div><!--  end ##main -->
	</div><!--  end ##mainWhat -->
	
	<!-- footer -->
	<cfinclude template="../footer.cfm">
	<!-- /footer -->	
	#showContentObject('middleItem_3_Content', 'Forms', 'moduleaction=contactform')#
</body>
</html>
</cfoutput>
