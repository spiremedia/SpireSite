<cfif arraylen(variables.images)>
	<cfoutput>
	<div class="imageHolder">
		<img src="#variables.images[variables.start].path#" alt="#variables.images[variables.start].name#" />
	</div>
	<div id="rotatorbg"></div>
	<div id="controls">
		<ul><cfloop from="0" to="#arraylen(variables.images)-1#" index="lcl.idx">
			<li><a rel="#lcl.idx#" href=""><img src="/ui/images/rotatorbtn#iif(lcl.idx EQ variables.start, DE("_on"), DE(""))#.png" alt="Previous Button"/></a></li>
			</cfloop>
		</ul>
	</div>	
	<script type="text/javascript">
		jQuery.noConflict();  
		jQuery(document).ready(function(){  
			jQuery(".imagerotator_default .pocntntwrap").imagerotator(#serializejson(variables.images)#);
		});	 
	</script>
	</cfoutput>
</cfif>