<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
	
		<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(requestObj)>
				
		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"items":{"label":"Items","defaulttype":"array"},
				"startsopen":{"label":"Starts Open","default":1},
				"moduleaction":{"label":"DHTML Type","default":"accordion"}
			}
		}')>
		
		
		<cfloop from="1" to="#arraylen(variables.widgetdata.items)#" index="idx">
			<cfset variables.widgetdata.items[idx].content = parser.preprocessforwysywig(variables.widgetdata.items[idx].content)>
		</cfloop>
		
		<cfset variables.requestObj = arguments.requestObj>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="validatesave">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = getValidator()>
		<cfset var mylocal = structnew()>
		<cfset var items = variables.widgetData.items>
		
		<cfset super.validateSave()>
		
        <cfloop from="1" to="#arraylen(items)#" index="lcl.i">
        	<cfif items[lcl.i].title EQ "">
            	<cfset vdtr.addError('items', 'Item #lcl.i# has no Title. Title is required.')>
            </cfif>
            <cfif items[lcl.i].content EQ "">
            	<cfset vdtr.addError('items', 'Item #lcl.i# has no Content. Some Content is required.')>
            </cfif>
        </cfloop>
	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="setValues">
		<cfargument name="v" required="true">
		<cfset super.setValues(v)>
		<cfset variables.widgetData.items = deserializeJSON(v.items)>
	</cffunction>
		
	<cffunction name="presave">
		<cfset var mydata = structnew()>
		
		<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(requestObj)>

		<cfloop from="1" to="#arraylen(variables.widgetdata.items)#" index="idx">
			<cfset variables.widgetdata.items[idx].content = parser.postprocessfromwysywig(variables.widgetData.items[idx].content)>
		</cfloop>

	</cffunction>

</cfcomponent>
	