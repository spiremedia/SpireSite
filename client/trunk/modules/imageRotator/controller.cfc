<cfcomponent name="homeimages" extends="resources.abstractController">
	<cffunction name="default">
		<cfset var l = structnew()>
		<cfset var imageModel = this.getImageRotatorModel("imageRotator")>
		<cfset var imgs = imageModel.getImages()>
		<cfset variables.images = arraynew(1)>
		
		<cfloop query="imgs">
			<cfset l.tmp = structnew()>
			<cfset l.tmp.path = "/docs/imageRotator/#id#/#filename#">
			<cfset l.tmp.relocate = relocate>
			<cfset l.tmp.name = name>
			<cfset arrayappend(variables.images, l.tmp)>
		</cfloop>
		
		<cfset variables.start = randrange(1, imgs.recordcount)>
		<cfset variables.pageRef.addToHeader('<link rel="stylesheet"  href="/ui/css/imagerotator.css" type="text/css" />')>
		<cfset variables.pageRef.addToHeader('<script type="text/javascript" src="/ui/js/jquery.imagerotator.js"></script>')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>