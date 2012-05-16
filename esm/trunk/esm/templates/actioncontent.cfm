<cfset lcl.mdl = getDataItem("modulemdl")>
<cfset lcl.name = requestObj.getFormUrlVar("n")>


<cfset lcl.modeform = createWidget("formcreator")>
<cfset lcl.modeform.startForm()>
<cfset lcl.modeform.addformitem('n', '', true, 'hidden', lcl.name)>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = "Choose,standardajax,adhockajax">
<cfset lcl.options.onchange = "layoutMode(this.value)">
<cfset lcl.config.addblank = 1>
<cfset lcl.config.blanklabel = "hi">
<cfset lcl.modeform.addformitem('mode', 'Choose a mode', true, 'select', "",lcl.options)>
<cfset lcl.modeform.endForm()>

<cfset lcl.ajaxform = createWidget("formcreator")>
<cfset lcl.ajaxform.startForm()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = "">
<cfset lcl.models = lcl.mdl.getModels()>
<cfloop query="lcl.models">
	<cfset lcl.options.options = listappend(lcl.options.options, "save " & lcl.models.filename)>
	<cfset lcl.options.options = listappend(lcl.options.options, "delete " & lcl.models.filename)>
</cfloop>
<cfset lcl.ajaxform.addformitem('saactionname', 'Standard Action', true, 'select', "",lcl.options)>
<cfset lcl.ajaxform.endForm()>

<cfset lcl.ajahnameform = createWidget("formcreator")>
<cfset lcl.ajahnameform.startForm()>
<cfset lcl.options = structnew()>
<cfset lcl.ajahnameform.addformitem('ahactionname', 'Action Name', true, 'text', "")>

<cfset lcl.models = lcl.mdl.getModels()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = valuelist(lcl.models.filename)>

<cfset lcl.ajahnameform.addformitem('modelstouse', 'Models To use', true, 'listmanager', "", lcl.options)>

<cfset lcl.ajahnameform.endForm()>

<cfoutput>
	#lcl.modeform.showHTML()#

	<div id="standardajaxmode" style="display:none">
		#lcl.ajaxform.showHTML()#
	</div>
	<div id="adhockajaxmode" style="display:none">
		#lcl.ajahnameform.showHTML()#
	</div>
	<script>
		function layoutMode(mode){
			$("##standardajaxmode").css("display","none")
			$("##adhockajaxmode").css("display","none")
			$("##displaymode").css("display","none")
			var itm = $("##" + mode + "mode");
			if (itm.length > 0)  itm.css("display", "block")
		}
	</script>
</cfoutput>
<input type="submit" value="go">