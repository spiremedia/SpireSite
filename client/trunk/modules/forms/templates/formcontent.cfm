<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- template made in forms -->
<head>
    <LINK rel="stylesheet" href="/ui/css/layout.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/typo.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/nav.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/form.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/print.css" type="text/css" media="print" />
	<script src="/ui/js/jquery-1.3.2.min.js"></script>
</head>

<body class="blank">
	<div id="content" class="clearfix">

		&nbsp;<input class="contentObjectMarker" type="hidden" name="mainContent" value='#variables.formid#'>
		
		#variables.definition#

	</div><!-- end content -->

</body>
</html>

<!---><script type="text/javascript">
	//if(parent != window)
	//{
		new editBlock.ESM
		('#variables.requestObject.getVar('cmslocation')#forms/editFormWizard/?id=#variables.formid#');
	//}--->
	
	<link rel="stylesheet" href="/ui/esm/esm.css" />
	<script src="/ui/esm/jquery.esmclick.js"></script>
	<script type="text/javascript">
		jQuery.noConflict();
		jQuery(function(){ 
			jQuery('a').click(function(){return false});
			jQuery('.contentObjectMarker').parent().hover(function(){
				jQuery(this).addClass("contentObject-edit");
			},function(){
				jQuery(this).removeClass("contentObject-edit");
			});
			<cfoutput>jQuery('.contentObjectMarker').esmclick({link:'#variables.requestObject.getVar('cmslocation')#forms/editFormWizard/?id=#variables.formid#',useForm:1});</cfoutput>
		});  
	</script>



</cfoutput>