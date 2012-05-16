<cfcomponent name="pager" extends="utilities.notetaker">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		
		<cfset super.init()>
		
		<cfset setitemwrap("","")>
		<cfset setwrap("","")>
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.url = "">
		<cfset variables.itemsperpage = 20>
		<cfset variables.current = 1>
		<cfset variables.pageingident = "dd">
		<cfset variables.normallinkclass = "">
		<cfset variables.activelinkclass = "current">
		<cfset variables.disabledlinkclass = "disabled">
		<cfset variables.urlparamsstring = "?">
		<cfset variables.showlinkaround = 3>
		<cfset variables.foundparams = structnew()>
		<!--- link patterns --->
		<cfset variables.linkpattern = '<a {linkclass} href="{link}">{linkstring}</a>&nbsp;&nbsp;'>
		<cfset variables.onlinkpattern = '<span class="blockHighlight">{linkstring}</span>&nbsp;&nbsp;'>
		<cfset variables.wrappattern = '<div class="pageing">{contents}</div>'>
		<cfset variables.prevpattern = '<a {linkclass} href="{linkVeryFirst}" title="First Page"><img src="/ui/images/arrowleftdouble.png" alt="First Page" /></a><a {linkclass} href="{link}" title="Previous Page"><img src="/ui/images/arrowleft.png" alt="Previous Page" /></a>&nbsp;&nbsp;&nbsp;'>
		<cfset variables.onprevpattern = ''><!--- <a {linkclass} href="{link}">[Prev]</a>'> --->
		<cfset variables.nextpattern = '&nbsp;&nbsp;&nbsp;<a {linkclass} href="{link}" title="Next Page"><img src="/ui/images/arrowright.png" alt="Next Page" /></a><a {linkclass} href="{linkVeryLast}" title="Last Page"><img src="/ui/images/arrowrightdouble.png" alt="Last Page" /></a>'>
		<cfset variables.onnextpattern = ''><!---<a {linkclass} href="{link}">[Next]</a>'>--->
		
		<!--- title patterns --->
		<cfset variables.titlepattern = '{currentpage} of {totalpages}'>
		<cfset variables.norecordstitlepattern = ''>
		<cfset variables.norecordspagelinkspattern = ''>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="seturlparams">
		<cfset var key = "">
		
		<cfif arraylen(arguments) EQ 0>
			<cfset arguments[1] = duplicate(url)>
		</cfif>
		
		<cfset structdelete(arguments[1], "path")>
		
		<cfloop collection="#arguments[1]#" item="key">
			<cfif NOT key EQ variables.pageingident>
				<cfset variables.urlparamsstring = urlparamsstring & key & "=" & urlencodedformat(arguments[1][key]) & "&">
			</cfif>
		</cfloop>

	</cffunction>
	
	<cffunction name="showTitle">
		<cfset s = "">
		<cfif variables.foundparams.rows EQ 0>
			<cfset s = variables.norecordstitlepattern>
		<cfelse>
			<cfset s = variables.titlepattern>
			<cfset s = mainpatterns(s)>
		</cfif>
		<cfreturn s>
	</cffunction>
	
	<cffunction name="showPageLinks">
		<cfset var s = "">
		<cfset var count = "">
		<cfset var link = variables.url & variables.urlparamsstring & variables.pageingident & "=" >
		<cfset var s2 = "">
		<cfif variables.foundparams.pagecount EQ 0>
			<cfreturn variables.norecordspagelinkspattern>
		</cfif>
		
		<cfif variables.foundparams.pagecount EQ 1>
			<cfreturn "">
		</cfif>
		
		<!--- setup previous --->
		<cfif variables.foundparams.currentpage EQ 1>
			<cfset s = variables.onprevpattern>
			<cfset s = replace(s, "{linkclass}", iif(variables.activelinkclass NEQ "",DE("class='#variables.activelinkclass#'"),DE("")))>
		<cfelse>
			<cfset s = variables.prevpattern>
			<cfset s = replace(s, "{linkclass}", iif(variables.normallinkclass NEQ "",DE("class='#variables.normallinkclass#'"),DE("")))>
		</cfif>	
		<cfset s = replace(s, "{link}", link & variables.foundparams.currentpage -1)>
		<cfset s = replace(s, "{linkVeryFirst}", link & 1)>
		<cfset s = replace(s, "{linkstring}", variables.foundparams.currentpage -1)>
		<cfset note(s)>
		
		<!--- setup middle --->
        
        <cfif variables.foundparams.pageingstart NEQ 1>
        	<cfset s = "">
            <cfset s = variables.linkpattern>
            <cfset s = replace(s, "{link}", link & 1)>
			<cfset s = replace(s, "{linkstring}", 1)>
            <cfset s = s & "&nbsp;...&nbsp;&nbsp;">
            <cfset note(s)>
        </cfif>
        
		<cfloop from="#variables.foundparams.pageingstart#" to="#variables.foundparams.pageingend#" index="count">
			<cfset s = "">
			
			<cfif count EQ variables.foundparams.currentpage>
				<cfset s = variables.onlinkpattern>
			<cfelse>
				<cfset s = variables.linkpattern>
			</cfif>
			
			<cfif count EQ variables.foundparams.currentpage AND variables.activelinkclass NEQ "">
				<cfset s = replace(s, "{linkclass}", "class='#variables.activelinkclass#'")>
			<cfelseif variables.normallinkclass NEQ "">
				<cfset s = replace(s, "{linkclass}", "class='#variables.normallinkclass#'")>
			<cfelse>
				<cfset s = replace(s, "{linkclass}", "")>
			</cfif>
			
			<cfset s = replace(s, "{link}", link & count)>
			<cfset s = replace(s, "{linkstring}", count)>
			
			<cfset note(s)>
		</cfloop>
        
        <!--- <cfif variables.foundparams.pageingend NEQ variables.foundparams.pagecount>
        	<cfset s = "">
            <cfset s = variables.linkpattern>
            <cfset s = replace(s, "{link}", link & variables.foundparams.pagecount)>
			<cfset s = replace(s, "{linkstring}", variables.foundparams.pagecount)>
            <cfset s = "of&nbsp;&nbsp;<b>" & s & "</b>">
            <cfset note(s)>
        </cfif> --->
		
		<!--- setup next --->
		<cfif variables.foundparams.currentpage EQ variables.foundparams.pagecount>
			<cfset s = variables.onnextpattern>
			<cfset s = replace(s, "{linkclass}", "class='#variables.activelinkclass#'")>
		<cfelse>
			<cfset s = variables.nextpattern>
			<cfset s = replace(s, "{linkclass}", "class='#variables.normallinkclass#'")>
		</cfif>	
		
		<cfset s = replace(s, "{link}", link & variables.foundparams.currentpage +1)>
		<cfset s = replace(s, "{linkVeryLast}", link & variables.foundparams.pagecount)>
		<cfset s = replace(s, "{linkstring}", variables.foundparams.currentpage +1)>
		<cfset note(s)>

		<cfset s2 = replace(variables.wrappattern, "{contents}", show())>
		<cfreturn mainpatterns(s2)>
	</cffunction>
	
	<cffunction name="chopquery">
		<cfargument name="thisquery">
		<cfset var cl = thisquery.columnlist>
		<cfset var rq = querynew(cl)>
		<cfset var qfield = "">
		
		<cfset setparams(thisquery.recordcount)>
		
		<cfloop from="#variables.foundparams.querystartitem#" to="#variables.foundparams.queryenditem#" index="qindex">
			<cfset queryaddrow(rq)>
			<cfloop list="#cl#" index="qfield">
				<cfset querysetcell(rq, qfield, thisquery[qfield][qindex])>
			</cfloop>
		</cfloop>
		
		<cfreturn rq>
	</cffunction>
	
	<cffunction name="setparams">
		<cfargument name="rows">

		<cfparam name="variables.foundparams.recordsfound" default="#arguments.rows#">
		<cfparam name="variables.foundparams.currentpage" default="1">
		<cfif arguments.rows eq "">
			<cfset arguments.rows = 0>
		</cfif>
		<cfparam name="variables.foundparams.rows" default="#arguments.rows#">
		<cfparam name="variables.foundparams.pagecount" default="#ceiling(arguments.rows/variables.itemsperpage)#">
		
		<cfif requestObject.isFormUrlVarSet(variables.pageingident) 
			AND isvalid("integer", requestObject.getFormUrlVar(variables.pageingident))
			AND requestObject.getFormUrlVar(variables.pageingident) NEQ 0>
			<cfset variables.foundparams.currentpage = requestObject.getFormUrlVar(variables.pageingident)>
		</cfif>
		
		<!--- set or default the current page variable --->
		<cfif variables.foundparams.currentpage GT ceiling(variables.foundparams.rows/variables.itemsperpage)>
			<cfset variables.foundparams.currentpage = 1>
		</cfif>
		
		<cfif structkeyexists(variables, "showlinkcount")>
			<cfif variables.foundparams.pagecount LTE variables.showlinkcount 
				OR 
					variables.foundparams.currentpage - int(variables.showlinkcount / 2) LTE 0>
				<cfset variables.foundparams.pageingstart = 1>
				<cfset variables.foundparams.pageingend = variables.showlinkcount>
			<cfelseif (variables.foundparams.currentpage + int(variables.showlinkcount / 2)) GT variables.foundparams.pagecount>
				<cfset variables.foundparams.pageingend = variables.foundparams.pagecount>
				<cfset variables.foundparams.pageingstart = variables.foundparams.pagecount - variables.showlinkcount + 1>
				<cfif variables.foundparams.pageingstart LT 1>
					<cfset variables.foundparams.pageingstart = 1>
				</cfif>
			<cfelse>
				<cfset variables.foundparams.pageingstart = variables.foundparams.currentpage - int(variables.showlinkcount / 2)>
				<cfset variables.foundparams.pageingend = variables.foundparams.currentpage + int(variables.showlinkcount / 2)>
			</cfif>
		<cfelse>
			<cfset variables.foundparams.pageingstart = variables.foundparams.currentpage - variables.showlinkaround>
			<cfset variables.foundparams.pageingend = variables.foundparams.currentpage + variables.showlinkaround>
			<cfif variables.foundparams.pageingstart LT 1>
				<cfset variables.foundparams.pageingstart = 1>		
			</cfif>
			<cfif variables.foundparams.pageingend GT variables.foundparams.pagecount>
				<cfset variables.foundparams.pageingend = variables.foundparams.pagecount>		
			</cfif>
		</cfif>
		
		<!--- setup the start and end for query --->
		<cfset variables.foundparams.querystartitem = variables.foundparams.currentpage * variables.itemsperpage - variables.itemsperpage + 1>
		<cfif (variables.foundparams.currentpage * variables.itemsperpage) gT rows>
			<cfset variables.foundparams.queryenditem = rows>
		<cfelse>
			<cfset variables.foundparams.queryenditem = variables.foundparams.currentpage * variables.itemsperpage>
		</cfif>
	
	</cffunction>
	
	<cffunction name="mainpatterns">
		<cfargument name="s" required="true">
		<cfset s = replace(s, "{pagestartindex}", variables.foundparams.querystartitem)>
		<cfset s = replace(s, "{pageendindex}", variables.foundparams.queryenditem)>
		<cfset s = replace(s, "{currentpage}", variables.foundparams.currentpage)>
		<cfset s = replace(s, "{totalpages}", variables.foundparams.pagecount)>
		<cfset s = replace(s, "{recordsfound}", variables.foundparams.rows)>	
		<cfreturn s>
	</cffunction>
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments" type="struct"> 
		
		<cfif left(missingmethodname, 3) EQ "set" AND listfindnocase("nextpattern,prevpattern,norecordstitlepattern,rows,titlepattern,showlinkcount,pageingident,url,urlparams,divclass,linkpattern,linkclass,wrappattern,startstring,endstring,current,format,itemsperpage", mid(missingmethodname, 4, len(missingmethodname)))>
			<cfset variables[mid(missingmethodname, 4, len(missingmethodname))] = missingmethodarguments[1]>
			<cfreturn>
		</cfif>
		
		<cfthrow message="invalidmethod '#missingmethodname#'">
	</cffunction>
	
</cfcomponent>