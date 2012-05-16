<cfcomponent name="tables">
	
	<cfset variables.stuff.columns = arrayNew(1)>
	<cfset variables.stuff.tableattributes = structnew()>
	<cfset variables.stuff.nrmessage = "No records were found">
	<cfset variables.stuff.formats = structnew()>
	<cfset variables.a = arraynew(1)>
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>

		<cfreturn this>
	</cffunction>
    
	<cffunction name="getColumns">
		<!--- {title, field, [format][align]} --->
		<cfreturn variables.stuff.columns>
	</cffunction>
	
	<cffunction name="setColumns">
		<cfargument name="cols" required="true">
		<cfset variables.stuff.columns = arguments.cols>
	</cffunction>
	
	<cffunction name="setName">
		<cfargument name="name" required="true">
		<cfset variables.name = arguments.name>
	</cffunction>
	
	<cffunction name="setHeader">
		<cfargument name="header" required="true">
		<cfset variables.stuff.header = arguments.header>
	</cffunction>
	
	
	<cffunction name="setNoRecordsMessage">
		<cfargument name="nrmessage" required="true">
		<cfset variables.stuff.nrmessage = arguments.nrmessage>
	</cffunction>
    	
   	<cffunction name="setTableAttributes">
   		<cfargument name="tableattributes" required="true">
		<cfset variables.stuff.tableattributes = arguments.tableattributes>
   	</cffunction>
   	
   	<cffunction name="getTableAttributes">
		<cfreturn variables.stuff.tableattributes>
   	</cffunction>
	
	<cffunction name="setFormats">
   		<cfargument name="formats" required="true">
		<cfset variables.stuff.formats = arguments.formats>
   	</cffunction>
   	
   	<cffunction name="getFormats">
		<cfreturn variables.stuff.formats>
   	</cffunction>
   	
   	<cffunction name="getData">
		<cfreturn variables.stuff.data>
   	</cffunction>
	
	<cffunction name="setData">
		<cfargument name="data" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfif isstruct(data)>
			<cfset lcl.cols = "">
			
			<cfif listlen(structkeylist(data))>
				<cfset lcl.cols = structkeylist(data[listfirst(structkeylist(data))])>
			</cfif>
			
			<cfset lcl.qry = querynew(lcl.cols)>
			
			<cfloop collection="#data#" item="lcl.itm">
				<cfset queryaddrow(lcl.qry)>
				<cfloop collection="#data[lcl.itm]#" item="lcl.ditm">
					<cfset querysetcell(lcl.qry, lcl.ditm, data[lcl.itm][lcl.ditm])>
				</cfloop>
			</cfloop>
			<cfset variables.stuff.data = lcl.qry>
		<cfelse>
			<cfset variables.stuff.data = data>
		</cfif>

	</cffunction>

	<cffunction name="makeTable">
		<cfset var itm = "">
		
		<cfset requestObject.notifyObservers("table.#variables.name#", this)>

		<cfif structkeyexists(variables.stuff, "header")>
			<cfset addstr(variables.stuff.header)>
		</cfif>

		<cfif variables.stuff.data.recordcount EQ 0>
			<cfset addstr("<p>")>
			<cfset addstr(variables.stuff.nrmessage)>
			<cfset addstr("<p>")>
			<cfreturn>
		</cfif>
		
		<!--- tabletag --->
		<cfset addstr("<table ")>
		<cfloop collection="#variables.stuff.tableattributes#" item="itm">
			<cfset addstr(" #itm#=""#variables.stuff.tableattributes[itm]#""")>
		</cfloop>
		<cfset addstr(">")>
		
		<!--- headers --->
		<cfset addstr("<tr>")>
		<cfloop from="1" to="#arraylen(variables.stuff.columns)#" index="i">
			<cfset addstr("<th>#variables.stuff.columns[i]['title']#</th>")>
		</cfloop>
		<cfset addstr("</tr>")>
		
		<!--- rows --->
		<cfloop query="variables.stuff.data">
			<cfset addstr("<tr")>
			<cfif variables.stuff.data.currentrow mod 2 EQ 0>
				<cfset addstr(" class=""alt""")>
			</cfif>
			<cfset addstr(">")>
			<cfloop from="1" to="#arraylen(variables.stuff.columns)#" index="lcl.i">
				<cfset addstr("<td")>
				<cfif structkeyexists(variables.stuff.columns[lcl.i],"attributes")>
					<cfloop collection="#variables.stuff.columns[lcl.i].attributes#" item="itm">
						<cfset addstr(" #itm#=""#variables.stuff.columns[lcl.i].attributes[itm]#""")>
					</cfloop>
				</cfif>
				<cfset addstr(">")>
				<cfif structkeyexists(variables.stuff.columns[lcl.i],"format")>
					<cfset lcl.frmtstr = variables.stuff.columns[lcl.i].format>
					<cfloop list="#variables.stuff.data.columnlist#" index="lcl.listitm">
						<cfset lcl.frmtstr = replacenocase(lcl.frmtstr, "[#lcl.listitm#]",formatField(lcl.listitm, variables.stuff.data[lcl.listitm][variables.stuff.data.currentrow]) ,"all")> 
					</cfloop>
					<cfset addstr(lcl.frmtstr)>
				<cfelse>
					<cfset addstr(formatField(variables.stuff.columns[lcl.i]['field'], variables.stuff.data[variables.stuff.columns[lcl.i]['field']][currentrow]))>
				</cfif>
				<cfset addstr("</td>")>
			</cfloop>
			<cfset addstr("</tr>")>
		</cfloop>
		
		<!--- bottom tag --->
		<cfset addstr("</table>")>
		
	</cffunction>

	<cffunction name="showHtml">
		<cfset maketable()>
		<cfreturn arraytolist(variables.a, "#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="addstr" access="private">
		<cfargument name="s" required="true">
		<cfset arrayappend(variables.a, s)>
	</cffunction>

	<cffunction name="formatField" access="private">
		<cfargument name="fieldname" required="true">
		<cfargument name="fieldvalue" required="true">
		<cfset var lcl = structnew()>
		<cfset lcl.startval = arguments.fieldvalue>
		
		<cfif structkeyexists(variables.stuff.formats, fieldname)>
			<cfloop list="#variables.stuff.formats[fieldname]#" index="lcl.format">

				<cfswitch expression="#lcl.format#">	
					<cfcase value="money">
						<cfset fieldvalue = numberformat(fieldvalue, requestObject.getVar("moneyformat", "$999999999.__"))>
					</cfcase>
					
					<cfcase value="date">
						<cfset fieldvalue = dateformat(fieldvalue, requestObject.getVar("dateformat", "mm/dd/yyyy"))>
					</cfcase>
					
					<cfcase value="datetime">
						<cfset fieldvalue = dateformat(fieldvalue, requestObject.getVar("datetimedateformat", "mm/dd/yyyy") & timeformat(fieldvalue, requestObject.getVar("datetimetimeformat", " hh:mm")))>
					</cfcase>
					
					<cfcase value="wrapdiv">
						<cfset fieldvalue = "<div>#fieldvalue#</div>">
					</cfcase>
					
					<cfcase value="wrapspan">
						<cfset fieldvalue = "<span>#fieldvalue#</span>">
					</cfcase>
					
					<cfcase value="blankonzero">
						<cfif lcl.startval EQ 0>
							<cfset fieldvalue = "">
						</cfif>
					</cfcase>
				</cfswitch>
				
			</cfloop>
		</cfif>
		
		<cfreturn fieldvalue>	
	</cffunction>
</cfcomponent>