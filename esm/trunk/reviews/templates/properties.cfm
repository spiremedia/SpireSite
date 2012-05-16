<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = querynew('label,value')>
<cfset queryaddrow(lcl.options.options)>
<cfset querysetcell(lcl.options.options,'label','')>
<cfset querysetcell(lcl.options.options,'value','1')>
<cfset lcl.form.addformitem('active', 'Publish', false, 'checkbox', lcl.info.getActive(), lcl.options)>
<cfset lcl.form.addformitem('itemname', 'itemname', true, 'hidden', getDataItem('itemname'))>
<cfset lcl.form.endform()>
<cfoutput>
<table class="list">
<tbody>
<tr>
	<td class="label">Item:</td>
	<td>#getDataItem('itemname')#</td>
</tr>
<tr>
	<td class="label">Submitted:</td>
	<td>#DateFormat(lcl.info.getCreated(), 'mmm dd, yyyy')# #timeformat(lcl.info.getCreated(), 'hh:mm tt')#</td>
</tr>
<tr>
	<td class="label">Reviewed By:</td>
	<td>#lcl.info.getReviewerName()#</td>
</tr>
<tr>
	<td class="label">Rating:</td>
  <td>#lcl.info.getRating()#</td>
</tr>
<tr>
	<td class="label">Review Comments:</td>
	<td>#lcl.info.getComments()#</td>
</tr>
</tbody>
</table><br /><br />

#lcl.form.showHTML()#</cfoutput>