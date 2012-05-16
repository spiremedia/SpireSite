<cfset lcl.mdl = getDataItem("modulemdl")>
<cfset lcl.name = requestObj.getFormUrlVar("n")>

<cfset lcl.startform = createWidget("formcreator")>
<cfset lcl.startform.startForm()>
<cfset lcl.startform.addformitem('label', 'Label', true, 'text', "")>
<cfset lcl.options = structnew()>
<cfset lcl.options.onchange = "showModuleForm()">
<cfset lcl.options.options = "Choose,2col w/ nav,1col w/ nav,1col popup">
<cfset lcl.startform.addformitem('template', 'Choose a layout', true, 'select', "", lcl.options)>

<cfset lcl.startform.addformitem('n', 'n', true, 'hidden', requestObj.getFormUrlVar("n"))>
<cfset lcl.startform.endForm()>

<cfset lcl.editform = createWidget("formcreator")>
<cfset lcl.editform.startForm()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:600px;height:100px;">
<cfset lcl.editform.addformitem('maction', 'Action XML', true, 'textarea', "", lcl.options)>

<cfset lcl.editform.endForm()>

<cfoutput>
	#lcl.startform.showHTML()#
	<div id="editForm">
		#lcl.editform.showHTML()#
	</div>
</cfoutput>

<script>
	function showModuleForm(){
		var opt = $("#template").attr("value");
		if (opt == "Choose"){
			$("#maction").attr("value", "");	
			return;
		}
	
		var label = $("#label").attr("value");
		if (label == ""){
			$("#msg").html("Label required.");
			return;
		}
		
		var layouts = {
				"2col w/ nav":"<action name=\"{label}\" isSecurityItem=\"0\" onMenu=\"0\" template=\"twocolumnwnavigation\" formsubmit=\"{labelrl}action\">\n" + 
								"\t<template name=\"browseContent\" title=\"Browse\" file=\"browse.cfm\"/>\n" +
								"\t<template name=\"title\" title=\"label\" file=\"{labelrl}label.cfm\"/>\n" + 
						        "\t<template name=\"title\" title=\"btn\" file=\"{labelrl}button.cfm\"/>\n" +
						        "\t<template name=\"mainContent\" title=\"{label}\" file=\"{labelrl}contents.cfm\"/>\n" +
						   "</action>",
		   		"1col w/ nav":'<action name="{label}" isSecurityItem=\"0\" onMenu=\"0\" template="onecolumnwnavigation">'+"\n\t"+
								'<template name="browseContent" title="Browse" file="browse.cfm"/>'+"\n\t"+
								'<template name="title" title="{label} Title" file="{labelrl}title.cfm"/>'+"\n\t"+
								'<template name="mainContent" title="{label} Contents" file="{labelrl}contents.cfm"/>'+"\n"+
							'</action>',
				"1col popup":'<action name="{label}" isSecurityItem=\"0\" onMenu="0" template="popup-onecol" >'+"\n\t"+
								'<template name="title" title="{label} Title" file="{labelr}label.cfm"/>'+"\n\t"+
								'<template name="title" title="{label} Btns" file="{labelrl}buttons.cfm"/>'+"\n\t"+
						        '<template name="mainContent" title="{label} Contents" file="{labelrl}contents.cfm"/>'+"\n"+
							'</action>'
				
		};
		var s = layouts[opt];

		labelr = label.toLowerCase().split(" ");

		if (labelr.length > 1){
			for(var i = 1; i < labelr.length; i++){
				labelr[i] = labelr[i].substring(0,1).toUpperCase() + labelr[i].substring(1);
			}
		}
		
		labelu = label.toLowerCase().split(" ");
	
		for(var i = 0; i < labelu.length; i++){
			labelu[i] = labelu[i].substring(0,1).toUpperCase() + labelu[i].substring(1);
		}
			
		labelr = labelr.join("");
		labelu = labelu.join(" ");
		s = s.replace(/\{label\}/g, labelu);
		s = s.replace(/\{labelr\}/g, labelr);
		s = s.replace(/\{labelrl\}/g, labelr.toLowerCase());
		
		$("#maction").attr("value", s);
	}

</script>
<input type="submit" value="go">