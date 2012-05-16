<cfoutput>
			<div class="bodyheader">
				<div class="shopnav">
					<ul>
						<cfscript>
							lcl.list = "wine,spirits,beer,cordials-liqueurs";
							lcl.pathf = listfirst(requestObject.getFormUrlVar("path"),"/");
							lcl.current = listfindnocase(lcl.list, lcl.pathf);
							if (lcl.current == 0) lcl.pathf = 'shop';
							lcl.list = listtoarray(lcl.list);
							lcl.s = "";
							
							if ('shop' EQ lcl.pathf) lcl.s = lcl.s & '<li><img src="/ui/images/shop/shop_on.png"/></li>';
							else  lcl.s = lcl.s & '<li><img src="/ui/images/shop/shop_off.png"/></li>';
							
							for (lcl.i = 1;lcl.i LTE arraylen(lcl.list);lcl.i = lcl.i + 1){
								if (lcl.list[lcl.i] EQ lcl.pathf) lcl.s = lcl.s & '<li><a href="/#lcl.list[lcl.i]#/catalog/"><img src="/ui/images/shop/#lcl.list[lcl.i]#_on.png"/></a></li>';
								else  lcl.s = lcl.s & '<li><a href="/#lcl.list[lcl.i]#/catalog/"><img src="/ui/images/shop/#lcl.list[lcl.i]#_off.png"/></a></li>';
							}
							
							lcl.s = lcl.s & ('<li style="margin-left:175px;vertical-align:85%"><a href="http://twitter.com/applejackws" tabindex="6" title="Twitter" style="text-align:right;"><img src="/ui/images/twitter.png"/></a>&nbsp;&nbsp;&nbsp;<a href="http://www.connect.facebook.com/widgets/fan.php?api_key=b3eb499518d9b28bfc539a33482a3ccb&channel_url=http%3A%2F%2Fapplejack.com%2F%3Ffbc_channel%3D1&id=120846677823&name=&width=300&connections=&stream=&logobar=&css=" tabindex="7" title="Facebook"><img src="/ui/images/facebook.png"/></a></li></ul>');

							writeoutput(lcl.s);
						</cfscript>
					</ul>
				</div>
				<!---
				<cfif listfindnocase("wine,spirits,beer,cordials-liqueurs",listfirst(url.path,"/"))>
					<cfset lcl.sectionpages = getSiteMap().getSectionPages(path = listfirst(url.path,"/") & "/")>
					<div class="shopsubnav">
						<ul>
							<li class="first"><a href="/#listfirst(url.path,"/")#/">#ucase(listfirst(url.path,"/"))# HOME</a></li>
							<cfloop query="lcl.sectionpages">
							<li><a href="#lcl.sectionpages.displayurlpath#">#ucase(IIF(lcl.sectionpages.pagename EQ "catalog", DE("<b>CATALOG</b>"), "lcl.sectionpages.pagename"))#</a></li></cfloop>
						</ul>
					</div>
				</cfif>
				--->
			</div>
</cfoutput>