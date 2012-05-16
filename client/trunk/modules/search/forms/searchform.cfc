<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>

		<cfset variables.forminfo.title = "Site Search Form">
		<cfset variables.forminfo.name = "fullsearchform">
		<cfset variables.forminfo.action="/search/">
		<cfset variables.forminfo.method="get">
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('criteria')>
		<cfset lcl.txt.setLabel('Keywords')>
		<cfset lcl.txt.setDefault(requestObject.getFormUrlVar("criteria",""))>
		
		<!--- 
		<cfset lcl.txt = addItem("select")>
		<cfset lcl.txt.setName('price_range')>
		<cfset lcl.txt.setLabel('Price Range')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.data = structnew()>
		<cfset lcl.data.list = "AZ,AL">
		<cfset lcl.txt.setData(lcl.data)>
		<cfset lcl.txt.setDefault(variables.clientObj.getState())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('postalcode')>
		<cfset lcl.txt.setLabel('Zip')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.addValidation("iszip")>
		<cfset lcl.txt.setDefault(variables.clientObj.getPostalCode())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('email')>
		<cfset lcl.txt.setLabel('Email')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		<cfset lcl.txt.addValidation("validemail")>
		<cfset lcl.txt.setDefault(variables.clientObj.getEmail())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('homephone')>
		<cfset lcl.txt.setLabel('Home Phone')>
		<cfset lcl.txt.setDefault(variables.clientObj.getHomePhone())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('mobilephone')>
		<cfset lcl.txt.setLabel('Cell Phone')>
		<cfset lcl.txt.setDefault(variables.clientObj.getMobilePhone())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('fax')>
		<cfset lcl.txt.setLabel('Fax')>
		<cfset lcl.txt.setDefault(variables.clientObj.getFax())> --->

		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('')>
		<cfset lcl.sbm.setName('searchBtn')>

	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
	
		<cfset var vdtr = super.validate(clear)>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = "/user">
		<cfset s.message = "Searc">
		<cfreturn s>
	</cffunction>
</cfcomponent>