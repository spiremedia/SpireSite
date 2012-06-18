<head>
	<cfoutput>
	<title>#variables.pageinfo.title#</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta name="description" content="#variables.pageinfo.description#" />
	<meta name="keywords" content="#variables.pageinfo.keywords#" />
	
	<link rel="stylesheet" href="/ui/css/styles.css" type="text/css" media="screen" />
	 <!---<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script> --->
	
	<script type="text/javascript" src="/ui/js/jquery-1.6.4.js"></script><!--- this works with the accordion, google doesn't' --->
	<script type='text/javascript' src="/ui/js/jquery.hoverIntent.minified.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.dropkick-1.0.0.js" charset="utf-8"></script>	
	<cfif isDefined("variables.pageinfo.urlpath") and variables.pageinfo.urlpath neq "spire-news/">
		<script type="text/javascript" src="/ui/js/jquery.bxSlider.min.js"></script><!--- this is needed.  But.  It's incompatible with the Spire News page. TH --->
	</cfif>	
	<!--[if lt IE 9]>
		<link rel="stylesheet" type="text/css" href="/ui/css/styles-ie.css" />
	<![endif]-->
	</cfoutput>
</head>