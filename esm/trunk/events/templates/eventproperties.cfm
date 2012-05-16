<cfset lcl.info = getDataItem('info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
<cfset lcl.titleoptions = structnew()>
<cfset lcl.titleoptions.style="width:300px">
<cfset lcl.form.addformitem('title', 'Title', true, 'text', lcl.info.getTitle(), lcl.titleoptions)>
<cfset lcl.form.addformitem('StartDate', 'Start Date', true, 'date',lcl.info.getStartdate())>
<cfset lcl.form.addformitem('EndDate', 'End Date', true, 'date',lcl.info.getEnddate())>
<cfset lcl.form.addformitem('StartTime', 'Start Time', false, 'text',lcl.info.getStartTime())>
<cfset lcl.form.addformitem('EndTime', 'End Time', false, 'text',lcl.info.getEndTime())>

<cfset lcl.imageOptions = structnew()>
<cfset lcl.imageOptions.options = getDataItem('assetslist') >
<cfset lcl.imageOptions.valueskey = 'id'>
<cfset lcl.imageOptions.labelskey = 'name'>
<cfset lcl.imageOptions.addBlank = 1>
<cfset lcl.imageOptions.BlankText = 'Choose an Asset for the Image Display'>

<cfset lcl.form.addformitem('imageassetid', 'Image Asset', false, 'select',lcl.info.getImageassetid(), lcl.imageOptions)>

<cfset lcl.form.addformitem('Locationname', 'Location Name', false, 'text',lcl.info.getLocationName())>
<cfset lcl.form.addformitem('Location', 'Location', false, 'textarea',lcl.info.getLocation())>
<cfset lcl.tinymceoptions2 = structnew()>
<cfset lcl.tinymceoptions2.style = "width:500px;">
<cfset lcl.form.addformitem('ShortDescription','Short Description',false,'tiny-mce',lcl.info.getShortDescription(),lcl.tinymceoptions2)>
<cfset lcl.tinymceoptions = structnew()>
<cfset lcl.tinymceoptions.style = "width:500px;height:200px;">
<cfset lcl.form.addformitem('Description', 'Description', false, 'tiny-mce',lcl.info.getDescription(), lcl.tinymceoptions)>
<cfset lcl.form.addformitem('MapLink', 'Map Link', false, 'text',lcl.info.getMaplink())>

<cfset lcl.agendaOptions = structnew()>
<cfset lcl.agendaOptions.options = getDataItem('assetslist') >
<cfset lcl.agendaOptions.valueskey = 'id'>
<cfset lcl.agendaOptions.labelskey = 'name'>
<cfset lcl.agendaOptions.addBlank = 1>
<cfset lcl.agendaOptions.BlankText = 'Choose an Asset for the Agenda Download Link'>

<cfset lcl.form.addformitem('agendaassetid', 'Agenda Asset', false, 'select',lcl.info.getAgendaassetid(), lcl.agendaOptions)>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<cfset lcl.form.addformitem('active', 'Active', false, 'checkbox', lcl.info.getActive(), lcl.activeOptions)>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<cfset lcl.form.addformitem('onhomepage', 'In Short List', false, 'checkbox', lcl.info.getOnhomepage(), lcl.activeOptions)>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<!---This was a client specific request, and is not necessary for a standard build--->
<!---<cfset lcl.form.addformitem('showmaterialsform', 'Show Materials Only', false, 'checkbox', lcl.info.getShowmaterialsform(), lcl.activeOptions)>--->

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','Yes')>

<cfset lcl.form.addformitem('showaddtlattendees', 'Show Addtl. Attendees', false, 'checkbox', lcl.info.getShowaddtlattendees(), lcl.activeOptions)>

<cfset lcl.form.endform()>
<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}	
</script>
<cfoutput>#lcl.form.showHTML()#</cfoutput>