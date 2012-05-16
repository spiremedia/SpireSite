<cfset lcl.Taxonomyinfo = getDataItem('taxonomyiteminfo')>
<cfset lcl.Taxonomymenumdl = getDataItem('taxonomymenumdl')>
<cfset lcl.TaxonomyiTemsMdl = getDataItem('taxonomyItemsmdl')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.productcats = lcl.taxonomyItemsMdl.getByTaxonomyId('product_categories')>

<cfset lcl.form.startform()>


<cfset lcl.form.addformitem('id', '', true, 'hidden', lcl.Taxonomymenumdl.getid() )>

<cfset lcl.s = structnew()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.productCats>
<cfset lcl.options.valueskey = "id">
<cfset lcl.options.labelskey = "name">
<cfset lcl.form.addformitem('baseTaxonomyItemId', 'Base Relation', true, 'select', lcl.taxonomyMenuMdl.getBaseTaxonomyItemId() , lcl.options)>

<cfset lcl.s = structnew()>
<cfset lcl.s.sort = 'sortorder'>
<cfset lcl.options = structnew()>
<cfset lcl.options.valueskey = "id">
<cfset lcl.options.labelskey = "name">

<cfoutput query="lcl.taxonomyinfo" group="itemname">
	<cfset lcl.favlist = "">
	<cfoutput>
		<cfif lcl.taxonomyinfo.tmfid NEQ "">
			<cfset lcl.favlist = listappend(lcl.favlist, lcl.taxonomyinfo.tmftaxonomyitemid)>
		</cfif>
		<cfset lcl.options.options = lcl.taxonomyItemsMdl.getByTaxonomyId(lcl.taxonomyinfo.tmitaxonomyid)>
	</cfoutput>
	<cfset lcl.form.addformitem('#replace(lcl.taxonomyinfo.tmiid, "-","_","all")#_tmi_id', '#lcl.taxonomyinfo.itemname#', true, 'listmanager', lcl.favlist, lcl.options )>
</cfoutput>

<cfif lcl.taxonomyinfo.recordcount EQ 0>
	<p>This menu item is empty, use the "Edit Menu Item Order" button, top right to populate it.</p>	
</cfif>
<p>The Base Relation field is the category that the other items relate to. So, if the menu you wished to show was inthe beer section and you wanted to show the regions that relate to beer, you would therefore choose "beer" as your base relation.</p>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
</script>