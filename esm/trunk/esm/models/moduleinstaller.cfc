<cfcomponent name="Module Installer" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="install">
		<cfargument name="info" required="true">
		<cfset variables.info = arguments.info>
		<cfset variables.notes = createobject('component', 'utilities.notetaker').init()>
		<cfset createDirs()>
		<cfset downloadziptowork()>
		<cfif NOT checksafe()>
			<cfreturn notes.show()>
		</cfif>
		<cfset extractzipfiles()>
		<cfset installdatabase()>
		<cfset cleanup()>
		<cfreturn notes.show()>
	</cffunction>
	
	<cffunction name="createDirs">
		<cfdirectory action="create" directory="#requestObj.getVar("machineroot") & variables.info.module#" mode="664">
		<cfset notes.note('Created dir "#variables.info.module#".')>
		<cfdirectory action="create" directory="#requestObj.getVar("machineroot") & variables.info.module#/work" mode="664">
		<cfset notes.note('Created dir "#variables.info.module#/work".')>
	</cffunction>
	
	<cffunction name="downloadziptowork">
		<cfset l = structnew()>
		<cfhttp
		    method="Get"
		    url="http://esm3installer.spiremedia.com/#variables.info.esm_zip#"
		    path="#requestObj.getVar("machineroot") & "/" & variables.info.module & "/work"#"
		    file="modulezip.zip">
		<cfset notes.note('Downloaded Zip file.')>
	</cffunction>
	
	<cffunction name="checksafe">
		<cfset var l = structnew()>
		<!--- is a real zip file? --->
		<cftry>
		<cfzip  
			action = "list"
		    	file = "#requestObj.getVar("machineroot") & variables.info.module & "/work/modulezip.zip"#"
		    		name = "l.zipcontents"
		    			recurse = "yes">
			<cfcatch>
				<cfset notes.note('Zip file invalid. Please check your download and/or examine the file for validity.')>
				<cfreturn false>
			</cfcatch>
		</cftry>
		
		<cfif l.zipcontents.recordcount EQ 0>
			<cfset notes.note('Zip file empty. Please check your download and/or examine the file for validity.')>
			<cfreturn false>
		</cfif>
		
		<cfset notes.note('Checked download for coherence(well. . . a little bit).')> 
		<cfreturn true>
	</cffunction>
	
	<cffunction name="extractzipfiles">
		<cfzip
		    action = "unzip"
		    destination = "#requestObj.getVar("machineroot") & "/" & variables.info.module#"
		    file = "#requestObj.getVar("machineroot") & "/" & variables.info.module & "/work/modulezip.zip"#"
		    overwrite = "yes"
		    recurse = "yes"
		    storePath = "yes">
		<cfset notes.note('Successfully extracted zip contents.')>
	</cffunction>
	
	<cffunction name="installdatabase">
		<cfset l = structnew()>
		<cfif fileexists("#requestObj.getVar("machineroot") & "/" & variables.info.module & "/install/installer.cfc"#")>
			<cfset notes.note('Module installer found.')>
			<cfset l.inst = createObject("component","#variables.info.module#.install.installer").init(requestObj)>
			<cfset notes.note("Installing ... " & l.inst.install(variables.info.module))>
			<cfif NOT l.inst.hasissue()>
				<cfset variables.nodeleteinstall = 1>
			</cfif>
		<cfelse>
			<cfset notes.note('No module installer found.')>
		</cfif>
	</cffunction>
	
	<cffunction name="cleanup">
		<cfset var l = structnew()>
		<cfdirectory action="list" name="l.list" directory="#requestObj.getVar("machineroot") & variables.info.module#/work">
		
		<cfloop query="l.list">
			<cffile action="delete" file="#l.list.directory#/#l.list.name#">
		</cfloop>
		
		<cfdirectory action="delete" directory="#requestObj.getVar("machineroot") & variables.info.module#/work">
		
		<cfif structkeyexists(variables,"nodeleteinstall")>
			<cfset notes.note('<b>Due to issues installing, installer folder not deleted. Please remove after corrective action.</b>')>
		<cfelse>
			<cfdirectory action="list" name="l.list" directory="#requestObj.getVar("machineroot") & variables.info.module#/install/dbobjects">
			
			<cfloop query="l.list">
				<cffile action="delete" file="#l.list.directory#/#l.list.name#">
			</cfloop>
			
			<cfdirectory action="list" name="l.list" directory="#requestObj.getVar("machineroot") & variables.info.module#/install">

			<cfloop query="l.list">
				<cffile action="delete" file="#l.list.directory#/#l.list.name#">
			</cfloop>
			
			<cfif directoryexists("#requestObj.getVar("machineroot") & variables.info.module#/install")>
				<cfdirectory action="delete" directory="#requestObj.getVar("machineroot") & variables.info.module#/install">
			</cfif>
			<cfset notes.note('Deleted Install directory.')>
		</cfif>
		
		<cfset notes.note('Completed cleanup.')>
	</cffunction>
</cfcomponent>
	
	