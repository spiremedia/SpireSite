<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- print -->

<link rel="stylesheet" type="text/css" href="../../ui/css/print.css" />
<link rel="stylesheet" type="text/css" href="../../ui/css/layout.css" /><!------>
<link rel="stylesheet" type="text/css" href="../../ui/css/widgets.css" />

<body class="print"<!--- onload="window.print();"--->>
	<div id="container">
		<!-- header -->
		<div class="header">
			<cfinclude template="../printheader.cfm">
		</div>
		<div id="bodyContent">			
			<div class="middleItem">
				<h1>
					<cfif ispreview('edit') OR contentObjectNotEmpty('pagetitle')>
					#showContentObject('pagetitle', 'SimpleContent', 'editable')#
					<cfelse>
					#getField('pagename')#
					</cfif>
				</h1>
				<div class="content">
					<cfif contentObjectNotEmpty('middleItem_1_Content')>
						#showContentObject('middleItem_1_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#
					</cfif>
				
					<cfif contentObjectNotEmpty('middleItem_2_Content')>
						#showContentObject('middleItem_2_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#
					</cfif>
					
					<cfif contentObjectNotEmpty('middleItem_3_Content')>
						#showContentObject('middleItem_3_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#
					</cfif>
					
					<cfif contentObjectNotEmpty('middleItem_4_Content')>
						#showContentObject('middleItem_4_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#
					</cfif>
					
					<cfif contentObjectNotEmpty('middleItem_5_Content')>
						#showContentObject('middleItem_5_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#				
					</cfif>
					
					<cfif contentObjectNotEmpty('middleItem_6_Content')>
						#showContentObject('middleItem_6_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,Galleries,iFrames,News,ProductCatalog,Search,SiteMaps,TagCloud,TextContent,Videos', 'editable')#
					</cfif>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
</cfoutput>