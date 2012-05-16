<cfcomponent name="assetslisting utility">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAssetGroupName">
		<cfargument name="agn" required="true">
		<cfset variables.agn = arguments.agn>
	</cffunction>
	
	<cffunction name="setUnDeleteableThruAssets">
		<cfset variables.undeleteablethruassets = 1>
	</cffunction>
	
	<cffunction name="limitFiles">
		<cfargument name="cnt" required="true">
		<cfset variables.limitfiles = cnt>
	</cffunction>
	
	<cffunction name="loadAssets">
		<cfset var l = structnew()>
		<cfset var l2 = structnew()>
		<cfif NOT structkeyexists(variables, "loadedassets")>
			<cfset l.assetGroupMdl = createObject("component","assets.controller").getGroupModel(requestObj, userObj)>
			<cfset l.assetGroup = l.assetGroupMdl.getByName(variables.agn)>
			<cfif l.assetGroup.recordcount>
				<cfset l.assetMdl = createObject("component","assets.controller").getModel(requestObj, userObj)>
				<cfset l.more = structnew()>
				<cfset l.more.ignorebelongsto = 1>
				<cfset l.more.sort = "assets.modified, assets.created">
				<cfset variables.loadedassets = l.assetMdl.getByAssetGroupId(l.assetGroup.id, l.more)>
			<cfelse>
				<cfset variables.loadedassets = querynew("norecrds")>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var html = "">
		<cfset loadAssets()>
		<cfsavecontent variable="html">
			<cfoutput>
			<table class="list" id="#rereplace(variables.agn, "[^a-zA-Z0-9]","","all")#">
				<thead>
				<tr>
					<th>Name</th>
					<th>Filename</th>
					<th>Type</th>
					<th>
						<cfif NOT structkeyexists(variables, "limitfiles") OR variables.limitfiles GT variables.loadedassets.recordcount>
							<a href="javascript:jQuery.facebox('<iframe src=\'/assets/ListedAssetUpload/?groupname=#urlencodedformat(variables.agn)#\' width=\'400\' height=\'200\' border=\'0\'></iframe>');">Upload?</a>
						</cfif>
					</th>
				</tr>
				</thead>
				<cfif variables.loadedassets.recordcount>
					<cfloop query="variables.loadedassets">
					<tr>
						<td>#name#</td>
						<td>
							<cfif filename EQ "">
								(Not file loaded)						
							<cfelse>
								<a href="/docs/assets/#id#/#filename#" target="_blank">#filename#</a>	
							</cfif>
						</td>
						<td>#ucase(listlast(filename,"."))#</td>
						<td>
							<a href="javascript:jQuery.facebox('<iframe src=\'/assets/ListedAssetUpload/?groupname=#urlencodedformat(variables.agn)#&id=#id#\' width=\'400\' height=\'200\' border=\'0\'></iframe');">Edit</a>
							<a href="javascript:deleteAssetListing('#id#', '#variables.agn#');">Delete</a>
							<!---<cfif variables.loadedassets.currentrow NEQ 1>
								<a href="" target="_blank">Up</a> 
							</cfif>
							<cfif variables.loadedassets.currentrow NEQ variables.loadedassets.recordcount>
								<a href="" target="_blank">Down</a>
							</cfif>--->
						</td>
					</tr>
					</cfloop>
				<cfelse>
				<tr>
					<td colspan="4">
					No Assets Loaded.
					</td>
				</tr>
				</cfif>
			</table>
			</cfoutput>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
</cfcomponent>