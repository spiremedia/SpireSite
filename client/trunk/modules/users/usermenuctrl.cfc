<cfcomponent name="userflash" extends="resources.abstractsubcontroller">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var s = structnew()>
		<cfset s.title = "My Account">
		<cfsavecontent variable="s.html">
			<ul class="leftmenu">
				<li><a href="/user/edit">Edit Account Information</a></li>
				<li><a href="/user/editpassword">Edit Password</a></li>
			</ul>
		</cfsavecontent>	
		<cfreturn s>
	</cffunction>

</cfcomponent>