<div class="mimLeft">
	<div class="boxTitle">News</div>
	<div class="boxNews">
		
			<cfif variables.newsitems.recordcount>
				<cfoutput query="variables.newsitems">					
					<cfif variables.newsitems.currentrow lte 4><!--- show 4 --->					
						<cfif variables.newsitems.linkpageid NEQ "">
							<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newsitems.linkpageid#]}}">
						<cfelse>
							<cfset lcl.link = "/NewsAndEvents/News/#id#/">
						</cfif>
						<div style="border-bottom:1px solid white; float:left; padding-bottom:10px; padding-top:10px;">
							<div class="bn-date" style="margin-top:5px;"><a href="#lcl.link#" style="color:white;text-decoration:none;">#trim(dateformat(itemdate, "mm.dd.yy"))#</a></div>
							<div class="bn-desc" style="width:450px; float:left; margin-left:10px;">#trim(description)#</div>			    
						</div>
						<div class="clearfloat"></div>
					</cfif>
				</cfoutput>			
			</cfif>
		
		<!---<div class="bnCol2">
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
		</div> << end .bnCol2 --->
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