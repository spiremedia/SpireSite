<cfif isdefined("variables.data.startsopen") AND isnumeric(variables.data.startsopen)>
	<cfset lcl.startsopen = variables.data.startsopen -1>
</cfif>

<cfoutput>
<cfif arraylen(variables.data.items)>
<br class="clear" />
<div class="bclear">
	<ul id="#variables.name#_#variables.data.moduleaction#">
		<cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.cntr">
			<li <cfif isdefined("lcl.startsopen") AND lcl.startsopen EQ lcl.cntr>class="active"</cfif>>
				<!---<div class="tabnavwrap">adds a border for some reason?--->
					<a>#variables.data.items[lcl.cntr].title#</a>
				<!---</div>--->
				<div class="bclear">
					#variables.data.items[lcl.cntr].content#
				</div>
			</li>
		</cfloop>
	</ul>
	<script type="text/javascript">
		jQuery.noConflict();
		jQuery(function(){
			jQuery("###variables.name#_#variables.data.moduleaction#").accordion({
				autoHeight: false<cfif isdefined("lcl.startsopen")>, 
				active:<cfif lcl.startsopen gte 0>#lcl.startsopen#<cfelse>false</cfif></cfif>
			});
		});
	</script>
</div>
</cfif>
</cfoutput>