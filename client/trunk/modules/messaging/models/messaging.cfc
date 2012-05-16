<cfcomponent name="messaging" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startorm("messaging")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setupMessage">
		<cfargument name="messagingname" required="true">
		<cfargument name="data" default="#structnew()#">
		
		<cfif isquery(arguments.data)>
			<cfloop list="#data.columnlist#" index="lcl.idx">
				<cfset lcl.data[lcl.idx] = arguments.data[lcl.idx][1]>
			</cfloop>
		<cfelse>
			<cfset lcl.data = arguments.data>
		</cfif>
		
		<cfset lcl.messageinfo = this.getByName(arguments.messagingname)>
        
		<cfif lcl.messageinfo.recordcount EQ 0>
			<cfthrow message="no messaging found for this id (#arguments.messagingname#)">
		</cfif>
		
		<cfset lcl.subject = lcl.messageinfo.subject>
		<cfset lcl.message = lcl.messageinfo.textcontent>

		<cfloop collection="#lcl.data#" item="lcl.itm">
			<cfset lcl.subject = replacenocase(lcl.subject, "[#lcl.itm#]", lcl.data[lcl.itm], "all")>
			<cfset lcl.message = replacenocase(lcl.message, "[#lcl.itm#]", lcl.data[lcl.itm], "all")>
		</cfloop>
		
		<cfset variables.msg = lcl>
		
	</cffunction>
	
	<cffunction name="getMessage">
		<cfreturn variables.msg>
	</cffunction>
	
	<cffunction name="sendMessage">
		<cfargument name="to" required="true">
		<cfargument name="messagingname" required="true">
		<cfargument name="data" default="#structnew()#">
		
		<cfset var lcl = structnew()>
		
		<cfset setupMessage(messagingname, data)>
				
		<cfset lcl.emailobj = createObject("component", "resources.email").init(requestObject)>
		<cfset lcl.emailobj.setRecipient(arguments.to)>
		<cfset lcl.emailobj.setSubject(variables.msg.subject)>
		<cfset lcl.emailobj.setBody(variables.msg.message)>
		<cfset lcl.emailobj.sendMessage()>
		
	</cffunction>
	
</cfcomponent>
