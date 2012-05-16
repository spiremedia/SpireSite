<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">	
		<cfset var localrequestObj = createObject("component", "resources.request").init()>
		<cfset variables.requestStub = createObject("component", "resources.altformurlrequestDecorator").init(localrequestObj)>
		<cfset variables.pager = createObject("component", "utilities.pager")>
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		
	</cffunction>
	
	<cffunction name="normaltest">
		<cfset var rp = structnew()>
		<cfset var l = structnew()>
		<cfset var fields = "hi,what,when">
		<cfset var tq = querynew(fields)>
		
		<cfset var itemsperpage = 4>
		<!--- pack fake query --->
		<cfloop from="1" to="40" index="l.i">
			<cfset queryaddrow(tq)>
			<cfloop list="#fields#" index="l.field">
				<cfset querysetcell(tq, l.field, createuuid())>
			</cfloop>
		</cfloop>
		
		<cfset s.whoa = 2>
		<cfset variables.requestStub.setRequestFields(s)>
		
		<cfset variables.pager.init(variables.requestStub)>
		
		<cfset variables.pager.setitemsperpage(itemsperpage)>
		<cfset variables.pager.setpageingident("whoa")>
		<cfset variables.pager.seturl("/me3/")>
		<!--- <cfset variables.pager.seturlparams(me="when",me3="why")> --->
		<cfset l.newq = variables.pager.chopquery(tq)>
<!--- <cfdump var=#l.newq#>
<cfdump var=#tq#>
<cfabort> --->
		<!--- do some checking of the resultsset --->
		<cfset asserttrue(condition = (l.newq.recordcount EQ itemsperpage),message="chop query gave #l.newq.recordcount# instead of #itemsperpage#")>
		<cfset asserttrue(condition = (tq["what"][s.whoa * itemsperpage - itemsperpage +1] EQ l.newq["what"][1]),message="first record not correct")>
		<cfset asserttrue(condition = (tq["what"][s.whoa * itemsperpage] EQ l.newq["what"][itemsperpage]),message="last record not correct")>
		
		<cfset l.contents = variables.pager.showPageLinks()>
		<cfset asserttrue(condition = refind("^<div class=""pageing"">.+</div>$", l.contents), message="not nested in div tags properly")>
	</cffunction>
	
	<cffunction name="shorttest">
		<cfset var rp = structnew()>
		<cfset var l = structnew()>
		<cfset var fields = "hi,what,when">
		<cfset var tq = querynew(fields)>
		
		<cfset var itemsperpage = 4>
		<!--- pack fake query --->
		<cfloop from="1" to="6" index="l.i">
			<cfset queryaddrow(tq)>
			<cfloop list="#fields#" index="l.field">
				<cfset querysetcell(tq, l.field, createuuid())>
			</cfloop>
		</cfloop>
		
		<cfset s.whoa = 2>
		<cfset variables.requestStub.setRequestFields(s)>
		
		<cfset variables.pager.init(variables.requestStub)>
		
		<cfset variables.pager.setitemsperpage(itemsperpage)>
		<cfset variables.pager.setpageingident("whoa")>
		<cfset variables.pager.seturl("/me3/")>
		<!--- <cfset variables.pager.seturlparams(me="when",me3="why")> --->
		<cfset l.newq = variables.pager.chopquery(tq)>
<!--- <cfdump var=#l.newq#>
<cfdump var=#tq#>
<cfabort> --->
		<!--- do some checking of the resultsset --->
		<cfset asserttrue(condition = (l.newq.recordcount EQ 2),message="chop query gave #l.newq.recordcount# instead of 2")>
		<cfset asserttrue(condition = (tq["what"][s.whoa * itemsperpage - itemsperpage +1] EQ l.newq["what"][1]),message="first record not correct")>
		<cfset asserttrue(condition = (tq["what"][6] EQ l.newq["what"][2]),message="last record not correct")>
		
		<cfset l.contents = variables.pager.showPageLinks()>

		<cfset asserttrue(condition = refind("^<div class=""pageing"">.+</div>$", l.contents), message="not nested in div tags properly")>
	</cffunction>
	
</cfcomponent>