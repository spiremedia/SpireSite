<cfset lcl.image = getDataItem("info")>
<cfset lcl.images = getDataItem("images")>
<cfset lcl.filename = lcl.image.getField("thmbfilename")>
<cfset lcl.videofilename = lcl.image.getField("videofilename")>

<cfif lcl.filename EQ "" AND lcl.videofilename EQ "">
	Upload a video and/or thumbnail(use button on top right).
<cfelse>
	<cfoutput query="lcl.images">
		<cfif lcl.image.getField(name) NEQ "">
			<cfif findnocase( 'videofilename', name) >
				<h4>Video</h4>
				#lcl.image.getField(name)#<br /><br />
			<cfelse>
				<h4>Thumbnail</h4>
				<img src="/docs/videos/#lcl.image.getField('id')#/#lcl.image.getField(name)#"/><br /><br />
			</cfif>
		</cfif>
	</cfoutput>
</cfif>