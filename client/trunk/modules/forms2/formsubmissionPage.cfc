<cfcomponent name="news View" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset var lcl = structnew()>
		<cfset lcl.user = requestObject.getUserObject()>
		<cfset lcl.formname = listlast(requestObject.getFormUrlVar("path"),"/")>
		<cfset lcl.formpath = "modules." & replace(lcl.formname, "_", ".forms.")>

		<cfif fileexists(requestObject.getVar("machineroot") & replace(lcl.formpath,".","/","all") & ".cfc")>
			<cfif requestObject.getVar("debug", 0)>
				Not found #requestObject.getVar("machineroot") & replace(lcl.formpath,".","/","all") & ".cfc"#
			</cfif>
			what?<cfabort>
		</cfif>
		
		<cfset lcl.formObject = createObject("component",lcl.formpath).init(requestObject, requestObject.getallformurlvars())>
				
		<!--- VALIDATE --->
		<cfset vdtr = lcl.formObject.validate(clear=true)>

		<cfset requestObject.notifyObservers("form.validation.#lcl.formname#", vdtr)>

		<cfif NOT vdtr.passValidation()>
			<cfset lcl.savedata = structnew()>
			<cfset lcl.savedata.vdtr = vdtr>
			<cfset lcl.savedata.formdata = requestObject.getallformurlvars()>
			<cfset lcl.user.saveData("form submission " & lcl.formname, lcl.savedata)>
			<cfif requestObject.isFormUrlVarSet("onfail")>
				<cflocation url="#requestObject.getFormUrlVar("onfail")####lcl.formname#" addtoken="false">
			<cfelseif requestObject.isFormUrlVarSet("submitfrom")>
				<cflocation url="#requestObject.getFormUrlVar("submitfrom")####lcl.formname#" addtoken="false">
			<cfelse>
				<cfthrow message="nowhere to go?">
			</cfif>
		</cfif>
		
		<!--- SUBMIT, NOTE THAT ITEM MAY FAIL ON SUBMIT SO GET BACK VDTR AND REPEAT PROCESS --->
		<cfset vdtr = lcl.formObject.submit(vdtr)>
		
		<!--- SEND TO OBSERVERS WHO MAY ADD ERRORS --->
		<cfset vdtr = requestObject.notifyObservers("form.submission.#lcl.formname#", vdtr)>
		
		<cfif NOT vdtr.passValidation()>
			<cfset lcl.savedata = structnew()>
			<cfset lcl.savedata.vdtr = vdtr>
			<cfset lcl.savedata.formdata = requestObject.getallformurlvars()>
			<cfset lcl.user.saveData("form submission " & lcl.formname, lcl.savedata)>
			<cfif requestObject.isFormUrlVarSet("onfail")>
				<cflocation url="#requestObject.getFormUrlVar("onfail")####lcl.formname#" addtoken="false">
			<cfelseif requestObject.isFormUrlVarSet("submitfrom")>
				<cflocation url="#requestObject.getFormUrlVar("submitfrom")####lcl.formname#" addtoken="false">
			<cfelse>
				<cfthrow message="nowhere to go?">
			</cfif>
		</cfif>
		
		<!--- OK - NOW MESASAGE AND GO SOMEWHERE --->
		<cfset lcl.si = lcl.formObject.onSuccessInfo()>

		<cfset lcl.si = requestObject.notifyObservers("form.submissioncomplete.#lcl.formname#", lcl.si)>
		
		<!--- manage flash messges --->
		<cfif structkeyexists(lcl.si, 'message')>
			<cfif lcl.si.message NEQ "">
				<cfset lcl.user.setFlash(lcl.si.message)>
			</cfif>
		<cfelse>
			<cfset lcl.user.setFlash("form submitted!")>
		</cfif>
		
		<!--- manage urls --->
		<cfif requestObject.isFormUrlVarSet("onsuccessurl")>
			<cfset lcl.relocateto = requestObject.getFormUrlVar("onsuccessurl")>
		<cfelseif structkeyexists(lcl.si, 'relocate') >
			<cfset lcl.relocateto = lcl.si.relocate>
		<cfelse>
			<cfset lcl.relocateto = "/">
		</cfif>
		
		<!--- 
			deal with auto required url vars 
			- ex after account creation, want to have created url 
				var no matter where or how relocated for analytics tracking
		--->
		
		<cfif structkeyexists(lcl.si, 'appendUrlVar')>
			<cfloop collection="#lcl.si.appendUrlVar#" item="lcl.itm">
				<cfif find("?", lcl.relocateto)>
					<cfset lcl.relocateto = lcl.relocateto & "&">
				<cfelse>
					<cfset lcl.relocateto = lcl.relocateto & "?">					
				</cfif>
				<cfset lcl.relocateto = lcl.relocateto & lcl.itm & '=' & urlencodedformat(lcl.si.appendurlvar[lcl.itm])>
			</cfloop>
		</cfif>
		
		<cflocation url="#lcl.relocateto#" addtoken="false">
		
		<cfabort>
	</cffunction>
 
</cfcomponent>