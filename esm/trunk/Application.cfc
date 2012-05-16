<cfcomponent extends="resources.system" displayname="Spirev Media esm 4" hint="Spire Media Enterprise Site Manager">
		
	<cfscript>
		This.name="spireESM4";
		This.applicationtimeout = CreateTimeSpan(2, 0, 0, 0);
		This.clientmanagement = false;
		this.clientstorage = "none";
		This.sessionmanagement = true;
		This.sessiontimeout = CreateTimeSpan(0, 2, 0, 0);
		This.setclientcookies = true;
		This.setdomaincookies = true;
		This.scriptprotect = false;
		This.loginStorage = "cookie";
	</cfscript>
	
</cfcomponent>
