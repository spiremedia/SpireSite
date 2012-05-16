<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
	<title>#getField("title")#</title>
	<script src="/ui/js/jquery-1.2.6.pack.js"></script>
	
</head>
<html>
<body>
	<div id="wrap" style="width:950px">
		<div id="contents" style="float:left;width:700px;padding:10px;">
			#showContentObject('contents', 'blankEditable', '')#
		</div>
		<br style="clear:both;">
	</div>
</body>
</html>
</cfoutput>