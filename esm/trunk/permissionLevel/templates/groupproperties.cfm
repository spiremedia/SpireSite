<cfset lcl.securityItems = getDataItem('securityItems')>
<cfset lcl.saveditems = getDataItem('saveditems')>
<cfset lcl.item = getDataItem('item')>
<cfset lcl.form = createWidget("formcreator")>
<cfsavecontent variable="invert">
<input type="button" onclick="invertcheckbox();" value="Invert Selection"/><br /><br />
</cfsavecontent>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(invert)>
<cfset lcl.form.addformitem('Description', 'Description', false, 'textarea', lcl.item.getDescription())>
<cfloop from="1" to="#arraylen(lcl.securityitems)#" index="sitm">
	<cfif len(lcl.securityitems[sitm].securityitems)>
		<cfif structkeyexists(lcl.saveditems,lcl.securityitems[sitm].name)>
			<cfset lcl.selected = lcl.saveditems[lcl.securityitems[sitm].name].items>
		<cfelse>
			<cfset lcl.selected = "">
		</cfif>
	
		<cfset lcl.options.options = "View," & rereplace(lcl.securityitems[sitm].securityitems,"[^,a-zA-Z]","_","all")>
		
		<cfset lcl.form.addformitem('#lcl.securityitems[sitm].name#_items', 
											lcl.securityitems[sitm].label, 
											false, 
											'checkbox', 
											lcl.selected, 
											lcl.options)>
	</cfif>
</cfloop>

<cfset lcl.form.endform()>
<script>
	function invertcheckbox(){
		for(i=0;i<document.myForm.elements.length;i++)  
		{  
			var ele = document.myForm.elements[i];  
			if(ele.type == 'checkbox')  
			{  
			  ele.checked = !ele.checked;   
			}  
		} 
	}
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>

<cfoutput>#lcl.form.showHTML()#</cfoutput>