<cfoutput>
<!--- <div class="newsList">
<cfif variables.newsItem.hasRssFeed EQ 1>
	<p class="newsFeed">
		<a class="rssiconlink" href="/rss/news/#variables.newsItem.id#/">#variables.newsItem.title# RSS Feed</a>
	</p>
</cfif>
<cfif variables.newslist.recordcount>
	<ul>
	<cfloop query="variables.newslist">
		<li>
			<p class="newsTitle">
			<cfif variables.newslist.linkpageid NEQ "">
				<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newslist.linkpageid#]}}">
			<cfelse>
				<cfset lcl.link = "/NewsAndEvents/News/#id#/">
			</cfif>
			<a href="#lcl.link#">#getUtility('string').APDateFormat(itemdate)#:</a> #title#
			<cfif variables.newslist.assetid NEQ "">
				<a href="{{asset[#variables.newslist.assetid#]}}" target="_blank">(MP3)</a>
			</cfif>
			</p>
			<div>#description#</div>
		</li>
	</cfloop>
	</ul>
	#variables.pager.showPageLinks()#
	<br class="clear"/>
<cfelse>
	<p>There are currently no items to show.</p>
</cfif>
</div> --->

<cfset newsYears = "">
<cfset thisyear = datepart("yyyy", now())>
<cfloop from="0" to="4" index="i">	
	<cfset newsYears = ListAppend(newsYears,(thisyear-i))>
</cfloop>



					<div class="mn-title">Spire News</div>
					<div class="mn-years">
					<cfloop from="1" to="5" index="d">
						<div class="mnyBox <cfif d eq 1>active</cfif>" id="year#d#"><a class="xtrig" href="###d#" rel="coda-slider-1">#listGetAt(newsYears,d)#</a></div>
					</cfloop>
						<div class="clearfloat"></div>
					</div>
					
					<div id="NCC">
						<div class="coda-slider-wrapper">
							<div class="coda-slider" id="coda-slider-1">
							
							
								<cfloop from="1" to="#listlen(newsYears)#" index="i">
									<cfquery name="thisYearNews" dbtype="query">
									 	select * from variables.newslist 
									 	where itemyear = #listGetAt(newsYears,i)# 
									 </cfquery>
								
								 
									<cfif thisYearNews.recordcount gt 0>			
											<cfset col1count = 0>
											<cfset col2count = 0>
											<cfset col1Count = int(variables.thisYearNews.recordcount / 2)>
											<cfset col2Count = col1Count>
											<cfif variables.thisYearNews.recordcount mod 2 eq 1>		
												<cfset col1Count = col1Count + 1>
											</cfif>											
											<div class="panel" id="newsContent">
												<div class="panel-wrapper">										
													<div class="ncLeft">
														<cfif col1count neq 0>
															<cfloop query="thisYearNews">
																<cfif thisYearNews.currentRow lte col1Count>
																	<cfif variables.newslist.linkpageid NEQ "">
																		<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newslist.linkpageid#]}}">
																	<cfelse>
																		<cfset lcl.link = "/NewsAndEvents/News/#thisYearNews.id#/">
																	</cfif>																	
																	<div class="newsBox">
																		<div class="nb-date"><a href="#lcl.link#" style="color:white;">#DateFormat(itemdate, "mm.dd.yy")#</a></div>
																		<div class="nb-title">#title#</div>
																		<div class="nb-desc">#description#</div>
																	</div>																
																</cfif>
															</cfloop>															
														<cfelse>
															<div class="newsBox">
																<div class="nb-date">&nbsp;</div>
																<div class="nb-title">&nbsp;</div>
																<div class="nb-desc">No News Items Found For This Year.</div>
															</div>
														</cfif>
													</div>
													<div class="ncRight">
														<cfif col2count neq 0>
															<cfloop query="thisYearNews">
																<cfif thisYearNews.currentRow gt col1Count>
																	<cfif variables.newslist.linkpageid NEQ "">
																		<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newslist.linkpageid#]}}">
																	<cfelse>
																		<cfset lcl.link = "/NewsAndEvents/News/#thisYearNews.id#/">
																	</cfif>
																	<div class="newsBox">
																		<div class="nb-date"><a href="#lcl.link#" style="color:white;">#DateFormat(itemdate, "mm.dd.yy")#</a></div>
																		<div class="nb-title">#title#</div>
																		<div class="nb-desc">#description#</div>
																	</div>																
																</cfif>
															</cfloop>
														<cfelse>
															<div class="newsBox">
																<div class="nb-date">&nbsp;</div>
																<div class="nb-title">&nbsp;</div>
																<div class="nb-desc">&nbsp;</div>
															</div>
														</cfif>
													</div>
													<div class="clearfloat"></div>
												</div>
											</div><!--- << end oneyear ---> 	
									<cfelse>
										<div class="panel" id="newsContent">
											<div class="panel-wrapper">										
													<div class="ncLeft">
														<div class="newsBox">
															<div class="nb-date">&nbsp;</div>
															<div class="nb-title">&nbsp;</div>
															<div class="nb-desc">No News Items Found For This Year.</div>
														</div>
													</div>
													<div class="ncRight">
														<div class="newsBox">
															<div class="nb-date">&nbsp;</div>
															<div class="nb-title">&nbsp;</div>
															<div class="nb-desc">&nbsp;</div>
														</div>
													</div>
													<div class="clearfloat"></div>
											</div>
										</div>
									</cfif>															
								</cfloop><!--- end of the newsYears loop --->
								
								
								 
							</div><!--- .coda-slider --->
						</div><!--- .coda-slider-wrapper --->			
					</div><!--- <<<< end #NCC --->
					
					

</cfoutput>