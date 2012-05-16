<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title><cfoutput>#getTitle()#</cfoutput></title>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />


	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/jquery.autocomplete.css";
		@import "/ui/css/datepickercontrol.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>
	<script type="text/javascript" src="/ui/js/jquery-1.3.min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.form.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.json-1.3.min.js"></script>
	<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>
	<script type="text/javascript" src="/ui/js/esmutilities.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.esmaccordionandtabs.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.autocomplete.min.js"></script>


	<!---
	<script type="text/javascript" src="/ui/js/prototype.js"></script>
	<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>


	<script type="text/javascript" src="/ui/js/Pre.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>

	<script type="text/javascript"> var app; Pre.meditate(function() { app = new APP.Create(); } ); </script>
	--->
</head>
<cfoutput>
<body>
	<div id="page">
		<div id="head">
			<div id="status"><img src="/ui/images/status/green.png"/></div>
			<h1>spireESM</h1>
		</div>

		<div id="bodynomenu">
			<div style="width:400px;margin-right:auto;margin-left:auto;margin-top:30px;">
				#showFormStart()#
				<div id="msg">
					<cfif requestObj.isformurlvarset('msg')>#requestObj.getformurlvar('msg')#</cfif>
					#session.user.getFlash()#
					&nbsp;
				</div>
				#renderItem('maincontent','plain')#
				#showFormEnd()#
			</div>
			<div class="clear">&nbsp;</div>
		</div>

	</div>
	<div id="trace"></div>
	<div id="dump"></div>
	<script>
		$(function(){
			$("dl.accordion").esmAccordion();
			$("dl.panels").esmPanel();
			$("input:visible:enabled:first").focus();
		});
	</script>
</body>
</cfoutput>
</html>
