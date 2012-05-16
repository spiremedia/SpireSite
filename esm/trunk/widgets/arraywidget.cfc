<cfcomponent name="arraywidget" output="false">
	
	<cffunction name="init" output="false">
		<cfset variables.htmlitems = arraynew(1)>
		<cfset variables.mystring = arraynew(1)>
		<cfset variables.active = 1>
		<cfset variables.type = 'accordion'>
		<cfif isdefined("arguments.id")>
			<cfset variables.id = arguments.id>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setID" output="false">
		<cfargument name="id" required="true">
		<cfset variables.id = arguments.id>
	</cffunction>
	
	<cffunction name="settitle" access="private" output="false">
		<cfargument name="title" required="true">
		<cfif variables.type EQ 'accordion'>
			<cfreturn title>
		<cfelse>
			<cfreturn "<span>#title#</span>">
		</cfif>
	</cffunction>
	
	<cffunction name="setinfo" output="false">
		<cfargument name="info" required="true">
		
	</cffunction>
	
	<cffunction name="showHtml" output="false">
		<cfset var s = arraynew(1)>
		<cfset var itmindx = 0>
		<cfset var more = "">
		<cfset var moreinfo = structnew()>
		<cfset var str = '<dl class="#variables.type#" '>
		<cfset var activeid = "">
		<cfset var activelist = "">
		<cfif structkeyexists(variables,'id')>
			<cfset str = str & "id=""#variables.id#""">
		</cfif>
		<cfset addtostring(str & '>')>
		
		<!--- process selected so as not to select out of bounts --->
		<cfloop list="#variables.active#" index="activeid">
			<cfif activeid LTE arraylen(variables.htmlitems)>
				<cfset activelist = listappend(activelist, activeid)>
			</cfif>
		</cfloop>
		
		<cfif activelist EQ "">
			<cfset activelist = 1>
		</cfif>
		
		<cfloop from="1" to="#arraylen(variables.htmlitems)#" index="itmindx">
			<cfif structkeyexists(variables.htmlitems[itmindx],"more")>
				<cfset more = "">
				<cfif structkeyexists(variables.htmlitems[itmindx].more, "id")>
					<cfset more = more & " id=""#variables.htmlitems[itmindx].more.id#_label""">
				</cfif>
				<cfif structkeyexists(variables.htmlitems[itmindx].more, "class")>
					<cfset more = more & " class=""#variables.htmlitems[itmindx].more.class#""">
				</cfif>
			<cfelse>
				<cfset more = "">
			</cfif>
			<cfif listfind(activelist, itmindx)>
				<cfset addtostring('<dt#more# class="selected">#settitle(variables.htmlitems[itmindx].title)#</dt>')>
				<cfset addtostring('<dd#replace(more, "_label", "_content")#>')>
			<cfelse>
				<cfset addtostring('<dt#more#>#settitle(variables.htmlitems[itmindx].title)#</dt>')>
				<cfset addtostring('<dd#replace(more, "_label", "_content")# style="display:none">')>
			</cfif>
			
			<cfset addtostring(variables.htmlitems[itmindx].html)>
			<cfset addtostring('</dd>')>
		</cfloop>
		
		<cfset addtostring('</dl>')>
		
		<cfreturn arraytolist(variables.mystring,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="settype" output="false">
		<cfargument name="type">
		<cfset variables.type = arguments.type>
	</cffunction>
	
	<cffunction name="setselected"  output="false">
		<cfargument name="active">
		<cfset variables.active = arguments.active>
	</cffunction>
	
	<cffunction name="add" output="false">
		<cfargument name="title" required="true">
		<cfargument name="html" required="true">
		<cfargument name="more" required="false">
		
		<cfset arrayappend(variables.htmlitems, arguments)>
	</cffunction>
	
	<cffunction name="addtostring" access="private"  output="false">
		<cfargument name="string" required="true">
		<cfset arrayappend(variables.mystring,string)>
	</cffunction>
	
</cfcomponent>