<div class="mimLeft">
	<div class="boxTitle">News</div>
	<div class="boxNews">
		<div class="bnCol1">
			<cfif variables.newsitems.recordcount>
				<cfoutput query="variables.newsitems">					
					<cfif variables.newsitems.currentrow lte 3><!--- show 3 --->					
						<cfif variables.newsitems.linkpageid NEQ "">
							<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newsitems.linkpageid#]}}">
						<cfelse>
							<cfset lcl.link = "/NewsAndEvents/News/#id#/">
						</cfif>
							<div class="bn-date"><a href="#lcl.link#" style="color:white;text-decoration:none;">#dateformat(itemdate, "mm.dd.yy")#</a></div>
							<div class="bn-desc">
						    	<!--- <a href="#lcl.link#">#title#</a> --->
						    	#description#
						    </div>			    
					</cfif>
				</cfoutput>			
			</cfif>
		</div><!--- << end .bnCol1 --->
		<div class="bnCol2">
			<cfif variables.newsitems.recordcount gt 3>			
			<cfoutput query="variables.newsitems">
				<cfif variables.newsitems.currentrow gt 3 and variables.newsitems.currentrow lt 6 ><!--- show only 2 more. --->
					<cfif variables.newsitems.linkpageid NEQ "">
						<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newsitems.linkpageid#]}}">
					<cfelse>
						<cfset lcl.link = "/NewsAndEvents/News/#id#/">
					</cfif>
					<div class="bn-date"><a href="#lcl.link#" style="color:white; text-decoration:none;">#dateformat(itemdate, "mm.dd.yy")#</a></div>
					<div class="bn-desc">
				    	<!--- <a href="#lcl.link#">#title#</a> --->
				    	#rereplacenocase(description,"<img .* />","","ALL")#
				    </div>
				</cfif>
			</cfoutput>
			
			</cfif>
		</div><!--- << end .bnCol2 --->
		<cfif variables.newsitems.recordcount eq 0>
			No news available.
		</cfif>
		<div class="clearfloat"></div>
		<div class="allnews">
			<div class="an-box1"><a href="/spire-news/"></a></div>
			<div class="an-fb"><a href="https://www.facebook.com/pages/SpireMedia/124962880899722"></a></div>
		    <div class="an-tw"><a href="http://twitter.com/SpireUX"></a></div>
		</div>
	</div><!--- <<<< end .boxNews --->
</div><!--- <<<<<< end .mimLeft --->