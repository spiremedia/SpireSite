<cfcomponent name="fileuploadandsave">
	<cffunction name="init">
		<cfargument name="target" required="true">
		<cfargument name="sitepath" required="true">
		<cfargument name="file" required="true">
		<cfargument name="filetodelete" required="false">
		<cfargument name="alloweableExtensions" default="jpg,gif,png">
		
		<cfset var result = ''>
		<cfset var tempFile = "">
		<cfset var tempFileExt = "">
			
		<cfif isdefined('arguments.filetodelete') AND (arguments.filetodelete NEQ "") AND fileexists("#sitepath#docs/#target#/#filetodelete#")>
			<cffile action="delete" file="#sitepath#docs/#target#/#filetodelete#">
		</cfif>
		<cftry>
			<cffile result="result" action="upload" filefield="#file#" destination="#sitepath#docs/#target#/" nameconflict="makeunique">
			<cfcatch>
				<cfset variables.success = 0>
				<cfset variables.reason = "Error loading file : '#cfcatch.message#'">
				<cfreturn this>
			</cfcatch>
		</cftry>
		<cfset tempFile = REReplace(result.clientFileName, "[^a-zA-Z0-9-_]+", "", "ALL")>
		<cfset tempFileExt = result.clientFileExt>
		
		<!--- check alloweable --->
		<cfif NOT arguments.alloweableExtensions EQ "*" AND NOT listfindnocase(arguments.alloweableextensions, tempFileExt)>
			<cffile action="delete" file="#sitepath#docs/#target#/#result.serverFile#">
			<cfset variables.success = 0>
			<cfset variables.reason = "Invalid file type. Only '#arguments.alloweableExtensions#' allowed.">
			<cfreturn this>
		</cfif>
		<!--- check if file already exist --->
		<cfif fileexists("#sitepath#docs/#target#/#tempFile#.#tempFileExt#")>
			<cfif (result.serverFile eq "#tempFile#.#tempFileExt#")>
				<!--- do nothing, don't need to rename --->
			<cfelse>
				<!--- make filename unique --->
				<cfloop from="1" to="1000" index="i">
					<cfif not fileexists("#sitepath#docs/#target#/#tempFile##i#.#tempFileExt#")>
						<cfset tempFile = "#tempFile##i#">
						<cffile action="rename" source="#sitepath#docs/#target#/#result.serverFile#" destination="#sitepath#docs/#target#/#tempFile#.#tempFileExt#">
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>		
		<cfelse>
			<!--- file doesn't exist, rename --->
			<cffile action="rename" source="#sitepath#docs/#target#/#result.serverFile#" destination="#sitepath#docs/#target#/#tempFile#.#tempFileExt#">
		</cfif>
		
		<cfset variables.serverFile = "#tempFile#.#tempFileExt#">
		<cfset variables.serverFileExt = tempFileExt>
		<cfset variables.filesize = result.filesize>
		<cfset variables.success = result.filewassaved>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="success">
		<cfreturn variables.success>
	</cffunction>
	<cffunction name="reason">
		<cfreturn variables.reason>
	</cffunction>
	<cffunction name="filesize">
		<cfreturn variables.filesize>
	</cffunction>
	<cffunction name="savedName">
		<cfreturn variables.serverfile>
	</cffunction>
	<cffunction name="savedNameExt">
		<cfreturn variables.serverFileExt>
	</cffunction>
</cfcomponent>