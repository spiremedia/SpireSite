<cfset lcl.block = getDataItem('block')>

<cfoutput>
	<cfif lcl.block.getData() NEQ "">
    	<div id="clientViewCntnr">
			<iframe id="clientView" height="400" width="700" name="clientView" src="#variables.securityObj.getCurrentSiteUrl()#system/blockpreview/#lcl.block.getId()#"></iframe>
        </div>
	</cfif>
</cfoutput>