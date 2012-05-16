<cfcomponent extends="resources.abstractsubController" ouput="false">

	<cffunction name="init" output="false">
		<cfset var lcl = structnew()>
		<cfset variables.resultitems = "">
		<cfset super.init(argumentcollection = arguments)>	
		<cfset lcl.rows = requestObject.getFormUrlvar("ipp", 15)>
		<cfif lcl.rows EQ "">
			<cfset lcl.rows = 15>
		</cfif>
		
		<cfset variables.error = false>

		<cfif variables.requestObject.getformurlvar('criteria', "") EQ "">
        	<cfreturn this>
        </cfif>
        
		<cfset variables.criteria = variables.requestObject.getformurlvar('criteria')>
		<cfset variables.criteria = REReplace(variables.criteria, "(\(|\)|=|!)", "", "all")>

		<cfset l['criteria'] = variables.criteria>
	
		<cfset structappend(l, url)>
	
	 	<cfset lcl.collectionname = requestObject.getVar("collectionname", requestObject.getVar("sitename"))>
		<cfset lcl.collectiontype = requestObject.getVar("collectiontype", "cfsolr")>

		<cfset lcl.collection = createObject('component', 'modules.search.models.#lcl.collectiontype#').init(requestObject, lcl.collectionname)>
		<cfset lcl.collection.checkexists()>
		
		<cfset lcl.crit = structnew()>
		<cfset lcl.crit.criteria = variables.criteria>
		<cfset lcl.crit.categories = "">
		
		<cfset lcl.crit = requestObject.notifyObservers("search.searchcriteria", lcl.crit)>
		
		<cfset lcl.resultObj = lcl.collection.searchSite(lcl.crit, lcl.rows)>
		<cfset lcl.searchresults = lcl.resultObj.getSearchRs()>
		<cfset lcl.searchrecordcount = lcl.resultObj.getRecordsFound()>

		<!--- setup the pager --->
		<cfset variables.pager = this.getUtility("pager").init(requestObject)>
		
		<cfif isQuery(lcl.searchResults)>
			<cfset variables.pager.setItemsPerPage(lcl.rows)>
			<cfset variables.pager.setUrlParams(l)>
       		<cfif lcl.resultObj.doChop()>
				<cfset variables.pager.setparams(rows=lcl.searchResults.recordcount)>
				<cfset lcl.searchResults = variables.pager.chopQuery(lcl.searchResults)>
			<cfelse>
				<cfset variables.pager.setparams(rows=lcl.searchrecordcount)>
			</cfif>
		</cfif>
		
        <cfset variables.pager.setTitlePattern('<div class="subtitle">Displaying {pagestartindex}-{pageendindex} of {recordsfound} results</div>')>
		
		<cfset lcl.a = arraynew(1)>
		<cfset lcl.selectedsort = requestObject.getFormUrlVar("sort", lcl.rows)>
		<cfset arrayappend(lcl.a, '<form><table width="100%"><tr><td>Order Results By: <select class="sort" name="sort">')>
		<cfloop list="Relevance,Price (Low to High)|price_up,Price (High to low)|price_down,Alphabetically|title,Country" index="lcl.itms" delimiters=",">
			<cfset lcl.label = listfirst(lcl.itms,"|")>
			<cfset lcl.value = listlast(lcl.itms,"|")>
			<cfset arrayappend(lcl.a, '<option #iif(lcl.selectedsort EQ lcl.value, DE("selected"), DE(""))# value="#lcl.value#">#lcl.label#</option>')>
		</cfloop>
		<cfset arrayappend(lcl.a, '</select></td>')>

		<cfset lcl.selectedcount = requestObject.getFormUrlVar("ipp", lcl.rows)>
		<cfset arrayappend(lcl.a, '<td >Results Per Page: <select class="ipp" name="ipp">')>
		<cfloop list="#lcl.rows#,25,50" index="lcl.itms">
			<cfset arrayappend(lcl.a,"<option #iif(lcl.selectedcount EQ lcl.itms, DE("selected"), DE(""))#>#lcl.itms#</option>")>
		</cfloop>
		<cfset arrayappend(lcl.a, '</select></td>')>
		
		<cfsavecontent variable="lcl.chtml">
			<script>
				jQuery("select.sort,select.ipp").change(function(){
					var $this = jQuery(this);
					var name = $this.attr("name");
					jQuery(".fullsearchform #" + name).val($this.val());
					jQuery("form.fullsearchform").submit();
				});
			</script>
		</cfsavecontent>
		
		<cfset arrayappend(lcl.a, lcl.chtml)>
		
		<cfset variables.pager.setWrapPattern('<div id="julio" class="pageing"><div class="pageof">#arraytolist(lcl.a, "")# <td>Page {currentpage} of {totalpages}</td> <td class="right" style="text-align:right">{contents}</td></tr></table></form></div></div>')>
		<cfset variables.pager.setNoRecordsTitlePattern("No records were found")>
		
		<!--- create a view cfc for each record --->
		<cfset variables.resultitems = arraynew(1)>

		<cfloop query="lcl.searchresults">
			<cfset lcl.iteminfo = structnew()>
			<cfloop list="#lcl.searchresults.columnlist#" index="lcl.lidx">
				<cfset lcl.iteminfo[lcl.lidx] = lcl.searchresults[lcl.lidx][currentrow]>
			</cfloop>
			<cfset lcl.iteminfo.description = lcl.iteminfo.custom1>
			<cfset lcl.iteminfo.objid = lcl.iteminfo.custom2>
			<cfset lcl.iteminfo.viewcfc = lcl.iteminfo.custom3>
			<cfset lcl.iteminfo.type = lcl.iteminfo.custom4>
			<cfset structdelete(lcl.iteminfo, "custom1")>
			<cfset structdelete(lcl.iteminfo, "custom2")>
			<cfset structdelete(lcl.iteminfo, "custom3")>
			<cfset structdelete(lcl.iteminfo, "custom4")>
			<cfset lcl.thisitem = createObject("component", "#lcl.iteminfo.viewcfc#").init(requestObject)>
			<cfset lcl.thisitem.setData(lcl.iteminfo)>
			<cfset arrayappend(variables.resultitems, lcl.thisitem)>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfset var lcl = structnew()>
		<cfoutput>
		<cfsavecontent variable="lcl.html">
			<cfif isarray(variables.resultitems)>
				<!--- Top Paging --->
				<cfoutput>
					#variables.pager.showTitle()#
					#variables.pager.showPageLinks()#
				</cfoutput>	
				<cfif arraylen(variables.resultitems)>
					<hr class="fullwidthdottedhr" style="margin:10px 0;"/>
					<cfloop array="#variables.resultitems#" index="lcl.idx">
						#lcl.idx.showhtml()#
					</cfloop>
					<hr class="fullwidthdottedhr" style="margin:10px 0;"/>
					<!--- Bottom Paging --->
					#variables.pager.showPageLinks()#
				</cfif>
			<cfelseif isdefined("variables.error") AND isboolean(variables.error) AND variables.error>
				<p>An Error occured while performing your search.  </p>
				<p>You can use "and" and "or" operators to refine your search. However if you wish to search for "and" or "or", please enclose the term with quotes. Since "and" and "or" are search operators, please do not start or end your search with either.</p>
			<cfelseif NOT isdefined("variables.criteria")>
				<p>Please enter a string to search for in the keywords box.</p>
			<cfelse>
				<p>Please use the search box on every page to search the site.</p>
			</cfif>
		</cfsavecontent>
		</cfoutput>	
		<cfreturn lcl.html>
	</cffunction>

</cfcomponent>

<!--- <cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfset var searchinfo = structnew()>
		<cfset var l = structnew()>
		<cfset super.init(argumentcollection = arguments)>
		
        <cfset variables.searchresults = "">		
		<cfset variables.error = false>		

		<cfif NOT variables.requestObject.isformurlvarset('criteria')>
        	<cfreturn this>
        </cfif>
        
		<cfset variables.criteria = variables.requestObject.getformurlvar('criteria')>
		<cfset variables.criteria = REReplace(variables.criteria, "(\(|\)|=|!)", "", "all")>
		<cfset l['criteria'] = variables.criteria>

		<cfset searchSite()>
		
		<cfset variables.pager = this.getUtility("pager").init(requestObject)>
		<cfif isQuery(variables.searchResults)>
       		<cfset variables.pager.setparams(rows=variables.searchResults.recordcount)>
			<cfset variables.pager.setItemsPerPage(10)>
			<cfset variables.pager.setUrlParams(l)>
			<cfset variables.searchResults = variables.pager.chopQuery(variables.searchResults)>
		</cfif>
        <cfset variables.pager.setTitlePattern("Your search returned {recordsfound} results")>
		<cfset variables.pager.setNoRecordsTitlePattern("No records were found")>
		<cfreturn this>
	</cffunction>
    

	
	<cffunction name="checkCollectionExists" outpout="false">
		<cfset var qryCollections = "">
		<cfset var collectionList = "">
		
		<cfcollection action="list" name="qryCollections">
		<cfset collectionList = ValueList(qryCollections.name)>

		<cfif not ListFindNoCase(collectionList,variables.data.collectionName)>
			<cfcollection action="create" collection="#variables.data.collectionName#" path="#variables.requestObject.getVar('collectionPath')#">
		</cfif>

		<cfreturn>
	</cffunction>
	
	<cffunction name="saveSearchCriteria">
		<cfset var id = createuuid()>
		<cfset var criteria = variables.criteria>
		
		<cfif len(criteria) gt 100>
			<cfset criteria = left(criteria,100)>
		</cfif>
		
		<cfquery name="currentpages" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO siteSearches (
				id,
				criteria,
				recordsfound,
				siteid
			) VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#criteria#" cfsqltype="cf_sql_varchar" maxlength="100">,
				<cfqueryparam value="#variables.totalSearchRecords#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<!---<cffunction name="renderPaging" output="false">
		<cfset var lcl = structnew()>
	
		<cfsavecontent variable="lcl.html">
			<cfoutput>
				
			<div class="srchpaging">
			<cfif variables.page NEQ 1 AND variables.totalSearchRecords GTE variables.rowcount>
				<a href="?page=#variables.page-1#&search=#variables.criteria#">Previous</a>
			<cfelse>
				Previous
			</cfif>
			
			<cfif variables.totalSearchRecords GTE variables.rowcount>
				<cfset lcl.startLoop = 1>
				<cfset lcl.endLoop = ceiling(variables.totalSearchRecords / variables.rowcount)>
				<cfloop from="#lcl.startLoop#" to="#lcl.endLoop#" index="lcl.indx">
					<cfif variables.page EQ lcl.indx>
						<cfif lcl.endLoop gt 7 AND lcl.indx eq 3>
							..
						</cfif>
						<b>#lcl.indx#</b>
						<cfif lcl.endLoop gt 7 AND lcl.indx gte 7 AND lcl.indx neq lcl.endLoop AND lcl.indx neq (lcl.endLoop - 1)>
							..
						</cfif>
					<cfelse>
						<!--- if lte 7 pages, show all page numbers --->
						<cfif lcl.endLoop lte 7>
							<a href="?page=#lcl.indx#&search=#variables.criteria#">#lcl.indx#</a>
						<!--- if gt 7 pages, show certain page numbers --->
						<cfelseif listfind("1,4,5,6,#lcl.endLoop#",lcl.indx)>
							<a href="?page=#lcl.indx#&search=#variables.criteria#">#lcl.indx#</a>
						<cfelseif listfind("3,7",lcl.indx)>
							..
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
	
			<cfif variables.page NEQ ceiling(variables.totalSearchRecords / variables.rowcount)>
				<a href="?page=#variables.page+1#&search=#variables.criteria#">Next</a>
			<cfelse>
				Next
			</cfif>
			</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.html>
	</cffunction>--->

	<!---<cffunction name="renderTopPaging" output="false">
		<cfset var lcl = structnew()>
	
		<cfsavecontent variable="lcl.html">
			<cfoutput>
				You searched: <i>#variables.criteria#</i><br>
				#variables.pager.showTitle()#<br>
				#variables.pager.showPageLinks()#
				<!---><div>
					<cfif requestObject.isFormUrlVarSet('search')>Results For: #requestObject.getFormUrlVar('search')#</cfif>
				</div>
				<br class="clear"/>
				<div>
					Displaying  
					<cfif variables.totalSearchRecords>
						#variables.page * variables.rowcount - variables.rowcount + 1#
					<cfelse>
						0
					</cfif>
					thru 
					<cfif variables.page * variables.rowcount GT variables.totalSearchRecords>
						#variables.totalSearchRecords#
					<cfelse>
						#variables.page * variables.rowcount#
					</cfif>
					of #variables.totalSearchRecords# Results <br />
				</div>
				<cfif variables.totalSearchRecords GT variables.rowcount>
					#variables.renderPaging()#
				</cfif>
				<br class="clear"/>--->
			</cfoutput>
		</cfsavecontent>
		<cfreturn lcl.html>
	</cffunction>--->
	
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent> --->