<cfset lcl.menusModel = getDataItem('menusModel')>
<cfset lcl.widgetModel = getDataItem('editableModel')>


<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:400px">
<cfset lcl.form.addformitem('title', 'Title', false, 'text', lcl.widgetModel.getTitle(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.menus = lcl.menusModel.getAll()>
<cfsilent>
	<cfset lcl.options.options = querynew("label,value")>
	<cfloop query="lcl.menus">
		<cfset queryaddrow(lcl.options.options)>
		<cfset querysetcell(lcl.options.options, "label", lcl.menus.name)>
	    <cfset querysetcell(lcl.options.options, "value", lcl.menus.id)>
	</cfloop>
</cfsilent>

<cfset lcl.options.labelskey = 'label'>
<cfset lcl.options.valueskey = 'value'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Menu">
<cfset lcl.form.addformitem('menuid', 'Menu', true, 'select', lcl.widgetModel.getMenuId(), lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getId())>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.addformitem('moduleaction', '', false, 'hidden', "menu")>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 325);
</script>
