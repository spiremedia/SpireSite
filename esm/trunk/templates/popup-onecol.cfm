<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><!-- one col -->
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />


	<title><cfoutput>#gettitle()#</cfoutput></title>
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
	<script type="text/javascript" src="/ui/js/ui.core.js"></script>
	<script type="text/javascript" src="/ui/js/ui.sortable.packed.js"></script>
	<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>
	<script type="text/javascript" src="/ui/js/esmutilities.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.autocomplete.min.js"></script>
	<script type="text/javascript" src="/ui/js/popUp.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.esmaccordionandtabs.js"></script>

</head>
<body id="popup">
	<div id="page">
		<div id="bodyNoBg">
			<div id="body-right">
				<cfoutput>
				#showFormStart()#
				<div class="content" id="rightContent">
					#renderItem('title','title')#
					<div class="group">
						<div class="inner">
							<div class="bottom">
								<div class="inner">
									<div class="panel">
										<div id="msg">
											<cfif requestObj.isformurlvarset('msg')>#requestObj.getformurlvar('msg')#</cfif>
											#session.user.getFlash()#
											&nbsp;
										</div>
										#renderItem('maincontent','accordion')#
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				#showFormEnd()#
				</cfoutput>
			</div>
			<div class="clear">&nbsp;</div>
		</div>
	</div>
	<div id="status"><img src="/ui/images/status/green.png"/></div>
	<div id="trace"></div>
	<div id="dump"></div>

</body>
</html>
