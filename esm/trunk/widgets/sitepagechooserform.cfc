<cfcomponent name="sitepagechooser">
	
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfargument name="name">
		<cfargument name="id">
		<cfargument name="style">
		<cfargument name="value">
		<cfargument name="addtlInfo" default="#structnew()#">
		<cfargument name="formRef">
		
		<cfset structappend(variables, arguments)>
		<cfset variables.pagesObj = createObject("component", "pages.models.pages").init(requestObj, userObj)>

		<cfif refind("^[A-Z0-9\-]{35}$", value)>
			<cfset variables.pageObj = variables.pagesObj.loadPage(value)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setInfo">
		<!--- This is required by template runner --->
	</cffunction>
	
	<cffunction name="show">
		<cfset var l = structnew()>
		<cfsavecontent variable="l.html">
			<cfoutput>
				<input type='hidden' name='#variables.name#' id='#variables.name#' value="#variables.value#">
				<cfif structkeyexists(variables, "pageObj")>
					<div id="#id#_label">Url Path : /#variables.pageObj.getUrlpath()#</div>
					<button onclick="sitenavswitch()" type="button">Change</button>
				<cfelse>
					<div id="#id#_label">Url Path : Set Now</div>
					<button onclick="sitenavswitch()" type="button">Set</button>
				</cfif>
				<script>
					function sitenavswitch(){
						jQuery.facebox(function() {
							<cfif variables.value NEQ "">
								var tgt = '/pages/SiteNavForAjax/?id=#variables.value#';
							<cfelse>
								var tgt = '/pages/SiteNavForAjax/';
							</cfif>
							jQuery.get(tgt, function(data) {
								jQuery.facebox(data);
								$("##facebox .accordion").esmAccordion();
								$("##facebox dl.accordion").click(function(evt){
									var tgt = $(evt.target);
									
									if (tgt.hasClass("empty")) {
										addStopSign();
										$(".nav", tgt.next()).load(
											"/pages/getMenuSection/",
											{
												"pageid":tgt.attr("id").substr(0,35),
												"selectedid":""
											},
											function(){removeStopSign();}
										);
										tgt.removeClass("empty")
									}
								});
								
								$("##facebox dl.accordion").click(function(evt){
									var tgt = $(evt.target);
									if (tgt.attr("tagName") == "A"){
										if (tgt.hasClass("disabled")) return false;
										$("##facebox ##accordionHolder").unbind("click");
										$("##facebox dl.accordion a").unbind("click");
										$("##facebox dl.accordion dt").unbind("click");
										
										var href = tgt.attr("href");
										
										id = href.substring(href.length, href.length - 35);
									 	$("###id#").attr("value", id);
					
										$.get("/pages/getUrlPath/?id=" + id,"", function(data){
											$("###id#_label").html("URL path : /" + data);
										});
						
										$("##facebox div.content").html("")
										$.facebox.close();
										return false; 
									}
								});
							});
						});
					}
				</script>
			</cfoutput>
			
		</cfsavecontent>
		<cfreturn l.html>
	</cffunction>
	
</cfcomponent>