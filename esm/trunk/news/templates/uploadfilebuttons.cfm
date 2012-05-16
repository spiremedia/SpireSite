<cfset lcl.requestObject = getDataItem('requestObj')>
<form name="fileUpload"  method="post" action="../uploadfileaction/" enctype="multipart/form-data">
<input type="submit" value="Upload">
<cfoutput>
<input type="button" value="Close/Cancel" onclick="self.close()">
</cfoutput>