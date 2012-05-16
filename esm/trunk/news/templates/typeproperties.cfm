<cfset lcl.info = getDataItem('Info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:400px;">
<cfset lcl.form.addformitem('Title', 'Title<br>(used for rss feed title)', false, 'text', lcl.info.getTitle(), lcl.options)>
<cfset lcl.form.addformitem('Description', 'Description<br>(used for rss feed description)', false, 'tiny-mce', lcl.info.getDescription())>
<cfset lcl.activestuff.options = querynew('value,label')>
<cfset queryaddrow(lcl.activestuff.options)>
<cfset querysetcell(lcl.activestuff.options,'value','1')>
<cfset querysetcell(lcl.activestuff.options,'label','')>
<cfset lcl.form.addformitem('hasrssfeed', 'Has an Rss Feed', false, 'checkbox', lcl.info.gethasrssfeed(), lcl.activestuff)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<cfif lcl.info.getId() NEQ "">
	If this news type is to have an rss feed, it will be available as <br />
    <cfoutput>#securityobj.getCurrentSiteUrl()#rss/#lcl.info.getId()#/</cfoutput>
</cfif>
