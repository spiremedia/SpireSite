<cfcomponent name="assetimages" extends="resources.abstractController">
	<cffunction name="default">
		<cfset var lcl = structnew()>
		<cfif isdefined("variables.data.assetid")>
			<cfset lcl.assetObj = createObject("component","modules.assets.model").init(requestObject)>
			<cfset variables.asset = lcl.assetObj.getAsset(variables.data.assetid)>
		
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showhtml">
		<cfset var lcl = structnew()>
		<cfif NOT structkeyexists(variables, "asset")>
			<cfreturn "Incomplete Asset Definition">
		</cfif>
		<cfif variables.asset.recordcount EQ 0>
			<cfreturn "">
		</cfif>
		<cfset lcl.html = '<img src="/docs/assets/#variables.asset.id#/#variables.asset.filename#">'>
		<cfif variables.data.link NEQ "">
			<cfif left(variables.data.link,4) EQ "http">
				<cfset lcl.target=" target=""_blank""">
			<cfelse>
				<cfset lcl.target="">
			</cfif>
			<cfset lcl.html = '<a #lcl.target# href="#variables.data.link#">#lcl.html#</a>'>
		</cfif>

		<cfreturn lcl.html>
	</cffunction>
</cfcomponent>