<cfinclude template="nav.cfm">
<cfset lcl.name = requestObject.getFormUrlVar("n")>
<cfoutput>

<fieldset>
	<legend>Models</legend>
	Current Models:<br>
		<cfset lcl.models = mdule.getModels()>
		
		<cfif lcl.models.recordcount>
			<ul>
			<cfloop query="lcl.models">
				<li>#filename#</li>
			</cfloop>
			</ul>
			<a href="../modelform/?n=#lcl.name#">Add Model</a>.</p>
		<cfelse>
			<p>No Models yet. <a href="/system/modules/modelform/?n=#lcl.name#">Add Model</a>.</p>
		</cfif>
</fieldset>

<fieldset>
	<legend>Module Actions/Templates</legend>
	Templates
	<cfset lcl.models = mdule.getTemplates()>
	<cfif lcl.models.recordcount>
		<ul>
		<cfloop query="lcl.models">
			<li>#filename#<!--- <cfif NOT isinxml> (Not in XML)</cfif> ---></li>
		</cfloop>
		</ul>
		<a href="/system/modules/templateForm/?n=#lcl.name#">Add Template File</a>.
	<cfelse>
		<p>No Templates yet. <a href="/system/modules/templateForm/?n=#lcl.name#">Add Template File</a>.</p>
	</cfif>
</fieldset>
<fieldset>
	<legend>Module Subcontrollers</legend>
	<cfset lcl.models = mdule.getSubControllers()>

	<cfif lcl.models.recordcount>
		<ul>
		<cfloop query="lcl.models">
			<li>#filename#<!--- <cfif NOT isinxml> (Not in XML)</cfif> ---></li>
		</cfloop>
		</ul>
		<a href="/system/modules/subctrlForm/?n=#lcl.name#">Add SubController</a>.
	<cfelse>
		<p>No Subcontrollers yet. <a href="/system/modules/subctrlForm/?n=#lcl.name#">Add SubController</a>.</p>
	</cfif>
</fieldset>

<fieldset>
	<legend>Unittests</legend>
	<cfset lcl.models = mdule.getUnitTests()>
	
	<cfif lcl.models.recordcount>
		<ul>
		<cfloop query="lcl.models">
			<li>#filename#</li>
		</cfloop>
		</ul>
		
	<cfelse>
		<p>No Tests yet.</p>
	</cfif>
	<form action="/system/modules/testFileForm/"  style="display:inline;" method="post">
	Add Test File 
	<input type="hidden" name="n" value="#lcl.name#">
	<input type="text" name="testfilename" style="width:70px;" value="ends w test">
	<input type="text" name="testfilemethods" style="width:350px;" value="comma seperated list of test methods">
	<input type="submit" value="Add">
	</form>

</fieldset>
</cfoutput>

