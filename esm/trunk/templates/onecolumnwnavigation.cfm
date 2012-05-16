<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title><cfoutput>#gettitle()#</cfoutput></title>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

		<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/datepickercontrol.css";
		@import "/ui/css/jquery.autocomplete.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>

	<script type="text/javascript" src="/ui/js/jquery-1.3.min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.form.js"></script>
	<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>
	<script type="text/javascript" src="/ui/js/esmutilities.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.esmaccordionandtabs.js"></script>
    <script type="text/javascript" src="/ui/js/jquery.autocomplete.min.js"></script>

</head>
<body>
	<div id="page">
		<div id="head">
			<h1>spireESM</h1>
			<cfoutput>
			<div class="help">
				<a target="_blank" onclick="openWindow({url:'/Help/HelpItem/?m=#variables.menuObj.getModuleLabel(requestObj)#', width:800, height:600, name:'help', scrollbars:1, resizable:1});return false;">
					<img style="border:0;" src="/help/ui/help.gif" alt="Help"/>
				</a>
			</div>
			</cfoutput>

			<div id="welcome">
				<div class="inner">
					<h4>
						Welcome,
						<cfoutput>
						#session.user.getFirstName()#
						#session.user.getLastName()#.
						</cfoutput>
					</h4>
					<div class="nav">
						<ul>
							<li class="alternate">
								<a href="/Login/LoginForm/?logout">Logout</a>
							</li>
						</ul>
						<br class="clear" />
					</div>
				</div>
			</div>
			<cfoutput>#application.sites.getSitesHTML(session.user)#</cfoutput>

			<div id="status"><img src="/ui/images/status/green.png"/></div>

			<div id="top" class="nav">
				<cfoutput>#getmainmenuhtml('top')#</cfoutput>
			</div>
			<div id="top1" class="nav">
				<cfoutput>#getmainmenuhtml('addapps')#</cfoutput>
			</div>
			<div id="sub" class="nav">
				<cfoutput>#getSubMenuHtml()#</cfoutput>
			</div>
		</div>
		<div id="bodynobg">
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
	<div id="trace"></div>
	<div id="dump"></div>
	<script>
		$(function(){
			$("dl.accordion").esmAccordion();
			$("dl.panels").esmPanel();
			$("#rightContent input:visible:enabled:first").focus();
		});
	</script>
</body>
</html>