<cfcomponent name="formcontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
		
		<cfscript>
			var info = arguments.requestObject.getAllFormUrlVars();
			var formqry = queryNew("");
			var model = getModel(requestObject = arguments.requestObject);
			variables.requestObject = arguments.requestObject;
			
			if (isdefined("arguments.data.title")) variables.title = arguments.data.title;
			
			//form properties
			variables.formid = "";
			variables.definition = "";
			variables.recipient = "";
			variables.reply = "";
			variables.name = "";
			variables.validateFlag = false;
			variables.validateMessage = "";
			
			if (isdefined("data.formid") AND data.formid NEQ "")
			{
				//retrieve form info from db on formid 
				formqry = model.getForm(data.formid);	
				variables.formid = data.formid;
			}
			else if (isdefined("form.formid") AND form.formid NEQ "")
			{
				//retrieve form info from db on formid 
				formqry = model.getForm(form.formid);	
				variables.formid = form.formid;
			}
			
			if (formqry.recordcount gt 0)
			{
				//set form content
				if (trim(formqry.definition) eq "")
				{
					variables.definition = "<ul id=""palette""></ul>";
				} else {
					variables.definition = formqry.definition;
				}
				//transform form content into html
				variables.definition = model.transformFormContent( 
					formContent = variables.definition,
					formID = formqry.id
				);
				variables.recipient = formqry.recipient;	
				variables.name = formqry.name;
				variables.reply = formqry.reply;
			}
			
			// handle submitted forms 
			if (isDefined("form.formid"))
			{
				processFormSubmission(); 
			}
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfreturn createObject('component', 'modules.forms.models.forms').init(requestObject = arguments.requestObject)>
	</cffunction>
	
	<cffunction name="processFormSubmission">
	
		<cfscript>
			var stForm = structNew();
			var vdtr = getUtility('datavalidator').init(); 
			var model = getModel(requestObject = variables.requestObject);
			
			// validate form 
			model.formValidate(vdtr);
			variables.validateFlag = vdtr.passValidation();
			variables.validateMessage = vdtr.getFormattedErrors();
			if (variables.validateFlag)
			{
				//save form to database, returns a structure of form info
				stForm = model.processFormSubmission(
					formname = variables.name
				); //argumentCollection = form
				//send email
				model.sendFormSubmissionEmail( 
					recipient = variables.recipient,
					formname =variables.name,
					formsubmission = stForm
				);
			}
		</cfscript>
		
	</cffunction> 
	
	<cffunction name="spirewire">	
		<cfsavecontent variable="variables.definition">
			<cfinclude template="templates/spirewire.cfm">
		</cfsavecontent>
		<cfreturn this>
	</cffunction> 
	
	<cffunction name="contactform">
		<cfsavecontent variable="variables.definition">
			<cfinclude template="templates/contactform.cfm">
		</cfsavecontent>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="resumeUploadForm">
		
		<cfif isdefined("form.field_7")> 
			<!--- <cfdump var="#form#"><cfabort> --->
		     <cfscript>  
		           fileDetails = FileUpload("#expandpath('./uploads/')#","field_7","","MakeUnique"); 
		     </cfscript>
		<cfif fileDetails.FILEWASSAVED eq "yes">
			<cfquery name="getRecipientEmail" datasource="#variables.requestObject.getVar('dsn')#">
				select recipient from dbo.forms where id = '#form.formid#'
			</cfquery>
			<cfmail 
			 		from="timholt@spiremedia.com" 
			 		to="#getRecipientEmail.recipient#"
			 		subject="Spiresite Resume Upload from #form.field_1# #form.field_2#"
			 		mimeattach="#expandpath('./uploads/')##fileDetails.SERVERFILE#">A resume submission was received from #form.field_1# #form.field_2#.  Attached is the corresponding resume that was uploaded.  A copy of these resumes can be found in the uploads directory of the Spiresite.
			</cfmail>
		<cfelse>
			alert:  Your resume was not uploaded.  please try again.
		</cfif>
		
		     <!--- <cfdump var="#fileDetails#">  --->
		</cfif>
		
		<cfsavecontent variable="variables.definition">
			<cfinclude template="templates/resumeUploadForm.cfm">
		</cfsavecontent>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
    	
		<cfscript>
			var info = variables.requestObject.getAllFormUrlVars();
			var model = getModel(requestObject = variables.requestObject);
			var more = structnew();
			if (isDefined("info.formid"))
			{
				if(variables.validateFlag)
				{
					variables.definition = '<p class="formMessage">' & variables.reply & '</p>' & variables.definition;			
				} else {	
					variables.definition = '<p>' & variables.validateMessage & '</p>' & model.insertsubmittedvalues(variables.definition, requestObject.getallformurlvars());
				}				
			}
			
			if (isdefined("variables.title"))
			{
				more.title = variables.title;
				more.html = variables.definition;
				return more;	
			}
			return  variables.definition;
		</cfscript>
	</cffunction> 
	
	<cffunction name="showFormContentHTML">
		<cfinclude template="templates/formContent.cfm">
	</cffunction> 

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>