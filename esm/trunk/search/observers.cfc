<cfcomponent name="productPricingObservers"  extends="resources.abstractObserver">

	<cffunction name="ormdelete">
		<!--- 
			this observer sees all delete activity and 
			checks indexables to see if a record exists and marks it for deletion
		 --->
		<cfargument name="observed" required="true">
		<cfset var lcl = structnew()>

		<!--- <cftry> --->
			<cfset lcl.id = observed.getId()>
			<cfset lcl.indexable = createObject("component", "search.models.indexables").init(requestObj, session.user)>
			<cfset lcl.idxls = lcl.indexable.getByObjId(lcl.id)>
			<cfset lcl.s = structnew()>
			<cfset lcl.s.noobserve = 1>
			<cfloop query="lcl.idxls">
					<cfset lcl.indexable.destroy(lcl.idxls.id, lcl.s)>
			</cfloop>
		<!--- </cftry> --->

		<cfreturn arguments.observed/>
	</cffunction>
	
	<cffunction name="pages_deletepage">
		<!--- 
			this observer sees all page deletion activity
		 --->
		<cfargument name="observed" required="true">
		<cfset var lcl = structnew()>
	
		<!--- <cftry> --->
			<cfset lcl.id = observed.id>
			<cfset lcl.indexable = createObject("component", "search.models.indexables").init(requestObj, session.user)>
			<cfset lcl.idxls = lcl.indexable.getByObjId(lcl.id)>
			<cfset lcl.s = structnew()>
			<cfset lcl.s.noobserve = 1>
			
			<cfloop query="lcl.idxls">
				<cfset lcl.indexable.delete(lcl.idxls.id, lcl.s)>		
			</cfloop>
		<!--- </cftry> --->

		<cfreturn arguments.observed/>
	</cffunction>
	
	<cffunction name="pages_publish">
		<!--- 
			this observer sees all page deletion activity
		 --->
		<cfargument name="observed" required="true">
		<cfset var lcl = structnew()>

		<!--- <cftry> --->
			<cfset lcl.id = observed.id>
			<cfset lcl.indexable = createObject("component", "search.models.indexables").init(requestObj, session.user)>
			<cfset lcl.idxls = lcl.indexable.getByObjId(lcl.id)>
			<cfset lcl.s = structnew()>
			<cfset lcl.s.noobserve = 1>
			
			<cfloop query="lcl.idxls">
				<cfset lcl.indexable.clear()>
				<cfset lcl.indexable.setId(lcl.idxls.id)>
				<cfset lcl.indexable.setReindex(1)>		
				<cfif NOT lcl.indexable.save(lcl.s)>	
					<cfdump var=#lcl.indexable.getValidator().getErrors()#><cfabort>
				</cfif>	
			</cfloop>

		<!--- </cftry> --->

		<cfreturn arguments.observed/>
	</cffunction>
</cfcomponent>