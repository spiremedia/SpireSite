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
	
	
	<script src="/ui/js/jquery.bxSlider.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="/ui/js/jquery.easing.1.3.js"></script>
	<script type="application/javascript" src="/ui/js/iscroll.js"></script>
	
	<script src="http://static.ak.fbcdn.net/connect.php/js/FB.Share" type="text/javascript"></script>
	
	<!--[if lt IE 9]>
		<link rel="stylesheet" type="text/css" href="/ui/css/styles-ie.css" />
	<![endif]-->
	<script type="application/javascript" src="/ui/js/tweetPop.js"></script>
	<cfset shareOnFacebook = "http://www.facebook.com/sharer.php?u=#variables.requestobject.getvar('siteurl')##variables.pageinfo.urlpath#&t=#urlencodedformat(variables.pageinfo.title)#">
	<cfset shareOnTwitter = "http://twitter.com/share?text=#variables.pageinfo.title#">
	<cfset shareOnDelicious = "http://del.icio.us/post?url=#variables.requestobject.getvar('siteurl')##variables.pageinfo.urlpath#&title=#urlencodedformat(variables.pageinfo.title)#">
	</cfoutput>
</head>