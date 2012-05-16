<cfcomponent name="navigation" extends="resources.abstractController">
	<!---
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="pageref">
		<cfargument name="possibleModules">
		<cfargument name="data">
										
		<cfset structappend(variables,arguments)>
		<cfreturn this>
	</cffunction>
	--->
	<!---
	<cffunction name="makeSubNav">
		<!--- Apologies for the proceduralness DRE --->
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var nav2 = querynew("hi")>
		<cfset var nav3 = querynew("hi")>
		<cfset var nav4 = querynew("hi")>
		<cfset var selectd = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var isSubsite = 0>

		<cfset lcl.breadcrumbs = listtoarray(pageref.getField('breadcrumbs'),"|")>
		<cfif arraylen(lcl.breadcrumbs) EQ 0>
			<cfreturn "">
		</cfif>
		<cfif arraylen(lcl.breadcrumbs) EQ 1><!--- home page or recycled nav --->
			<cfset nav3 = pageRef.getChildPages(getToken(lcl.breadcrumbs[1], 2, "~"))>
		<cfelse><!--- normal --->
			<cfloop from="2" to="#arraylen(lcl.breadcrumbs)#" index="lcl.itm">
				<cfset "nav#lcl.itm+1#" = pageRef.getChildPages(getToken(lcl.breadcrumbs[lcl.itm], 2, "~"))>
			</cfloop>
		</cfif>

		<!--- determine if subsite --->
		<cfif isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs) AND (gettoken(lcl.breadcrumbs[1],1,"~") neq 'Home')>
			<cfset isSubsite = 1>
		</cfif>

		<cfsavecontent variable="contents">
			<ul class="subnav">
				<cfoutput>
				<cfif arraylen(lcl.breadcrumbs) LT 2>
					<li class="navlevel2"><a href="#gettoken(lcl.breadcrumbs[1],3,"~")#" <cfif left(gettoken(lcl.breadcrumbs[1],3,"~"),1) EQ "h">target="_blank"</cfif>><img src="/ui/images/sectionLabels/<cfif isSubsite AND (listlen(gettoken(lcl.breadcrumbs[1],3,"~"), '/') gte 2)>#rereplace(ListGetAt(gettoken(lcl.breadcrumbs[1],3,"~"), 2, '/'), "[^a-zA-Z0-9]","","all")#<cfelse>#rereplace(gettoken(lcl.breadcrumbs[1],3,"~"), "[^a-zA-Z0-9]","","all")#</cfif>.gif" alt="#gettoken(lcl.breadcrumbs[1],1,"~")#"/></a></li>
				<cfelse>
					<li class="navlevel2"><a href="#gettoken(lcl.breadcrumbs[2],3,"~")#" <cfif left(gettoken(lcl.breadcrumbs[2],3,"~"),1) EQ "h">target="_blank"</cfif>><img src="/ui/images/sectionLabels/<cfif isSubsite AND (listlen(gettoken(lcl.breadcrumbs[2],3,"~"), '/') gte 2)>#rereplace(ListGetAt(gettoken(lcl.breadcrumbs[2],3,"~"), 2, '/'), "[^a-zA-Z0-9]","","all")#<cfelse>#rereplace(gettoken(lcl.breadcrumbs[2],3,"~"), "[^a-zA-Z0-9]","","all")#</cfif>.gif" alt="#gettoken(lcl.breadcrumbs[2],1,"~")#"/></a></li>				
				</cfif>
				<cfset isFirstMenuItem = true>
				<cfloop query="nav3">
					<cfset selectd['l3'] = refindnocase("^/#nav3.displayurlpath#", "/" & path)>
					<li class="navlevel3<cfif selectd['l3']> itemOn3<cfif isFirstMenuItem eq true> itemOn3First</cfif></cfif><cfif selectd['l3'] AND nav4.recordcount eq 0> navlevel3NoSubnav</cfif>"><a href="#nav3.displayurlpath#" <cfif left(nav3.displayurlpath,1) EQ "h">target="_blank"</cfif>>#ucase(nav3.pagename)#</a></li>
					<cfset isFirstMenuItem = false>		
					<cfif selectd['l3'] AND nav4.recordcount>
						<cfloop query="nav4">
							<cfset selectd['l4'] = refindnocase("^#nav4.displayurlpath#", "/" & path)>
							<li class="navlevel4<cfif nav4.displayurlpath EQ "/" & path> itemOn4</cfif>"><a href="#nav4.displayurlpath#" <cfif left(nav4.displayurlpath,1) EQ "h">target="_blank"</cfif>>#nav4.pagename#</a></li>
							<cfif selectd['l4'] AND nav5.recordcount>
								<cfloop query="nav5">
									<cfset selectd['l5'] = refindnocase("^#nav5.displayurlpath#", "/" & path)>
									<li class="navlevel5<cfif selectd['l5']> itemOn5</cfif>"><a href="#nav5.displayurlpath#" <cfif left(nav5.displayurlpath,1) EQ "h">target="_blank"</cfif>>#nav5.pagename#</a></li>
								</cfloop>
							</cfif>
						</cfloop>
					</cfif>
					<cfif selectd['l3']>
						<li class="menuSepBot"></li>
					</cfif>
				</cfloop>
				</cfoutput>   
			</ul>
		</cfsavecontent>
		<cfreturn contents>
	</cffunction>
    
	<!---
    <cffunction name="getImageFiles">
		<cfargument name="directory" type="string">
		
		<cfset var imagefiles = structnew()>
    	<cfset var filesystem = createObject('component', 'utilities.filesystem')>
		
        <cfif directoryexists(requestObject.getVar('machineroot') & arguments.directory)>
        	<cfset imagefiles = filesystem.getDirectoryListing(requestObject.getVar('machineroot') & arguments.directory)>
            <cfquery name="imagefiles" dbtype="query">
            	SELECT name FROM imagefiles WHERE name LIKE '%.jpg'
            </cfquery>
            <cfloop query="imagefiles">
            	<cfset imagefiles.name[imagefiles.currentrow] = arguments.directory & name>
            </cfloop>
        <cfelse>
        	<cfset imagefiles = querynew('default')>
        </cfif>
		<cfreturn imagefiles>
    </cffunction>
	--->
    
	<cffunction name="makeMainFlashNav">
		<cfset var lcl = structnew()>
	
		<cfset lcl.flashvars = structnew()>
		<cfset lcl.silo = listfirst(requestObject.getformurlvar('path'),'/')>

		<cfset lcl.season = requestObject.getVar('season')>		
    	<cfset lcl.backgroundimgs = '""'>			
    	<cfset lcl.height = ''>
    	<cfset lcl.width = '968'>
		<cfset lcl.pagetemplate = pageref.getField('template')>
		
		<cfif lcl.pageTemplate EQ 'home'>
			<cfset lcl.silo = lcl.silo & 'home'>
		</cfif>
		
		<cfset lcl.breadcrumbs = pageref.getField('breadcrumbs')>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>

		<!--- get list of background images based on silo, if silo folder doesn't exist use default folder --->
    	<cfset lcl.backgroundimgs = getImageFiles('/docs/#lcl.season#bgimages/#lcl.silo#/')>		
		
		<cfif not structkeyexists(lcl.backgroundimgs, 'name')>
    		<cfset lcl.backgroundimgs = getImageFiles('/docs/#lcl.season#bgimages/default/')>
        </cfif>		
        
        <cfif lcl.silo EQ 'home'>
        	<cfset lcl.flashvars.showweather = 1>
        </cfif>
        
		<cfset lcl.flashvars.backgroundimgs = '"#valuelist(lcl.backgroundimgs.name,",")#"'>
				
		<!--- homepage vars - other page vars --->
		<cfif lcl.pageTemplate EQ 'home'>
    		<cfset lcl.height = '505'>
			<cfset lcl.flashvars.homepage = 1>
		<cfelse>
    		<cfset lcl.height = '164'>
		</cfif>
        
		<!--- subsite's flash vars, need the top landing page id --->
		<cfif isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs) AND (gettoken(lcl.breadcrumbs[1],1,"~") neq 'Home')>
			<cfset lcl.flashvars.navstart = '"' & gettoken(lcl.breadcrumbs[1],2,"~") & '"'>
		</cfif>

		<cfsavecontent variable="lcl.html">
			<cfoutput>            
			<div id="flashMenu">
				<img src="/ui/images/menupresub<cfif lcl.pagetemplate eq 'Home'>home</cfif>#requestObject.getVar('season')#.jpg" width="969" usemap="##Map" alt=""/>
				<map name="Map" id="Map">
				<area shape="rect" coords="55,58,143,116" href="/" alt="Home" />
				<area shape="rect" coords="177,75,303,92" href="/MountainActivities" alt="Mountain Activities" />
				<area shape="rect" coords="328,76,484,92" href="/ResortActivities/" alt="Resort Activities" />
				<area shape="rect" coords="505,75,623,91" href="/VacationPlanning/" alt="Vacation Planning" />
				<area shape="rect" coords="643,74,700,92" href="/Lodging/" alt="Lodging" />
				<area shape="rect" coords="720,75,837,92" href="/GroupsandMeetings/" alt="Groups and Meetings" />
				<area shape="rect" coords="855,72,933,91" href="/RealEstate/" alt="Real Estate" />
				</map>
			</div>
			
			<script type="text/javascript">
				function resizeFlashMenu(value){
					document.getElementById("flashMenu").height = Number(value);
				}
				
				var flashvars = {};
				<cfloop collection="#lcl.flashvars#" item="indx">
				flashvars.#lcase(indx)# = #lcl.flashvars[indx]#;
				</cfloop>
				flashvars.imagetime = 10;
				var params = {};
				params.allowscriptaccess = "always";
				params.scale = "noscale";
				params.wmode = "transparent";
				var attributes = {};
				swfobject.embedSWF("/ui/flash/menu.swf", "flashMenu", "#lcl.width#", "#lcl.height#", "8.0.0", "/ui/flash/expressInstall.swf", flashvars, params, attributes);
			</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.html>
	</cffunction>	
	
	<!---  
	<cffunction name="makeSubNavBlob">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
	
		<cfset lcl.dhtmlnav = pageref.getDHTMLnav()>
		
		<cfsavecontent variable="contents">
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
				<ul id="_#secondLevelid#" class="scndryNav_off">
				<cfoutput>
					<li><a href="/#thirdurlpath#">#thirdpagename#</a></li>
				</cfoutput>
				</ul>
			</cfoutput> 
		</cfsavecontent>
		
		<cfreturn contents>
	</cffunction>
	 --->
	<cffunction name="makeDHTMLNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>
		
		<cfset lcl.breadcrumbs = pageref.getField('breadcrumbs')>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfset lcl.topid = "">
		<cfif (isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs))>
			<cfset lcl.topid = gettoken(lcl.breadcrumbs[1],2,"~")>
		</cfif>
		<cfset lcl.dhtmlnav = pageref.getDHTMLnav(id = lcl.topid)>

		<cfsavecontent variable="contents">
			<ul id="nav" >
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
            	<cfset arrayclear(tclass)>
            	<cfif lcl.dhtmlnav.currentrow EQ 1><cfset arrayappend(tclass, 'first')></cfif>
                <cfif refindnocase("^#lcl.dhtmlnav.secondurlpath#", path)><cfset arrayappend(tclass, 'itemOn')></cfif>
				<li <cfif arraylen(tclass)>class="#arraytolist(tclass," ")#"</cfif>><a href="#secondurlpath#">#secondpagename#</a>
				<cfif thirdurlpath NEQ "">
				<cfset cntrs = 0>
				<cfoutput>
					<cfset cntrs = cntrs + 1>
					<cfif cntrs EQ 1>
						<!---<div>--->
						<ul class="sub">
						<li class="first"><a href="#thirdurlpath#">#thirdpagename#</a></li>
					<cfelse>
						<li><a href="#thirdurlpath#">#thirdpagename#</a></li>
					</cfif>
				</cfoutput>
				<cfif cntrs>
					</ul>
					<!---</div>--->
				</cfif>
				</cfif>
				</li>
			</cfoutput>
			</ul>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	
	<cffunction name="makeXMLNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>
		<cfset var navstart = ''>
		<cfif requestObject.isformurlvarset('navstart')>
			<cfset navstart = requestObject.getFormUrlVar('navstart')>
		</cfif>
		<cfset lcl.dhtmlnav = pageref.getDHTMLnav(navstart)>

		<cfsavecontent variable="contents">
			<menu>
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
				<item>
					<link>#secondurlpath#</link>
					<label>#secondpagename#</label>
				<cfif thirdurlpath NEQ "">
				<cfset cntrs = 0>
				<cfoutput>
					<item>
						<link>#thirdurlpath#</link>
						<label>#thirdpagename#</label>
					</item>
				</cfoutput>
				</cfif>
				</item>
			</cfoutput>
			</menu>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	<!---
	<cffunction name="makeMainNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>

		<cfset lcl.dhtmlnav = pageref.getDHTMLnav()>

		<cfsavecontent variable="contents">
			<ul>
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
				<li>
					<a href="#secondurlpath#">#secondpagename#</a>
				<cfif thirdurlpath NEQ "">
					<ul>
				<cfset cntrs = 0>
				<cfoutput>
					<li>
						<a href="#thirdurlpath#">#thirdpagename#</a>
					</li>
				</cfoutput>
				</ul>
				</cfif>
				</li>
			</cfoutput>
			</ul>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	--->
    
	<cffunction name="showHTML">
		
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>

		<cfif structkeyexists(variables.data, 'dhtmlnav')>
			<cfreturn makeDHTMLNav()>
		<cfelseif structkeyexists(variables.data, 'mainFlashNav')>
			<cfreturn makeMainFlashNav()>
		<cfelseif structkeyexists(variables.data, 'subnav')>
			<cfreturn makeSubNav()>
		<cfelseif structkeyexists(variables.data, 'subnavblob')>
			<cfreturn makeSubNavBlob()>
		<cfelseif structkeyexists(variables.data, 'view') AND variables.data.view EQ 'xmlnav'>
			<cfreturn makexmlnav()>
		<cfelse>
			<cfthrow message="uhh, what nav to use?">
			<cfreturn makeMainNav()>
		</cfif>
		
		<cfreturn contents>
	</cffunction>
	--->
</cfcomponent>