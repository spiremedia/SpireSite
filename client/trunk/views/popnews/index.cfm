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
						

						
						<cfset newsTypeId = "2CC17F33-EB6E-9D79-FAB502F689C5D50A">
						<cfquery name="oldNews" datasource="spireMedia">
							select * from news
						</cfquery>
						
						<cfloop query="oldNews">
						
							<cfquery name="writeNews" datasource="spireESM4" result="thisrecord">
								insert into newsItems (id, name, title, description, htmlText, modified, created, changedBy, active, deleted, siteId, itemdate, startdate, enddate, onhomepage, author, assetid, linkpageId)
								values ('#oldNews.id#','#oldNews.name#','#oldNews.title#','#oldNews.description#','#oldNews.description#',#createodbcdatetime(now())#,'#oldNews.startdate#','#oldNews.changedby#','#oldNews.active#','#oldNews.deleted#','#oldNews.siteId#','#oldNews.itemdate#','#oldNews.startdate#',NULL,'#oldNews.onhomepage#','#oldNews.author#','','')
							</cfquery>
							
							<cfquery name="writeXref" datasource="spireESM4">
								insert into newsItemsToNewstypes (id, newsTypeid, newsItemId, siteId)
								values('#createUUID()#','#newsTypeId#', '#oldNews.id#', 'AD1724FF-E347-83EA-18FD424840AD5849' )
							</cfquery>
						
						</cfloop>
						
						
						
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
	<cfinclude template="../contact.cfm">
</body>
</html>
</cfoutput>
