<cfset lcl.image = getDataItem("image")>
<cfset lcl.images = getDataItem("images")>
<cfset lcl.filename = lcl.image.getField("filename")>

<cfif lcl.filename EQ "">
	Upload an Image(use button on top right).
<cfelse>
	<cfoutput query="lcl.images">
		<img src="/docs/imageRotator/#lcl.image.getField('id')#/#lcl.filename#"/>
	</cfoutput>
</cfif>