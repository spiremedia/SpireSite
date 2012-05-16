<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		
		<cfset variables.forminfo.name = "productreviews">
		
		<cfset variables.uo = requestObject.getUserObject()>

		<cfset variables.reviewsObj = createObject("component", "modules.reviews.models.reviews").init(requestObject)>
	
		<cfif requestObject.isRequestRegistryVarSet("productObj")>
			<cfset lcl.productObj = requestObject.getRequestRegistryVar("productObj")>
		<cfelse>
			<cfset lcl.productObj = createObject("component", "modules.productcatalog.models.product").init(requestObject)>
			<cfparam name="variables.formdata.moduleitemid" default="0">
			<cfset lcl.productObj.load(variables.formdata.moduleitemid)>
		</cfif>


		<cfset lcl.reviews = variables.reviewsObj.getReviews(lcl.productObj.getId(), requestObject.getFormUrlVar('sortsel', 'rating'), "DESC")>
	
		<cfset lcl.section = addItem("section")>
		<cfset lcl.section.setName('title')>
		<cfset lcl.section.setLabel('#lcl.reviews.recordcount# Ratings & Comments for : #lcl.productObj.getTitle()#')>
	
		<cfif variables.uo.isloggedin()>
			<cfset lcl.txt = addItem("hidden")>
			<cfset lcl.txt.setName('moduleitemid')>
			<cfset lcl.txt.setDefault(lcl.productObj.getId())>
			
			
			<cfset lcl.txt = lcl.section.addItem("html")>
			<cfset lcl.txt.setName('rating')>
            <cfsavecontent variable="lcl.dhtmlIcons">
            	<cfoutput>
                	<cfloop from=1 to=5 index="indx">
                    	<img id="ratingicon_#indx#"
                            onclick="highlighticon(#indx#);"
                        	class="ratingicon"
                            src="/ui/images/reviews/unchosen_icon.png">
                    </cfloop>
               </cfoutput>
            </cfsavecontent>
			<cfset lcl.txt.setHTML('<div class="lowerrating">Select your rating: #lcl.dhtmlIcons#</div>')>
			
			<cfset lcl.txt = lcl.section.addItem("Hidden")>
			<cfset lcl.txt.setName('rating')>
			<cfset lcl.txt.setLabel('Rating')>
            <cfset lcl.txt.setdefault(0)>
			<cfset lcl.txt.addValidation('isinteger')>
			<cfset lcl.txt.setRequired()>
			
			<cfset lcl.txt = lcl.section.addItem("TextArea")>
			<cfset lcl.txt.setName('comment')>
			<cfset lcl.txt.setLabel('<strong>Add Your Comment</strong>')>
			<cfset lcl.txt.maxlength(1000)>
            <cfset lcl.txt.setformstyle("width","598px")>
            <cfset lcl.txt.setformstyle("height","119px")>
			<cfset lcl.txt.setRequired()>
			
			<cfset lcl.txt = lcl.section.addItem("html")>
			<cfset lcl.txt.setName('ratingtype')>
			<cfset lcl.txt.setHTML('<div class="ratingtype">Add My Ratings & Comments to:</div>')>
			
			<cfset lcl.a = arraynew(1)>
			
			<cfset lcl.s = structnew()>
			<cfset lcl.s.label = "This Product Page">
			<cfset lcl.s.value = "product">
			
			<cfset arrayappend(lcl.a, lcl.s)>
			
			<cfset lcl.s = structnew()>
			<cfset lcl.s.label = "My Notes">
			<cfset lcl.s.value = "mynotes">
			<cfset arrayappend(lcl.a, lcl.s)>
			
			<cfset lcl.s = structnew()>
			<cfset lcl.s.label = "This Product Page & My Tasting Notes">
			<cfset lcl.s.value = "product and mynotes">
			<cfset arrayappend(lcl.a, lcl.s)>
			
			<cfloop array="#lcl.a#" index="lcl.opttype">
				<cfset lcl.txt = lcl.section.addItem("radioitem")>
				<cfset lcl.txt.setName("ratingaction")>
				<cfset lcl.txt.setDefault(lcl.opttype.value)>
                <cfset lcl.txt.setformstyle("border","none")>
                <cfset lcl.txt.setformstyle("margin-bottom","0")>
                <cfset lcl.txt.setformstyle("margin-top","-5px")>
                <cfset lcl.txt.addClassToForm("formitem_radio")>
				<cfset lcl.txt.setValidationLabel("Rating Action")>
				<cfset lcl.txt.setLabel(lcl.opttype.label)>
				<cfset lcl.txt.setRequired()>
			</cfloop>
	
    		<cfset lcl.s = addItem("imagebtn")>
			<cfset lcl.s.setSource('/ui/images/submitBtn.png')>
            <cfset lcl.s.setName('action')>
            <cfset lcl.s.setFormStyle("padding","0 0 0 15px")>
            <cfset lcl.s.setDefault('Submit')>
            
			<!---<cfset lcl.sbm = lcl.section.addItem("submit")>
			<cfset lcl.sbm.setDefault('Submit')>
			<cfset lcl.sbm.setName('loginbtn')>--->
		<cfelse>
			<cfset lcl.txt = addItem("html")>
			<cfset lcl.txt.setName('plslogin')>
			<cfset lcl.txt.setHTML('<p>Login to Post a Rating or Comment or Add Personal Tasting Notes</p>')>
	
			<cfset lcl.txt = addItem("html")>
			<cfset lcl.txt.setName('loginactions')>
			<cfset lcl.txt.setHTML('<p><a class="review_login_link" href="/user/login/?relocate=#urlencodedformat("/#requestObject.getFormUrlVar("path")#")#">&raquo; Login to your Applejack Account</a>  <a class="review_create_user_link" href="/user/create/?relocate=#urlencodedformat("/#requestObject.getFormUrlVar("path")#")#">&raquo; Create an Applejack Account</a></p>')>
		</cfif>
		
		<cfif lcl.reviews.recordcount>
			<cfset lcl.div = addItem("div")>
			<cfset lcl.div.setName("sortdiv")>
			<cfset lcl.div.setStyle("text-align","right")>
			
			<cfset lcl.sel = lcl.div.addItem("select")>
			<cfset lcl.sel.setName('sortsel')>
			<cfset lcl.sel.setLabel('')>
			<cfset lcl.sel.setFormStyle("margin","0 15px 0 0")>	
            <cfset lcl.sel.setFormStyle("width","100px")>
            <cfset lcl.sel.setFormStyle("position","relative")>
            <cfset lcl.sel.setFormStyle("top","-25px")>
			<cfset lcl.data = structnew()>
			<cfset lcl.data.query = querynew("label,value")>
		
			<cfset queryaddrow(lcl.data.query)>
			<cfset querysetcell(lcl.data.query, "label", "Sort By")>
			<cfset querysetcell(lcl.data.query, "value", "")>
			
			<cfset queryaddrow(lcl.data.query)>
			<cfset querysetcell(lcl.data.query, "label", "Date")>
			<cfset querysetcell(lcl.data.query, "value", "created")>
		
			<cfset queryaddrow(lcl.data.query)>
			<cfset querysetcell(lcl.data.query, "label", "Rating")>
			<cfset querysetcell(lcl.data.query, "value", "rating")>

			<cfset lcl.sel.setdata(lcl.data)>
			
			<cfset lcl.txt = lcl.div.addItem("javascript")>
			<cfset lcl.txt.setName('sortjs')>
			<cfset lcl.txt.setjavascript('jQuery(function(){jQuery("##sortsel").change(function(){location.href=''?sortsel='' + this.value;})})')>
		

			<cfset lcl.txt = lcl.div.addItem("seperator")>
			<cfset lcl.txt.setName('reviewlist')>
			<cfset lcl.txt.addClassToForm("fullwidthdottedhr")>
			<cfset lcl.txt.setFormStyle("margin-bottom","10px")>
            <cfset lcl.txt.setFormStyle("position","relative")>
            <cfset lcl.txt.setFormStyle("top","-10px")>
			<!--- <cfset lcl.txt.setHTML('<div class="reviewtype">Add My Ratings & Comments to:</div>')> --->
			
			<cfoutput>
			<cfloop query="lcl.reviews">
				<cfset lcl.txt = addItem("html")>
				<cfset lcl.txt.setName('reviewitem')>

				<cfsavecontent variable="lcl.r">
					<div class="review">
						<div class="reviewheader">
                            <div class="reviewdate right" style="width:200px">Review Date: #dateformat(lcl.reviews.created, "mmm dd, yyyy")# - #timeformat(lcl.reviews.created, "hh:mm tt")#</div>
                            #lcl.reviews.reviewername# | Rating: <img style="vertical-align:bottom;" src="/ui/images/reviews/reviews_stars_#lcl.reviews.rating#.png">
                        </div>
						<div class="reviewbody">#lcl.reviews.comments#</div>
					</div>		
				</cfsavecontent>

				<cfset lcl.txt.setHTML(lcl.r)>
			</cfloop>
			</cfoutput>
			
		<cfelse>
			<cfset lcl.txt = addItem("html")>
			<cfset lcl.txt.setName('norecordsmessage')>
			<cfset lcl.txt.setHTML('<br><br><p>There are currently no reviews for this product.</p>')>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
		<cfset var vdtr = super.validate(clear)>
		
		<cfif NOT variables.uo.isloggedin()>
			<cflocation url="/user/login/?relocate=#urlencodedformat(requestObject.getFormUrlVar("submitfrom"	))#">
		</cfif>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		<cfset var lcl = structnew()>
		<cfset variables.reviewsObj.setActive(0)>
		<cfset variables.reviewsObj.setModuleName('productCatalog')>
		<cfset variables.reviewsObj.setReviewerId(variables.uo.getUserId())>
		<cfset variables.reviewsObj.setRating(requestObject.getFormUrlVar("rating"))>
		<cfset variables.reviewsObj.setMode(requestObject.getFormUrlVar("ratingaction"))>
		<cfset variables.reviewsObj.setModuleItemId(requestObject.getFormUrlVar("moduleitemid"))>
		<cfset variables.reviewsObj.setReviewerName(variables.uo.getUserName())>
		<cfset variables.reviewsObj.setComments(requestObject.clean(requestObject.getFormUrlVar("comment")), 'plain')>
		
		<cfif NOT variables.reviewsObj.save()>
			<cfset vdtr = variables.reviewsObj.getValidator()>
		<cfelse>
			<cfset lcl.userinfo = variables.uo.getValues()>
			<cfset structappend(lcl.userinfo, variables.reviewsObj.getValues())>
			<cfset lcl.msg = createObject("component", "modules.messaging.models.messaging").init(requestObject)>
			<cfif requestObject.isVarSet("reviewsadmin")>
				<cfset lcl.to = requestObject.getVar("reviewsadmin")>
			<cfelse>
				<cfset lcl.to = requestObject.getVar("systememailto")>
			</cfif>

			<cfset lcl.msg.sendMessage(
				lcl.to,
				"User Review Admin Message",
				lcl.userinfo	
			)>
		</cfif>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = requestObject.getFormUrlVar("submitfrom")>
		<cfset s.message = "Thanks for Reviewing!  It may take a day for your review to post.">
		<cfreturn s>
	</cffunction>
</cfcomponent>