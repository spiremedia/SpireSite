<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- interior 2 column -->
<cfinclude template="../headtag.cfm"/>

<body class="interior2column">
	<div id="outercontainer">
		<div id="innercontainer">
			<!-- header -->
			<div class="header">
				<cfinclude template="../header.cfm">
				<div class="nav">#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=flatnav')#</div>
			</div>
			<!-- /header -->
			<div id="bodyContent">
				<cfinclude template="../bodyheader.cfm">
				#showContentObject('item_above_cols', 'HTMLContent,TextContent', 'editable')#
				<div class="c1">
					<div class="content">
					<cfif contentObjectNotEmpty('leftItem_1_Content')>
						#showContentObject('leftItem_1_Content', 'HTMLContent,Assets,Events,Forms,News,ProductCatalog,TextContent,AssetImages', 'editable')#
					</cfif>

					<cfif contentObjectNotEmpty('leftItem_2_Content')>
						#showContentObject('leftItem_2_Content', 'HTMLContent,Assets,Events,Forms,News,ProductCatalog,TextContent,Taxonomies,Navigation,AssetImages', 'editable')#
					</cfif>

					<cfif contentObjectNotEmpty('leftItem_3_Content')>
						#showContentObject('leftItem_3_Content', 'HTMLContent,Assets,Events,Forms,News,ProductCatalog,TextContent,Taxonomies,Navigation,AssetImages', 'editable')#
					</cfif>

					<cfif contentObjectNotEmpty('leftItem_4_Content')>
						#showContentObject('leftItem_4_Content', 'HTMLContent,Assets,Events,Forms,News,ProductCatalog,TextContent,AssetImages', 'editable')#
					</cfif>

					<cfif contentObjectNotEmpty('leftItem_5_Content')>
						#showContentObject('leftItem_5_Content', 'HTMLContent,Assets,Events,Forms,News,ProductCatalog,TextContent,AssetImages', 'editable')#
					</cfif>
					<!--- important! --->&nbsp;
					</div>
				</div>
				<div class="c2">
					<cfif ispreview()><div class="hint">Bread Crumbs</div></cfif>
					#showContentObject('breadcrumbs', 'breadcrumbs')#
					<div class="c2Container">
						<div class="middleItem">
							[postprocess-userflash]
							<cfif ispreview()><div class="hint">Page Title (only if different than default)</div></cfif>
							<h1 class="pagetitle">
								<cfif ispreview('edit') OR contentObjectNotEmpty('pagetitle')>
								#showContentObject('pagetitle', 'SimpleContent', 'editable')#
								<cfelse>
								#getField('pagename')#
								</cfif>
							</h1>
							<div class="content">
								<cfif contentObjectNotEmpty('middleItem_1_Content')>
									#showContentObject('middleItem_1_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>

								<cfif contentObjectNotEmpty('middleItem_2_Content')>
									#showContentObject('middleItem_2_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>

								<cfif contentObjectNotEmpty('middleItem_3_Content')>
									#showContentObject('middleItem_3_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>

								<cfif contentObjectNotEmpty('middleItem_4_Content')>
									#showContentObject('middleItem_4_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>

								<cfif contentObjectNotEmpty('middleItem_5_Content')>
									#showContentObject('middleItem_5_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#				
								</cfif>

								<cfif contentObjectNotEmpty('middleItem_6_Content')>
									#showContentObject('middleItem_6_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<br class="clear"/>
			</div>
			<br class="clear"/>
			<div class="foot"></div>
		</div>
		<!-- footer -->
		<cfinclude template="../footer.cfm">
		<!-- /footer -->
	</div>
</body>
</html>
</cfoutput>