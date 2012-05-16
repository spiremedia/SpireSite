<cfcomponent name="filesystem">
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="iniparser" returntype="struct" output="false">
		
		<cfargument name="path" required="true">
		
		<cfset var iniString = "">
		<cfset var iniList = "">
		<cfset var iniStruct = structnew()>
	
		<cfif not fileexists(arguments.path)>
			<cfthrow message="file for ini not found">
		</cfif>
		
		<cffile action="read" file="#arguments.path#" variable="iniString">
		
		<cfset iniString = trim(iniString)>
		
		<cfset iniList = listtoarray(iniString, '#chr(13)##chr(10)#')>
		
		<cftry>
			<cfloop from="1" to="#arraylen(iniList)#" index="i">
				<cfset iniList[i] = trim(iniList[i])>
				<cfset iniStruct[trim(getToken(iniList[i],1, '='))] = trim(getToken(iniList[i],2, '='))>
			</cfloop>
			
			<cfcatch>
				<cfthrow message="Failed parsing ini file">
			</cfcatch>
		</cftry>
		
		<cfreturn iniStruct>
	</cffunction>
	
	<cffunction name="getDirectoryListing">
		<cfargument name="dir">
		<cfset var mydir = "">
		<cfdirectory action="list" directory="#arguments.dir#" name="mydir">
		<cfreturn mydir>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="path">
		<cfset var ok = 1>
		<cfif  fileexists(path)>
			<cffile action="delete" file="#arguments.path#">
		<cfelse>
			<cfset ok = "file not found">
		</cfif>
		<cfreturn ok>
	</cffunction>
	
	<cffunction name="cleardirectory">
		<cfargument name="path">
		<cfset var l = structnew()>
		<cfset l.sizea = arraynew(1)>
		
		<cfdirectory action="list" name="l.fulllist" recurse="yes" directory="#path#">
		
		<cfloop query="l.fulllist">
			<cfif type EQ "file">
				<cffile action="delete" file="#directory#/#name#">
			</cfif>
		</cfloop>
		
		<cfloop query="l.fulllist">
			<cfif type EQ "dir">
				<cfdirectory action="delete" directory="#directory#/#name#" recurse="true">
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>  