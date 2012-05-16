<cfset lcl.modules = getDataItem("modules")>
<cfif requestObj.isFormUrlVarSet("n")>
	<cfset lcl.n = requestObj.getFormUrlVar("n")>
<cfelse>
	<cfset lcl.n = "">
</cfif>
<dl class="accordion">
<dt class="selected">Existing Modules</dt>
<dd>
	<div class="nav">
		<ul>
		<cfoutput query="lcl.modules">
		<li ><a <cfif name EQ lcl.n>class="selected"</cfif> href="/esm/module/?n=#name#">#name#</a></li>
		</cfoutput>
		</ul>
	</div>
</dd>
</dl>