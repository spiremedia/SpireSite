<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getFormData" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT Distinct fs.formid, fs.name, 
				 (
					(SELECT TOP 1 CONVERT(varchar, submissiondate) FROM formsubmission WHERE formid = fs.formid ORDER BY submissiondate ASC)  
					+ ' - ' + 
					(SELECT TOP 1 CONVERT(varchar, submissiondate) FROM formsubmission WHERE formid = fs.formid ORDER BY submissiondate DESC)
				)  AS submissiondate 
			FROM formSubmission fs
			WHERE fs.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY fs.name
		</cfquery>

		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getFormSubmission" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT fs.submissiondate, fse.formsubmissionid, fse.formfield, fse.answer, fs.name, fs.formid
			FROM formSubmission fs, formSubmissionEntry fse
			WHERE fs.formid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND  fs.id = fse.formsubmissionid
		</cfquery>
		
		
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="setFormDataXML" output="false">
		<!--- <cfargument name="qryForm" type="query" required="true"> --->
		<cfargument name="qryFormSubmission" required="true">
		
		<cfset var stFormSubmission = structNew()>
		<cfset var MyDoc = XmlNew(false)>
		<cfset var id = "">
		<cfset var formname = "">
		
		<cfoutput query="qryFormSubmission">
			<cfset id = formid>
			<cfset formname = name>
			<cfif not structKeyExists(stFormSubmission, formsubmissionid)>
				<cfset stFormSubmission[formsubmissionid] = structNew()>
				<cfset stFormSubmission[formsubmissionid]['form'] = structNew()>
				<cfset stFormSubmission[formsubmissionid]['form']['submissiondate'] = submissiondate>
				<cfset stFormSubmission[formsubmissionid]['form']['entry'] = structNew()>
			</cfif>
			<cfif not structKeyExists(stFormSubmission[formsubmissionid]['form']['entry'], ucase(formfield))>
				<cfset stFormSubmission[formsubmissionid]['form']['entry'][ucase(formfield)] = answer>
			</cfif>
		</cfoutput>   
		
		<cfxml variable="MyDoc">
			<cfoutput>
				<formdata id="#id#" name="#formname#">
					<cfset keysToStruct = StructKeyArray(stFormSubmission)>
					<cfloop index = "i" from = "1" to = "#ArrayLen(keysToStruct)#">
						<submission date="#stFormSubmission[keysToStruct[i]]['form']['submissiondate']#">
							<cfset keysToStruct2 = StructKeyArray(stFormSubmission[keysToStruct[i]]['form']['entry'])>
							<cfloop index = "j" from = "1" to = "#ArrayLen(keysToStruct2)#">
								<field label="#xmlformat(keysToStruct2[j])#">#xmlformat(stFormSubmission[keysToStruct[i]]['form']['entry'][keysToStruct2[j]])#</field>
							</cfloop>
						</submission>
					</cfloop>
				</formdata>
			</cfoutput>
		</cfxml>
		
		<cfreturn MyDoc>
	</cffunction>
	
	<cffunction name="setFormDataXLS" output="false">
		<cfargument name="qryFormSubmission" required="true">
		
		<cfset qryNew = QueryNew("")>
		<cfset arrQueryCol = ArrayNew(1)>
		<cfset stQueryCol = structNew()>
		<cfset stFormSubmission = structNew()>
		
		<cfoutput query="qryFormSubmission" group="formfield">
			<cfset tempColName = ucase(formfield)>
			<cfset tempColName = REReplace(tempColName,"[^A-Z0-9_]","","ALL")>
			<cfset tempColName = REReplace(tempColName,"^[0-9_]","","ALL")>
			<cfset stQueryCol[tempColName] = structNew()>
		</cfoutput>  
		
		<cfoutput query="qryFormSubmission">
			<cfif not structKeyExists(stFormSubmission, formsubmissionid)>
				<cfset stFormSubmission[formsubmissionid] = structNew()>
			</cfif>
			<cfset tempColName = ucase(formfield)>
			<cfset tempColName = REReplace(tempColName,"[^A-Z0-9_]","","ALL")>
			<cfset tempColName = REReplace(tempColName,"^[0-9_]","","ALL")>
			<cfif not structKeyExists(stFormSubmission[formsubmissionid], tempColName)>
				<cfset stFormSubmission[formsubmissionid][tempColName] = REReplace(answer, "#chr(10)#"," ","ALL")>
			</cfif>
		</cfoutput>   
		
		<cfset arrQueryCol = StructKeyArray(stQueryCol)>
		<cfset qryNew = QueryNew(arrayToList(arrQueryCol))>
		
		<cfset keysToStruct = StructKeyArray(stFormSubmission)>
		<cfif ArrayLen(keysToStruct) gt 0>
			<cfset QueryAddRow(qryNew, ArrayLen(keysToStruct))>
			<cfloop index = "i" from = "1" to = "#ArrayLen(keysToStruct)#">
				<cfloop index = "j" from = "1" to = "#ArrayLen(arrQueryCol)#">
					<cfif structKeyExists(stFormSubmission[keysToStruct[i]], arrQueryCol[j])>
						<cfset QuerySetCell(qryNew, arrQueryCol[j], stFormSubmission[keysToStruct[i]][arrQueryCol[j]], i)>
					<cfelse>
						<cfset QuerySetCell(qryNew, arrQueryCol[j], '', i)>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfreturn qryNew>
	</cffunction>
	
</cfcomponent>
	