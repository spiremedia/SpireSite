<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><!-- interior 2 column -->
<cfinclude template="../headtag.cfm"/>
<cfsavecontent variable="pageHead">
	<link rel="stylesheet" href="/ui/css/typo.css" type="text/css" />
	<link rel="stylesheet" href="/ui/css/widgets.css" type="text/css"/>
	<script type="text/javascript" src="/ui/js/jquery-ui-1.7.1.min.js"></script>
	<script type="text/javascript" src="/ui/js/jquery.accordion.min.1.7.1.js"></script>
</cfsavecontent>
<cfhtmlhead text="#pageHead#">
<body>
	
	<div id="header">
		<div id="head">
			<div id="logo"><a href="/"></a></div>
			#showContentObject('dhtmlNav', 'Navigation', 'moduleaction=topnav')#
		</div><!-- end ##head -->
	</div><!-- end ##header2 -->
	
	<div id="mainWhat">
		<div id="main">
			<div id="WWD">					
				<div>
					<cfif contentObjectNotEmpty('middleItem_1_Content')>
						#showContentObject('middleItem_1_Content', 'HTMLContent,Assets,dhtmlPager,Events,Forms,News,ProductCatalog,SiteMaps,TextContent,Videos,Forms,MultiSpot,AssetImages', 'editable')#
					</cfif>
				</div>
				
				
<div class="bclear">
	<ul id="middleItem_1_Content_Accordion">
		<li ><a>Product Strategy and Business Analysis</a>
				<div class="bclear">
					<p>Our Strategy and BA team gathers relevant information about the product, its users, and the rules or logic that will be embedded in the user interface. These requirements and rules, in conjunction with the knowledge of the users gained through the User-Centered Design process, form the basis of our design and development decisions.</p>
				</div>
		</li>
		<li ><a>Content Strategy</a>
				<div class="bclear">
					<p>SpireMedia provides professional content-creation and messaging strategy services for Web and mobile applications. Our content strategists create, present, and maintain messaging that is relevant and enjoyable for users. We can also extend brand messaging across new channels and platforms, or produce new content to support an existing brand.</p>
				</div>
		</li>
		<li ><a>User Experience Design</a>
				<div class="bclear">
					<p>SpireMedia's UX Designers have years of experience in creating user interfaces for web and mobile products. We are experts in using user-centered methods to create detailed interface designs that enable products to be built quickly and accurately, while engaging and delighting users.</p>
				</div>
		</li>
		<li ><a>Information Architecture</a>
				<div class="bclear">
					<p>SpireMedia's Information Architects are skilled in organizing and labeling complex information, sites, and software to support usability and findability, and in the structural design of shared information environments.</p>
				</div>
		</li>
	</ul>
	<script type="text/javascript">
		jQuery.noConflict();
		jQuery(function(){
			jQuery("##middleItem_1_Content_Accordion").accordion({
				autoHeight: false, 
				active:false
			});
		});
	</script>
</div>

				
				
				
				
				
				
				
				
				
				
				
				
				
				
				<!--- 
				<div class="c2Container">
					<div class="middleItem">
						<div class="content">
							<div><br class="clear">
<div class="bclear">
	<ul role="tablist" class="ui-accordion ui-widget ui-helper-reset" id="middleContentItem1_Accordion">		
		<li class="ui-accordion-li-fix">
			<a tabindex="0" aria-expanded="true" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-state-focus"><span class="ui-icon ui-icon-triangle-1-e"></span>perferendis doloribus asperiores repellat</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active">
				<p>perferendis doloribus asperiores repellat</p>
					<table class="tabdata_striped" border="0">
					<tbody>
					<tr class="alt">
					<th class="first">hello</th> <th>goodby</th> <th>jhjhjhjhjh</th> <th>jhjhjh </th><th>jhjhj</th> <th class="last">jhjhjh</th>
					</tr>
					<tr class="first">
					<td>&nbsp;jh</td>
					<td>&nbsp;gjhgjhg</td>
					<td>&nbsp;jhgjhgj</td>
					<td>&nbsp;hgjhgjhg</td>
					<td>&nbsp;jhgjhg</td>
					<td>&nbsp;jhgjhgjh</td>
					</tr>
					<tr class="alt">
					<td>&nbsp;jhgjhg</td>
					<td>&nbsp;jhgjhg</td>
					<td>&nbsp;jhgjhgjhg</td>
					<td>&nbsp;jhgjhg</td>
					<td>&nbsp;jhgjhghjg</td>
					<td>&nbsp;gjhgjhg</td>
					</tr>
					</tbody>
					</table>
			</div>
		</li>		
		<li class="ui-accordion-li-fix">
			<a tabindex="0" aria-expanded="true" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-e"></span>perferendis doloribus asper</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active">
				<p>perferendis doloribus asperiores repellat</p>
			</div>
		</li>
	
		<li class="ui-accordion-li-fix">				
			<a tabindex="-1" aria-expanded="false" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-e"></span>doloribus asperiores repellat</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
				<p>perferendis doloribus asperiores repellat</p>
			</div>
		</li>
	
		<li class="ui-accordion-li-fix">
			<a tabindex="-1" aria-expanded="false" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-e"></span>doloribus asperiore</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
				<p>perferendis doloribus asperiores repellat</p>
			</div>
		</li>
	
		<li class="ui-accordion-li-fix">
			<a tabindex="-1" aria-expanded="false" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-e"></span>sapiente kljh lkj hkjhkljhlkjh  kjlgkj ygjkygjhkbhjbkjb kjh bkjhb kjhb delectus, ut aut reiciendis vkljklj dsfl;kj asf al;kjlkjha dsflkh dflk; jas;lkdoluptatibus maiores</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
				<p>this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp; this is content this is content.&nbsp;</p>
			</div>
		</li>
	
		<li class="ui-accordion-li-fix">
			<a tabindex="-1" aria-expanded="false" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-e"></span>delectus, ut aut reiciendis voluptatibus maiores</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
				<p>sapiente delectus, ut aut reiciendis voluptatibus maiores</p>
			</div>
		</li>
	
		<li class="ui-accordion-li-fix">
			<a tabindex="-1" aria-expanded="false" role="tab" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-accordion-header-last"><span class="ui-icon ui-icon-triangle-1-e"></span>sapiente delectibus maiores</a>
			<div style="display: none;" role="tabpanel" class="bclear ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
				<p>sapiente delectus, ut aut reiciendis voluptatibus maiores</p>
			</div>
		</li>
	</ul>
	<script type="text/javascript">
		$(function(){
			$("##middleContentItem1_Accordion").accordion({
				autoHeight: false, 
				active:0
			});
		});
	</script>
</div>
							</div>
								
							</div>
						</div>
					</div>
				</div>
			</div>
            <br class="clear"> --->
			
			
			
			
			
			
					<div class="clearfloat"></div>
			</div><!--  end ##WWD -->
		</div><!--  end ##main -->
	</div><!--  end ##mainWhat -->

	<!-- footer -->
	<cfinclude template="../footer.cfm">
	<!-- /footer -->	
	<cfinclude template="../contact.cfm">
</body>
</html>
</cfoutput>
