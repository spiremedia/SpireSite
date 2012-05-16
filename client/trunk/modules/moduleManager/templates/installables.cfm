<cfinclude template="nav.cfm">
<fieldset class="dblist">
		<legend>List of available modules</legend>
		<p>For a module to work, it almost always needs its esm side counterpart.<!--- For a module to be installable on the client, it must already be installed on the esm. ---></p>
		<ul>
		<cfoutput query="installables">
			<li>
				#title#
				<cfif NOT directoryexists(requestObject.getVar("machineroot") & "/modules/" & listlast(rsslink, "="))>
					<a href="/system/modules/installmodule/?moduletoinstall=#listlast(rsslink, "=")#">Intall</a>
				</cfif>
				<a href="#rsslink#">More info</a><br>
				#content#
			</li>
		</cfoutput>
		</ul>
</fieldset>