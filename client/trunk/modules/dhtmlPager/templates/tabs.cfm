<!---<cfif isdefined("variables.data.startsopen") AND isnumeric(variables.data.startsopen)>
	<cfset lcl.startsopen = arraylen(variables.data.items) - variables.data.startsopen>
</cfif>--->

<cfoutput>
<cfif arraylen(variables.data.items)>
	<div id="tabs_#variables.name#">
		<ul>
			<cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.i">
				<li><a href="##tabs_#variables.name#-#lcl.i#"><span>#rereplacenocase(variables.data.items[lcl.i].title, "&lt;br[/]?&gt;", "<br/>","all")#</span></a></li>
			</cfloop>
		</ul>
		<div class="ui-tabs-panel-top">&nbsp;</div>
		<cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.i">
			<div id="tabs_#variables.name#-#lcl.i#" class="bclear">
				#variables.data.items[lcl.i].content#
			</div>
		</cfloop>
		<div class="tabfoot"></div>
	</div>
	<script type="text/javascript">
		jQuery.noConflict();
		jQuery(function(){
			jQuery("##tabs_#variables.name#").tabs({
				tabdirection:'lr'
				<cfif isdefined("lcl.startsopen") AND isnumeric(lcl.startsopen)>,selected:#lcl.startsopen#</cfif>
			});
			jQuery("##tabs_#variables.name# ul.ui-tabs-nav a br").parent().parent().addClass("ret");

		});
	</script>
</cfif>
</cfoutput>