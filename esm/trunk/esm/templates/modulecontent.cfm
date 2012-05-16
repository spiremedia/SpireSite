<cfset lcl.mdl = getDataItem("modulemdl")>
<cfset lcl.name = requestObj.getFormUrlVar("n")>
<cfoutput>
	<button onclick="refocuslinkinnav()">hi</button>
<fieldset>
	<legend>Code Generation</legend>
	
	Editable Stubs. <a href="/esm/editables/?n=#lcl.name#">Go</a>.</p>
</fieldset>

<fieldset>
	<legend>Models</legend>
	Current Models:<br>
		<cfset lcl.models = lcl.mdl.getModels()>
		<cfif lcl.models.recordcount>
			<ul>
			<cfloop query="lcl.models">
				<li>#filename#</li>
			</cfloop>
			</ul>
			<a href="/esm/model/?n=#lcl.name#">Add Model</a>.</p>
		<cfelse>
			<p>No Models yet. <a href="/esm/model/?n=#lcl.name#">Add Model</a>.</p>
		</cfif>
</fieldset>

<fieldset>
	<legend>Actions (pages)</legend>
	<cfset lcl.methods = lcl.mdl.getMethods()>
	<cfif lcl.methods.recordcount>
		<ul>
		<cfloop query="lcl.methods">
			<li>#name# <cfif isajax>(Ajax)</cfif></li>
		</cfloop>
		</ul>
		<a href="/esm/action/?n=#lcl.name#">Add Action</a>, <a href="/esm/view/?n=#lcl.name#">Add View</a>.
	<cfelse>
		<p>No Actions yet. <a href="/esm/ajaxaction/?n=#lcl.name#">Add Ajax Action</a>, <a href="/esm/view/?n=#lcl.name#">Add View</a>.</p>
	</cfif>
</fieldset>

<fieldset>
	<legend>Templates</legend>
	<cfset lcl.models = lcl.mdl.getTemplates()>
	<cfif lcl.models.recordcount>
		<ul>
		<cfloop query="lcl.models">
			<li>#filename#<cfif NOT isinxml> (Not in XML)</cfif></li>
		</cfloop>
		</ul>
		<a href="/esm/template/?n=#lcl.name#">Add Template File</a>.
	<cfelse>
		<p>No Templates yet. <a href="/esm/template/?n=#lcl.name#">Add Template File</a>.</p>
	</cfif>
</fieldset>

<fieldset>
	<legend>Unittests</legend>
	<cfset lcl.models = lcl.mdl.getUnitTests()>
	<cfif lcl.models.recordcount>
		<ul>
		<cfloop query="lcl.models">
			<li>#filename#</li>
		</cfloop>
		</ul>
		<a href="/esm/test/?n=#lcl.name#">Add Test File</a>.
	<cfelse>
		<p>No Tests yet. <a href="/esm/test/?n=#lcl.name#">Add Test File</a>.</p>
	</cfif>
</fieldset>
</cfoutput>

